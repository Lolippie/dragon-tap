import styles from './steps.module.css';

interface StepTableProps {
  onSelect: (tableNumber: number) => void;
}

export function StepTable({ onSelect }: StepTableProps) {
  return (
    <>
      <h2 className={styles.modalTitle}>Quelle table ?</h2>
      <div className={styles.tableGrid}>
        {Array.from({ length: 24 }, (_, i) => i + 1).map(n => (
          <button key={n} className={styles.tableBtn} onClick={() => onSelect(n)}>
            {n}
          </button>
        ))}
      </div>
      <div className={styles.tableVipWrap}>
        <button className={`${styles.tableBtn} ${styles.tableVip}`} onClick={() => onSelect(418)}>
          VIP 418
        </button>
      </div>
    </>
  );
}
