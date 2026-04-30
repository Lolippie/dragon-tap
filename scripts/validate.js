// Validation script — DragonTap API
// Usage : node scripts/validate.js
// Requires Node 18+ (native fetch)

const BASE = 'http://localhost:4181';

let passed = 0;
let failed = 0;

async function request(method, path, body) {
  const options = { method, headers: { 'Content-Type': 'application/json' } };
  if (body !== undefined) options.body = JSON.stringify(body);
  const res = await fetch(BASE + path, options);
  let json = null;
  try { json = await res.json(); } catch { /* non-JSON body */ }
  return { status: res.status, body: json };
}

function pass(label) {
  console.log(`[PASS] ${label}`);
  passed++;
}

function fail(label, reason) {
  console.log(`[FAIL] ${label}${reason ? ` — ${reason}` : ''}`);
  failed++;
}

async function test(label, fn) {
  try {
    let resolved = false;
    await fn(
      () => { if (!resolved) { resolved = true; pass(label); } },
      (reason) => { if (!resolved) { resolved = true; fail(label, reason); } }
    );
    if (!resolved) fail(label, 'aucun résultat émis');
  } catch (err) {
    fail(label, `exception : ${err.message}`);
  }
}

async function run() {
  // 1 — Health
  await test('GET /api/health → 200', async (ok, ko) => {
    const { status, body } = await request('GET', '/api/health');
    if (status === 200 && body?.status === 'ok' && body?.db === 'connected') ok();
    else ko(`status=${status}, body.status=${body?.status}, body.db=${body?.db}`);
  });

  // 2 — Menu complet
  await test('GET /api/menu → 200, 418 items', async (ok, ko) => {
    const { status, body } = await request('GET', '/api/menu');
    if (status === 200 && Array.isArray(body) && body.length === 418) ok();
    else ko(`status=${status}, ${body?.length} items`);
  });

  // 3 — Filtre catégorie valide
  await test('GET /api/menu?category=potions → 200, tous category=potions', async (ok, ko) => {
    const { status, body } = await request('GET', '/api/menu?category=potions');
    if (status !== 200 || !Array.isArray(body)) return ko(`status=${status}`);
    const allMatch = body.length > 0 && body.every(i => i.category === 'potions');
    if (allMatch) ok();
    else ko(`${body.length} items, allMatch=${allMatch}`);
  });

  // 4 — Filtre catégorie invalide
  await test('GET /api/menu?category=invalid → 400', async (ok, ko) => {
    const { status } = await request('GET', '/api/menu?category=invalid');
    if (status === 400) ok();
    else ko(`expected 400, got ${status}`);
  });

  // 5 — Item existant
  await test('GET /api/menu/1 → 200, item présent', async (ok, ko) => {
    const { status, body } = await request('GET', '/api/menu/1');
    if (status === 200 && body?.id === 1) ok();
    else ko(`status=${status}, id=${body?.id}`);
  });

  // 6 — Item inexistant
  await test('GET /api/menu/99999 → 404', async (ok, ko) => {
    const { status } = await request('GET', '/api/menu/99999');
    if (status === 404) ok();
    else ko(`expected 404, got ${status}`);
  });

  // 7 — Liste commandes
  await test('GET /api/orders → 200, ≥4 commandes', async (ok, ko) => {
    const { status, body } = await request('GET', '/api/orders');
    if (status === 200 && Array.isArray(body) && body.length >= 4) ok();
    else ko(`status=${status}, ${body?.length} commandes`);
  });

  // 8 — Filtre statut valide
  await test('GET /api/orders?status=pending → 200, tous status=pending', async (ok, ko) => {
    const { status, body } = await request('GET', '/api/orders?status=pending');
    if (status !== 200 || !Array.isArray(body)) return ko(`status=${status}`);
    const allMatch = body.every(o => o.status === 'pending');
    if (allMatch) ok();
    else ko('certains orders ont un statut différent de pending');
  });

  // 9 — Filtre statut invalide
  await test('GET /api/orders?status=invalid → 400', async (ok, ko) => {
    const { status } = await request('GET', '/api/orders?status=invalid');
    if (status === 400) ok();
    else ko(`expected 400, got ${status}`);
  });

  // 10 — Commande existante avec items
  await test('GET /api/orders/1 → 200, commande avec items', async (ok, ko) => {
    const { status, body } = await request('GET', '/api/orders/1');
    if (status === 200 && body?.id === 1 && Array.isArray(body?.items)) ok();
    else ko(`status=${status}`);
  });

  // 11 — Commande inexistante
  await test('GET /api/orders/99999 → 404', async (ok, ko) => {
    const { status } = await request('GET', '/api/orders/99999');
    if (status === 404) ok();
    else ko(`expected 404, got ${status}`);
  });

  // 12 — Créer commande valide
  await test('POST /api/orders valide → 201, status=pending', async (ok, ko) => {
    const { status, body } = await request('POST', '/api/orders', {
      table_number: 9,
      items: [
        { menu_item_id: 12, quantity: 1, note: 'sans oignons' },
        { menu_item_id: 47, quantity: 2 },
      ],
    });
    if (status === 201 && body?.status === 'pending' && Array.isArray(body?.items)) ok();
    else ko(`status=${status}, body.status=${body?.status}`);
  });

  // 13 — table_number manquant
  await test('POST /api/orders sans table_number → 400', async (ok, ko) => {
    const { status } = await request('POST', '/api/orders', {
      items: [{ menu_item_id: 1, quantity: 1 }],
    });
    if (status === 400) ok();
    else ko(`expected 400, got ${status}`);
  });

  // 14 — items vide
  await test('POST /api/orders items=[] → 400', async (ok, ko) => {
    const { status } = await request('POST', '/api/orders', {
      table_number: 1,
      items: [],
    });
    if (status === 400) ok();
    else ko(`expected 400, got ${status}`);
  });

  // 15 — menu_item_id inexistant
  await test('POST /api/orders menu_item_id=99999 → 400', async (ok, ko) => {
    const { status } = await request('POST', '/api/orders', {
      table_number: 1,
      items: [{ menu_item_id: 99999, quantity: 1 }],
    });
    if (status === 400) ok();
    else ko(`expected 400, got ${status}`);
  });

  // 16 — Transition valide pending → preparing
  await test('PATCH /api/orders/1/status preparing → 200', async (ok, ko) => {
    const { status, body } = await request('PATCH', '/api/orders/1/status', { status: 'preparing' });
    if (status === 200 && body?.status === 'preparing') ok();
    else ko(`status=${status}, body.status=${body?.status}`);
  });

  // 17 — Transition invalide (preparing → pending)
  await test('PATCH /api/orders/1/status pending → 422', async (ok, ko) => {
    const { status } = await request('PATCH', '/api/orders/1/status', { status: 'pending' });
    if (status === 422) ok();
    else ko(`expected 422, got ${status}`);
  });

  // 18 — Transition valide preparing → served
  await test('PATCH /api/orders/2/status served → 200', async (ok, ko) => {
    const { status, body } = await request('PATCH', '/api/orders/2/status', { status: 'served' });
    if (status === 200 && body?.status === 'served') ok();
    else ko(`status=${status}, body.status=${body?.status}`);
  });

  // 19 — Transition invalide depuis served (terminal)
  await test('PATCH /api/orders/3/status pending → 422', async (ok, ko) => {
    const { status } = await request('PATCH', '/api/orders/3/status', { status: 'pending' });
    if (status === 422) ok();
    else ko(`expected 422, got ${status}`);
  });

  // 20 — Commande inexistante
  await test('PATCH /api/orders/99999/status preparing → 404', async (ok, ko) => {
    const { status } = await request('PATCH', '/api/orders/99999/status', { status: 'preparing' });
    if (status === 404) ok();
    else ko(`expected 404, got ${status}`);
  });

  // Bilan
  const total = passed + failed;
  console.log(`\n${passed}/${total} tests passés`);
  process.exit(failed === 0 ? 0 : 1);
}

run().catch(err => {
  console.error('Erreur fatale :', err.message);
  process.exit(1);
});
