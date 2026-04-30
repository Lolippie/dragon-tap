const API_URL = 'http://localhost:4181';

const CATEGORY_LABELS = {
  potions:             'Potions',
  breuvages:           'Breuvages',
  infusions_froides:   'Infusions Froides',
  soupes_bouillons:    'Soupes & Bouillons',
  victuailles:         'Victuailles',
  pains_viennoiseries: 'Pains & Viennoiseries',
  fromages_affines:    'Fromages Affinés',
  desserts_douceurs:   'Desserts & Douceurs',
};

const STATUS_LABELS = {
  pending:   'En attente',
  preparing: 'En préparation',
  served:    'Servi',
  cancelled: 'Annulé',
};

const STATUS_ORDER = ['pending', 'preparing', 'served', 'cancelled'];
const CATEGORIES   = Object.keys(CATEGORY_LABELS);

let currentView     = 'orders';
let currentCategory = null;

const app = document.getElementById('app');

// ── Helpers ───────────────────────────────────────────────────

function showError(message) {
  const existing = document.getElementById('error-banner');
  if (existing) existing.remove();
  const banner = document.createElement('div');
  banner.id = 'error-banner';
  banner.className = 'error-banner';
  banner.textContent = message;
  app.prepend(banner);
  setTimeout(() => banner.remove(), 6000);
}

function setLoading() {
  app.innerHTML = '<div class="loading">Chargement\u2026</div>';
}

async function apiFetch(path, options = {}) {
  const res = await fetch(API_URL + path, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new Error(body.error || `HTTP ${res.status}`);
  }
  return res.json();
}

// ── Orders view ───────────────────────────────────────────────

async function loadOrders() {
  setLoading();
  try {
    const orders = await apiFetch('/api/orders');
    renderOrders(orders);
  } catch (err) {
    app.innerHTML = '';
    showError(`Impossible de charger les commandes\u00a0: ${err.message}`);
  }
}

function renderOrders(orders) {
  const grouped = {};
  for (const s of STATUS_ORDER) grouped[s] = [];
  for (const o of orders) {
    if (grouped[o.status]) grouped[o.status].push(o);
  }

  let html = `
    <div class="view-header">
      <h2>Commandes</h2>
      <div class="view-header-actions">
        <button class="btn btn-primary" id="new-order-btn">Nouvelle commande</button>
        <button class="btn btn-secondary" id="refresh-btn">Actualiser</button>
      </div>
    </div>
  `;

  for (const status of STATUS_ORDER) {
    const list = grouped[status];
    html += `
      <section class="status-section">
        <h3 class="status-title">
          <span class="badge badge-${status}">${STATUS_LABELS[status]}</span>
          <span class="status-count">${list.length}</span>
        </h3>`;
    if (list.length === 0) {
      html += `<p class="empty">Aucune commande</p>`;
    } else {
      for (const order of list) {
        html += renderOrderCard(order);
      }
    }
    html += `</section>`;
  }

  app.innerHTML = html;

  document.getElementById('new-order-btn').addEventListener('click', openOrderModal);
  document.getElementById('refresh-btn').addEventListener('click', loadOrders);
  app.querySelectorAll('[data-action]').forEach(btn => {
    btn.addEventListener('click', handleOrderAction);
  });
}

function renderOrderCard(order) {
  const time = new Date(order.created_at).toLocaleTimeString('fr-FR', {
    hour: '2-digit',
    minute: '2-digit',
  });

  const itemsHtml = order.items.map(item => {
    const note = item.note ? ` \u2014 <em>${item.note}</em>` : '';
    return `<li>${item.quantity}\u00a0\u00d7\u00a0${item.name}${note}</li>`;
  }).join('');

  let actionsHtml = '';
  if (order.status === 'pending') {
    actionsHtml = `
      <div class="card-actions">
        <button class="btn btn-primary" data-action="preparing" data-id="${order.id}">Mettre en pr\u00e9paration</button>
        <button class="btn btn-danger"  data-action="cancelled" data-id="${order.id}">Annuler</button>
      </div>`;
  } else if (order.status === 'preparing') {
    actionsHtml = `
      <div class="card-actions">
        <button class="btn btn-success" data-action="served" data-id="${order.id}">Marquer comme servi</button>
      </div>`;
  }

  return `
    <article class="order-card">
      <div class="card-header">
        <span class="table-number">Table ${order.table_number}</span>
        <span class="badge badge-${order.status}">${STATUS_LABELS[order.status]}</span>
        <span class="order-time">${time}</span>
      </div>
      <ul class="item-list">${itemsHtml}</ul>
      ${actionsHtml}
    </article>`;
}

