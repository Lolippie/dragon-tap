import type { Order, OrderStatus } from '../../types';
import styles from './OrderCard.module.css';

const BADGE_CLASS: Record<OrderStatus, string> = {
  pending:   styles.badgePending,
  preparing: styles.badgePreparing,
  served:    styles.badgeServed,
  cancelled: styles.badgeCancelled,
};

const STATUS_LABELS: Record<OrderStatus, string> = {
  pending:   'En attente',
  preparing: 'En préparation',
  served:    'Servi',
  cancelled: 'Annulé',
};

interface OrderCardProps {
  order: Order;
  onStatusChange: (id: number, status: OrderStatus) => void;
}

export function OrderCard({ order, onStatusChange }: OrderCardProps) {
  const time = new Date(order.created_at).toLocaleTimeString('fr-FR', {
    hour: '2-digit',
    minute: '2-digit',
  });

  return (
    <article className={styles.card}>
      <div className={styles.cardHeader}>
        <span className={styles.tableNumber}>Table {order.table_number}</span>
        <span className={`${styles.badge} ${BADGE_CLASS[order.status]}`}>
          {STATUS_LABELS[order.status]}
        </span>
        <span className={styles.orderTime}>{time}</span>
      </div>
      <ul className={styles.itemList}>
        {order.items.map(item => (
          <li key={item.order_item_id}>
            {item.quantity}&nbsp;&times;&nbsp;{item.name}
            {item.note && <> &mdash; <em>{item.note}</em></>}
          </li>
        ))}
      </ul>
      {order.status === 'pending' && (
        <div className={styles.cardActions}>
          <button
            className={`${styles.btn} ${styles.btnPrimary}`}
            onClick={() => onStatusChange(order.id, 'preparing')}
          >
            Mettre en préparation
          </button>
          <button
            className={`${styles.btn} ${styles.btnDanger}`}
            onClick={() => onStatusChange(order.id, 'cancelled')}
          >
            Annuler
          </button>
        </div>
      )}
      {order.status === 'preparing' && (
        <div className={styles.cardActions}>
          <button
            className={`${styles.btn} ${styles.btnSuccess}`}
            onClick={() => onStatusChange(order.id, 'served')}
          >
            Marquer comme servi
          </button>
        </div>
      )}
    </article>
  );
}
