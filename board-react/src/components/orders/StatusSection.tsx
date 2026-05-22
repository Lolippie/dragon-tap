import type { Order, OrderStatus } from '../../types';
import { OrderCard } from './OrderCard';
import styles from './StatusSection.module.css';

const BADGE_CLASS: Record<OrderStatus, string> = {
  pending:   styles.badgePending,
  preparing: styles.badgePreparing,
  served:    styles.badgeServed,
  cancelled: styles.badgeCancelled,
};

interface StatusSectionProps {
  status: OrderStatus;
  label: string;
  orders: Order[];
  onStatusChange: (id: number, status: OrderStatus) => void;
}

export function StatusSection({ status, label, orders, onStatusChange }: StatusSectionProps) {
  return (
    <section className={styles.section}>
      <h3 className={styles.title}>
        <span className={`${styles.badge} ${BADGE_CLASS[status]}`}>{label}</span>
        <span className={styles.count}>{orders.length}</span>
      </h3>
      {orders.length === 0 ? (
        <p className={styles.empty}>Aucune commande</p>
      ) : (
        orders.map(order => (
          <OrderCard key={order.id} order={order} onStatusChange={onStatusChange} />
        ))
      )}
    </section>
  );
}