async function handleOrderAction(e) {
  const btn    = e.currentTarget;
  const action = btn.dataset.action;
  const id     = btn.dataset.id;
  btn.disabled = true;
  try {
    await apiFetch(`/api/orders/${id}/status`, {
      method: 'PATCH',
      body: JSON.stringify({ status: action }),
    });
    await loadOrders();
  } catch (err) {
    showError(`Erreur\u00a0: ${err.message}`);
    btn.disabled = false;
  }
}

// ── Menu view ─────────────────────────────────────────────────

async function loadMenu(category) {
  currentCategory = category ?? null;
  setLoading();
  try {
    const url = currentCategory ? `/api/menu?category=${currentCategory}` : '/api/menu';
    const items = await apiFetch(url);
    renderMenu(items);
  } catch (err) {
    app.innerHTML = '';
    showError(`Impossible de charger la carte\u00a0: ${err.message}`);
  }
}

function renderMenu(items) {
  const filtersHtml = [
    `<button class="filter-btn${currentCategory === null ? ' active' : ''}" data-cat="">Tout</button>`,
    ...CATEGORIES.map(cat =>
      `<button class="filter-btn${currentCategory === cat ? ' active' : ''}" data-cat="${cat}">${CATEGORY_LABELS[cat]}</button>`
    ),
  ].join('');

  const cardsHtml = items.map(item => `
    <article class="menu-card">
      <div class="menu-card-header">
        <span class="menu-name">${item.name}</span>
        <span class="menu-price">${item.price}\u00a0d</span>
      </div>
      <div class="menu-meta">
        <span class="menu-category">${CATEGORY_LABELS[item.category] || item.category}</span>
      </div>
      <p class="menu-desc">${item.description}</p>
    </article>
  `).join('');

  const count = items.length;
  app.innerHTML = `
    <div class="view-header">
      <h2>La Carte</h2>
      <span class="count-label">${count}\u00a0r\u00e9f\u00e9rence${count > 1 ? 's' : ''}</span>
    </div>
    <div class="filters">${filtersHtml}</div>
    <div class="menu-grid">${cardsHtml}</div>
  `;

  app.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', () => loadMenu(btn.dataset.cat || null));
  });
}

// ── Order flow ─────────────────────────────────────────────────

const orderState = {
  table_number: null,
  items: [],
  currentStep: 1,
  currentCategory: null,
  currentItem: null,
  editingItemIndex: null,
};

let _orderQtyStr = '1';
let _numpadStarted = false;

function resetOrderState() {
  orderState.table_number = null;
  orderState.items = [];
  orderState.currentStep = 1;
  orderState.currentCategory = null;
  orderState.currentItem = null;
  orderState.editingItemIndex = null;
}

function getOrCreateModal() {
  let overlay = document.getElementById('order-modal-overlay');
  if (!overlay) {
    overlay = document.createElement('div');
    overlay.id = 'order-modal-overlay';
    overlay.className = 'modal-overlay';
    overlay.innerHTML = `
      <div class="modal-box">
        <button class="modal-close" id="modal-close-btn">✕</button>
        <div id="modal-content"></div>
      </div>
    `;
    document.body.appendChild(overlay);
    document.getElementById('modal-close-btn').addEventListener('click', closeOrderModal);
  }
  return overlay;
}

function openOrderModal() {
  resetOrderState();
  const overlay = getOrCreateModal();
  overlay.classList.add('open');
  renderStep();
}

function closeOrderModal() {
  const overlay = document.getElementById('order-modal-overlay');
  if (overlay) overlay.classList.remove('open');
}

function renderStep() {
  switch (orderState.currentStep) {
    case 1: renderStep1(); break;
    case 2: renderStep2(); break;
    case 3: goToStep3(); break;
    case 4: renderStep4(); break;
    case 5: renderStep5(); break;
  }
}

