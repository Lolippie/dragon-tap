const { Router } = require('express');
const { pool } = require('../db');

const router = Router();

const VALID_STATUSES = ['pending', 'preparing', 'served', 'cancelled'];

const STATUS_TRANSITIONS = {
  pending: ['preparing', 'cancelled'],
  preparing: ['served'],
  served: [],
  cancelled: [],
};

const ORDER_SQL = `
  SELECT
    o.id,
    o.table_number,
    o.status,
    o.created_at,
    COALESCE(
      json_agg(
        json_build_object(
          'order_item_id', oi.id,
          'menu_item_id', oi.menu_item_id,
          'name', mi.name,
          'quantity', oi.quantity,
          'note', oi.note,
          'unit_price', mi.price::text
        ) ORDER BY oi.id
      ) FILTER (WHERE oi.id IS NOT NULL),
      '[]'::json
    ) AS items
  FROM orders o
  LEFT JOIN order_items oi ON o.id = oi.order_id
  LEFT JOIN menu_items mi ON oi.menu_item_id = mi.id
`;

async function fetchOrder(db, id) {
  const result = await db.query(
    ORDER_SQL + ' WHERE o.id = $1 GROUP BY o.id, o.table_number, o.status, o.created_at',
    [id]
  );
  return result.rows[0] || null;
}

// GET /api/orders
router.get('/', async (req, res, next) => {
  try {
    const { status } = req.query;

    if (status !== undefined && !VALID_STATUSES.includes(status)) {
      return res.status(400).json({
        error: 'Validation failed',
        details: [{ field: 'status', message: `must be one of: ${VALID_STATUSES.join(', ')}` }],
      });
    }

    const params = [];
    let sql = ORDER_SQL;
    if (status) {
      sql += ' WHERE o.status = $1';
      params.push(status);
    }
    sql += ' GROUP BY o.id, o.table_number, o.status, o.created_at ORDER BY o.id';

    const result = await pool.query(sql, params);
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

// POST /api/orders
router.post('/', async (req, res, next) => {
  const client = await pool.connect();
  try {
    const { table_number, items } = req.body;
    const details = [];

    if (
      table_number === undefined ||
      table_number === null ||
      !Number.isInteger(table_number) ||
      table_number < 1
    ) {
      details.push({ field: 'table_number', message: 'must be a positive integer' });
    }

    if (!Array.isArray(items) || items.length === 0) {
      details.push({ field: 'items', message: 'must contain at least one item' });
    } else {
      items.forEach((item, i) => {
        if (
          !Number.isInteger(item.menu_item_id) ||
          item.menu_item_id < 1
        ) {
          details.push({ field: `items[${i}].menu_item_id`, message: 'must be a positive integer' });
        }
        if (!Number.isInteger(item.quantity) || item.quantity < 1) {
          details.push({ field: `items[${i}].quantity`, message: 'must be a positive integer' });
        }
      });
    }

    if (details.length > 0) {
      return res.status(400).json({ error: 'Validation failed', details });
    }

    // Validate all menu_item_ids exist in one query
    const menuItemIds = [...new Set(items.map((i) => i.menu_item_id))];
    const existsResult = await client.query(
      'SELECT id FROM menu_items WHERE id = ANY($1)',
      [menuItemIds]
    );
    const foundIds = new Set(existsResult.rows.map((r) => r.id));
    const missingIds = menuItemIds.filter((id) => !foundIds.has(id));

    if (missingIds.length > 0) {
      return res.status(400).json({
        error: 'Validation failed',
        details: missingIds.map((id) => ({
          field: 'menu_item_id',
          message: `item ${id} not found`,
        })),
      });
    }

    await client.query('BEGIN');

    const orderResult = await client.query(
      "INSERT INTO orders (table_number, status) VALUES ($1, 'pending') RETURNING id",
      [table_number]
    );
    const orderId = orderResult.rows[0].id;

    for (const item of items) {
      await client.query(
        'INSERT INTO order_items (order_id, menu_item_id, quantity, note) VALUES ($1, $2, $3, $4)',
        [orderId, item.menu_item_id, item.quantity, item.note ?? null]
      );
    }

    await client.query('COMMIT');

    const order = await fetchOrder(client, orderId);
    res.status(201).json(order);
  } catch (err) {
    await client.query('ROLLBACK').catch(() => {});
    next(err);
  } finally {
    client.release();
  }
});

// GET /api/orders/:id
router.get('/:id', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    if (isNaN(id) || id < 1) {
      return res.status(404).json({ error: 'Not found' });
    }
    const order = await fetchOrder(pool, id);
    if (!order) {
      return res.status(404).json({ error: 'Not found' });
    }
    res.json(order);
  } catch (err) {
    next(err);
  }
});

// PATCH /api/orders/:id/status
router.patch('/:id/status', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    if (isNaN(id) || id < 1) {
      return res.status(404).json({ error: 'Not found' });
    }

    const { status } = req.body;

    const current = await pool.query('SELECT status FROM orders WHERE id = $1', [id]);
    if (current.rows.length === 0) {
      return res.status(404).json({ error: 'Not found' });
    }

    const currentStatus = current.rows[0].status;
    const allowed = STATUS_TRANSITIONS[currentStatus] ?? [];

    if (!allowed.includes(status)) {
      return res.status(422).json({
        error: 'Invalid transition',
        current: currentStatus,
        requested: status,
        allowed,
      });
    }

    await pool.query('UPDATE orders SET status = $1 WHERE id = $2', [status, id]);

    const order = await fetchOrder(pool, id);
    res.json(order);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
