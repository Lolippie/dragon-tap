const { Router } = require('express');
const { pool } = require('../db');

const router = Router();

const VALID_CATEGORIES = [
  'potions', 'breuvages', 'infusions_froides', 'soupes_bouillons',
  'victuailles', 'pains_viennoiseries', 'fromages_affines', 'desserts_douceurs',
];

router.get('/', async (req, res, next) => {
  try {
    const { category } = req.query;

    if (category !== undefined && !VALID_CATEGORIES.includes(category)) {
      return res.status(400).json({
        error: 'Validation failed',
        details: [{ field: 'category', message: `must be one of: ${VALID_CATEGORIES.join(', ')}` }],
      });
    }

    const params = [];
    let sql = 'SELECT id, name, category, type, price::text AS price, description FROM menu_items';
    if (category) {
      sql += ' WHERE category = $1';
      params.push(category);
    }
    sql += ' ORDER BY id';

    const result = await pool.query(sql, params);
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

router.get('/:id', async (req, res, next) => {
  try {
    const id = parseInt(req.params.id, 10);
    if (isNaN(id) || id < 1) {
      return res.status(404).json({ error: 'Not found' });
    }

    const result = await pool.query(
      'SELECT id, name, category, type, price::text AS price, description FROM menu_items WHERE id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