// ── Step 1 — Table ─────────────────────────────────────────────
function renderStep1() {
  const content = document.getElementById('modal-content');
  let tableButtons = '';
  for (let i = 1; i <= 24; i++) {
    tableButtons += `<button class="table-btn" data-table="${i}">${i}</button>`;
  }
  content.innerHTML = `
    <h2 class="modal-title">Quelle table ?</h2>
    <div class="table-grid">${tableButtons}</div>
    <div class="table-vip-wrap">
      <button class="table-btn table-vip" data-table="418">VIP 418</button>
    </div>
  `;
  content.querySelectorAll('.table-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      orderState.table_number = parseInt(btn.dataset.table);
      orderState.currentStep = 2;
      renderStep();
    });
  });
}

// ── Step 2 — Category ──────────────────────────────────────────
function renderStep2() {
  const content = document.getElementById('modal-content');
  const buttonsHtml = CATEGORIES.map(cat =>
    `<button class="category-btn" data-cat="${cat}">${CATEGORY_LABELS[cat]}</button>`
  ).join('');
  const summaryBtn = orderState.items.length > 0
    ? `<button class="btn btn-secondary order-summary-btn" id="go-summary-btn">Voir la commande (${orderState.items.length} item${orderState.items.length > 1 ? 's' : ''})</button>`
    : '';
  content.innerHTML = `
    <h2 class="modal-title">Choisir une catégorie</h2>
    <div class="category-grid">${buttonsHtml}</div>
    ${summaryBtn}
  `;
  content.querySelectorAll('.category-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      orderState.currentCategory = btn.dataset.cat;
      orderState.currentStep = 3;
      goToStep3();
    });
  });
  const goSummary = document.getElementById('go-summary-btn');
  if (goSummary) {
    goSummary.addEventListener('click', () => {
      orderState.currentStep = 5;
      renderStep();
    });
  }
}

// ── Step 3 — Item ──────────────────────────────────────────────
async function goToStep3() {
  const content = document.getElementById('modal-content');
  const label = CATEGORY_LABELS[orderState.currentCategory] || orderState.currentCategory;
  const summaryBtn = orderState.items.length > 0
    ? `<button class="btn btn-secondary order-summary-btn" id="go-summary-btn3">Voir la commande (${orderState.items.length} item${orderState.items.length > 1 ? 's' : ''})</button>`
    : '';
  content.innerHTML = `
    <div class="modal-step-header">
      <button class="back-btn" id="step3-back">←</button>
      <h2 class="modal-title">${label}</h2>
    </div>
    <div class="item-grid"><p class="modal-loading">Chargement\u2026</p></div>
    ${summaryBtn}
  `;
  document.getElementById('step3-back').addEventListener('click', () => {
    orderState.currentStep = 2;
    renderStep();
  });
  const goSummary3 = document.getElementById('go-summary-btn3');
  if (goSummary3) {
    goSummary3.addEventListener('click', () => {
      orderState.currentStep = 5;
      renderStep();
    });
  }
  try {
    const items = await apiFetch(`/api/menu?category=${orderState.currentCategory}`);
    const grid = content.querySelector('.item-grid');
    grid.innerHTML = items.map(item =>
      `<button class="item-btn" data-id="${item.id}" data-name="${encodeURIComponent(item.name)}">${item.name}<span class="item-price">${item.price}\u00a0d</span></button>`
    ).join('');
    grid.querySelectorAll('.item-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        orderState.currentItem = { id: parseInt(btn.dataset.id), name: decodeURIComponent(btn.dataset.name) };
        orderState.editingItemIndex = null;
        orderState.currentStep = 4;
        renderStep();
      });
    });
  } catch (err) {
    showToast(`Erreur\u00a0: ${err.message}`, 'error');
    orderState.currentStep = 2;
    renderStep();
  }
}

// ── Step 4 — Quantity ──────────────────────────────────────────
function renderStep4() {
  if (orderState.editingItemIndex !== null) {
    _orderQtyStr = String(orderState.items[orderState.editingItemIndex].quantity);
  } else {
    _orderQtyStr = '1';
  }
  _numpadStarted = false;
  renderStep4UI();
}

