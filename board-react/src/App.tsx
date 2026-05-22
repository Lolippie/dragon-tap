import { useState, useCallback } from 'react';
import { NavBar } from './components/layout/NavBar';
import type { View } from './components/layout/NavBar';
import { OrdersView } from './components/orders/OrdersView';
import { MenuView } from './components/menu/MenuView';
import { OrderModal } from './components/order-modal/OrderModal';
import { ToastContainer } from './components/ui/Toast';
import type { ToastMessage } from './components/ui/Toast';
import { OrderDraftProvider, useOrderDraftContext } from './context/OrderDraftContext';
import styles from './App.module.css';

let toastIdCounter = 0;

function AppInner() {
  const [view, setView] = useState<View>('orders');
  const [toasts, setToasts] = useState<ToastMessage[]>([]);
  const ctx = useOrderDraftContext();

  const addToast = useCallback((message: string, type: 'success' | 'error') => {
    const id = ++toastIdCounter;
    setToasts(t => [...t, { id, message, type }]);
  }, []);

  const removeToast = useCallback((id: number) => {
    setToasts(t => t.filter(toast => toast.id !== id));
  }, []);

  function handleOrderCreated(tableLabel: string) {
    addToast(`✓ Commande envoyée — Table ${tableLabel}`, 'success');
  }

  return (
    <div className={styles.app}>
      <NavBar currentView={view} onViewChange={setView} />
      {view === 'orders' ? (
        <OrdersView onNewOrder={ctx.openModal} onToast={addToast} />
      ) : (
        <MenuView />
      )}
      <OrderModal onOrderCreated={handleOrderCreated} />
      <ToastContainer toasts={toasts} onRemove={removeToast} />
    </div>
  );
}

export default function App() {
  return (
    <OrderDraftProvider>
      <AppInner />
    </OrderDraftProvider>
  );
}
