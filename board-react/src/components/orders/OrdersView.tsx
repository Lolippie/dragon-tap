import { useCallback } from 'react';
import { updateOrderStatus } from '../../api/client';
import { useOrders } from '../../hooks/useOrders';
import type { OrderStatus } from '../../types';
import { ErrorBanner } from '../ui/ErrorBanner';
import { StatusSection } from './StatusSection';
import styles from './OrdersView.module.css';

const STATUS_ORDER: OrderStatus[] = ['pending', 'preparing', 'served', 'cancelled'];

const STATUS_LABELS: Record<OrderStatus, string> = {
  pending:   'En attente',
  preparing: 'En préparation',
  served:    'Servi',
  cancelled: 'Annulé',
};

interface OrdersViewProps {
  onNewOrder: () => void;
  onToast: (message: string, type: 'success' | 'error') => void;
}

export function OrdersView({ onNewOrder, onToast }: OrdersViewProps) {
  const { orders, loading, error, refresh } = useOrders();

  const handleStatusChange = useCallback(
    async (id: number, status: OrderStatus) => {
      try {
        await updateOrderStatus(id, status);
        refresh();
      } catch (err) {
        onToast(`Erreur\u00a0: ${err instanceof Error ? err.message : String(err)}`, 'error');
      }
    },
    [refresh, onToast],
  );

  const grouped = Object.fromEntries(STATUS_ORDER.map(s => [s, [] as typeof orders])) as Record<OrderStatus, typeof orders>;
  for (const order of orders) {
    if (grouped[order.status]) grouped[order.status].push(order);
  }

  return (
    <main className={styles.main}>
      {error && <ErrorBanner message={`Impossible de charger les commandes\u00a0: ${error}`} />}
      <div className={styles.viewHeader}>
        <h2>Commandes</h2>
        <div className={styles.headerActions}>
          <button className={`${styles.btn} ${styles.btnPrimary}`} onClick={onNewOrder}>
            Nouvelle commande
          </button>
          <button className={`${styles.btn} ${styles.btnSecondary}`} onClick={refresh}>
            Actualiser
          </button>
        </div>
      </div>
      {loading ? (
        <p className={styles.loading}>Chargement…</p>
      ) : (
        STATUS_ORDER.map(status => (
          <StatusSection
            key={status}
            status={status}
            label={STATUS_LABELS[status]}
            orders={grouped[status]}
            onStatusChange={handleStatusChange}
          />
        ))
      )}
    </main>
  );
}