function renderStep4UI() {
  const content = document.getElementById('modal-content');
  content.innerHTML = `
    <h2 class="modal-title">${orderState.currentItem.name}</h2>
    <div class="qty-display">${_orderQtyStr}</div>
    <div class="numpad">
      <button class="numpad-btn" data-digit="1">1</button>
      <button class="numpad-btn" data-digit="2">2</button>
      <button class="numpad-btn" data-digit="3">3</button>
      <button class="numpad-btn" data-digit="4">4</button>
      <button class="numpad-btn" data-digit="5">5</button>
      <button class="numpad-btn" data-digit="6">6</button>
      <button class="numpad-btn" data-digit="7">7</button>
      <button class="numpad-btn" data-digit="8">8</button>
      <button class="numpad-btn" data-digit="9">9</button>
      <button class="numpad-btn numpad-minus" id="qty-minus">\u2212</button>
      <button class="numpad-btn" data-digit="0">0</button>
      <button class="numpad-btn numpad-plus" id="qty-plus">+</button>
    </div>
    <div class="qty-footer">
      <button class="btn btn-secondary" id="qty-correct">Corriger</button>
      <button class="btn btn-danger" id="qty-cancel">Annuler</button>
      <button class="btn btn-primary" id="qty-validate">Valider</button>
    </div>
  `;

  content.querySelectorAll('[data-digit]').forEach(btn => {
    btn.addEventListener('click', () => {
      const d = btn.dataset.digit;
      if (!_numpadStarted) {
        _orderQtyStr = d;
        _numpadStarted = true;
      } else {
        _orderQtyStr += d;
      }
      renderStep4UI();
    });
  });

  document.getElementById('qty-plus').addEventListener('click', () => {
    _orderQtyStr = String((parseInt(_orderQtyStr) || 0) + 1);
    _numpadStarted = false;
    renderStep4UI();
  });

  document.getElementById('qty-minus').addEventListener('click', () => {
    _orderQtyStr = String(Math.max(0, (parseInt(_orderQtyStr) || 0) - 1));
    _numpadStarted = false;
    renderStep4UI();
  });

  document.getElementById('qty-correct').addEventListener('click', () => {
    if (_orderQtyStr.length <= 1) {
      _orderQtyStr = '0';
    } else {
      _orderQtyStr = _orderQtyStr.slice(0, -1);
    }
    _numpadStarted = _orderQtyStr !== '0';
    renderStep4UI();
  });

  document.getElementById('qty-cancel').addEventListener('click', () => {
    if (orderState.editingItemIndex !== null) {
      orderState.editingItemIndex = null;
      orderState.currentStep = 5;
    } else {
      orderState.currentStep = 3;
    }
    renderStep();
  });

  document.getElementById('qty-validate').addEventListener('click', () => {
    const qty = parseInt(_orderQtyStr) || 0;
    if (qty === 0 && orderState.editingItemIndex !== null) {
      orderState.items.splice(orderState.editingItemIndex, 1);
      orderState.editingItemIndex = null;
      orderState.currentStep = 5;
      renderStep();
    } else if (qty === 0) {
      orderState.currentStep = 3;
      renderStep();
    } else if (orderState.editingItemIndex !== null) {
      orderState.items[orderState.editingItemIndex].quantity = qty;
      orderState.editingItemIndex = null;
      orderState.currentStep = 5;
      renderStep();
    } else {
      orderState.items.push({
        menu_item_id: orderState.currentItem.id,
        name: orderState.currentItem.name,
        quantity: qty,
        note: null,
      });
      orderState.currentItem = null;
      orderState.currentStep = 3;
      renderStep();
    }
  });
}

// ── Step 5 — Summary ───────────────────────────────────────────
function renderStep5() {
  const content = document.getElementById('modal-content');
  const tableLabel = orderState.table_number === 418 ? 'VIP 418' : orderState.table_number;
  const isEmpty = orderState.items.length === 0;

  const itemsHtml = isEmpty
    ? `<p class="order-empty">Aucun item \u2014 ajoutez des articles \u00e0 la commande</p>`
    : orderState.items.map((item, i) => `
        <div class="summary-item">
          <div class="summary-item-main">
            <span class="summary-qty">${item.quantity}\u00d7</span>
            <span class="summary-name">${item.name}</span>
            ${item.note ? `<span class="summary-note-indicator">\u270e ${item.note}</span>` : ''}
            <div class="summary-item-btns">
              <button class="btn-sm${item.note ? ' has-note' : ''}" data-note="${i}" title="Note">\u270e</button>
              <button class="btn-sm" data-edit="${i}">Modifier</button>
              <button class="btn-sm btn-sm-danger" data-del="${i}">Supprimer</button>
            </div>
          </div>
          <div class="note-field" id="note-field-${i}">
            <input type="text" class="note-input" id="note-input-${i}" value="${item.note || ''}" placeholder="Ajouter une note\u2026">
            <button class="btn-note-ok" data-note-ok="${i}">\u2713</button>
          </div>
        </div>
      `).join('');

  content.innerHTML = `
    <h2 class="modal-title">Commande \u2014 Table ${tableLabel}</h2>
    <div class="summary-list">${itemsHtml}</div>
    <div id="modal-submit-error" class="modal-error"></div>
    <div class="summary-footer">
      <button class="btn btn-secondary" id="add-item-btn">Ajouter un item</button>
      <button class="btn btn-primary" id="validate-order-btn"${isEmpty ? ' disabled' : ''}>Valider la commande</button>
    </div>
  `;

  content.querySelectorAll('[data-note]').forEach(btn => {
    btn.addEventListener('click', () => {
      const i = parseInt(btn.dataset.note);
      const field = document.getElementById(`note-field-${i}`);
      const isOpen = field.classList.toggle('open');
      if (isOpen) document.getElementById(`note-input-${i}`).focus();
    });
  });

  content.querySelectorAll('[data-note-ok]').forEach(btn => {
    btn.addEventListener('click', () => {
      const i = parseInt(btn.dataset.noteOk);
      orderState.items[i].note = document.getElementById(`note-input-${i}`).value.trim() || null;
      renderStep5();
    });
  });

  content.querySelectorAll('.note-input').forEach(input => {
    input.addEventListener('keydown', e => {
      if (e.key === 'Enter') {
        const i = parseInt(input.id.replace('note-input-', ''));
        orderState.items[i].note = input.value.trim() || null;
        renderStep5();
      }
    });
  });

  content.querySelectorAll('[data-edit]').forEach(btn => {
    btn.addEventListener('click', () => {
      const i = parseInt(btn.dataset.edit);
      orderState.editingItemIndex = i;
      orderState.currentItem = { id: orderState.items[i].menu_item_id, name: orderState.items[i].name };
      orderState.currentStep = 4;
      renderStep();
    });
  });

  content.querySelectorAll('[data-del]').forEach(btn => {
    btn.addEventListener('click', () => {
      orderState.items.splice(parseInt(btn.dataset.del), 1);
      renderStep5();
    });
  });

  document.getElementById('add-item-btn').addEventListener('click', () => {
    orderState.currentCategory = null;
    orderState.currentStep = 2;
    renderStep();
  });

  if (!isEmpty) {
    document.getElementById('validate-order-btn').addEventListener('click', async () => {
      const validateBtn = document.getElementById('validate-order-btn');
      validateBtn.disabled = true;
      const errDiv = document.getElementById('modal-submit-error');
      errDiv.textContent = '';
      try {
        await apiFetch('/api/orders', {
          method: 'POST',
          body: JSON.stringify({
            table_number: orderState.table_number,
            items: orderState.items.map(({ menu_item_id, quantity, note }) => ({ menu_item_id, quantity, note })),
          }),
        });
        const label = orderState.table_number === 418 ? 'VIP 418' : orderState.table_number;
        closeOrderModal();
        resetOrderState();
        showToast(`\u2713 Commande envoy\u00e9e \u2014 Table ${label}`, 'success');
        loadOrders();
      } catch (err) {
        errDiv.textContent = `Erreur\u00a0: ${err.message}`;
        validateBtn.disabled = false;
      }
    });
  }
}

// ── Toast ──────────────────────────────────────────────────────
function showToast(message, type = 'success') {
  let container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'toast-container';
    document.body.appendChild(container);
  }
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.textContent = message;
  container.appendChild(toast);
  requestAnimationFrame(() => requestAnimationFrame(() => toast.classList.add('show')));
  setTimeout(() => {
    toast.classList.remove('show');
    toast.addEventListener('transitionend', () => toast.remove(), { once: true });
  }, 3000);
}

// ── Navigation ────────────────────────────────────────────────

function switchView(view) {
  currentView = view;
  document.querySelectorAll('.nav-tab').forEach(tab => {
    tab.classList.toggle('active', tab.dataset.view === view);
  });
  if (view === 'orders') {
    loadOrders();
  } else {
    loadMenu(null);
  }
}

document.querySelectorAll('.nav-tab').forEach(tab => {
  tab.addEventListener('click', () => switchView(tab.dataset.view));
});

// Init
switchView('orders');
