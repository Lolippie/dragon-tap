import { useState } from 'react';
import type { DraftItem } from '../../../types';
import styles from './steps.module.css';

interface StepSummaryProps {
  tableNumber: number;
  items: DraftItem[];
  submitError: string | null;
  onAddItem: () => void;
  onEditItem: (index: number) => void;
  onDeleteItem: (index: number) => void;
  onNoteChange: (index: number, note: string | null) => void;
  onSubmit: () => void;
}

export function StepSummary({
  tableNumber,
  items,
  submitError,
  onAddItem,
  onEditItem,
  onDeleteItem,
  onNoteChange,
  onSubmit,
}: StepSummaryProps) {
  const [openNoteIndex, setOpenNoteIndex] = useState<number | null>(null);
  const [noteValues, setNoteValues] = useState<Record<number, string>>(() =>
    Object.fromEntries(items.map((item, i) => [i, item.note ?? '']))
  );

  const tableLabel = tableNumber === 418 ? 'VIP 418' : tableNumber;
  const isEmpty = items.length === 0;

  function toggleNote(i: number) {
    setOpenNoteIndex(prev => (prev === i ? null : i));
  }

  function handleNoteOk(i: number) {
    const val = noteValues[i]?.trim() || null;
    onNoteChange(i, val);
    setOpenNoteIndex(null);
  }

  return (
    <>
      <h2 className={styles.modalTitle}>Commande — Table {tableLabel}</h2>
      <div className={styles.summaryList}>
        {isEmpty ? (
          <p className={styles.orderEmpty}>Aucun item — ajoutez des articles à la commande</p>
        ) : (
          items.map((item, i) => (
            <div key={i} className={styles.summaryItem}>
              <div className={styles.summaryItemMain}>
                <span className={styles.summaryQty}>{item.quantity}&times;</span>
                <span className={styles.summaryName}>{item.name}</span>
                {item.note && (
                  <span className={styles.summaryNoteIndicator}>✎ {item.note}</span>
                )}
                <div className={styles.summaryItemBtns}>
                  <button
                    className={`${styles.btnSm} ${item.note ? styles.btnSmHasNote : ''}`}
                    title="Note"
                    onClick={() => toggleNote(i)}
                  >
                    ✎
                  </button>
                  <button className={styles.btnSm} onClick={() => onEditItem(i)}>
                    Modifier
                  </button>
                  <button
                    className={`${styles.btnSm} ${styles.btnSmDanger}`}
                    onClick={() => onDeleteItem(i)}
                  >
                    Supprimer
                  </button>
                </div>
              </div>
              <div className={`${styles.noteField} ${openNoteIndex === i ? styles.noteFieldOpen : ''}`}>
                <input
                  type="text"
                  className={styles.noteInput}
                  value={noteValues[i] ?? ''}
                  placeholder="Ajouter une note…"
                  onChange={e => setNoteValues(v => ({ ...v, [i]: e.target.value }))}
                  onKeyDown={e => { if (e.key === 'Enter') handleNoteOk(i); }}
                />
                <button className={styles.btnNoteOk} onClick={() => handleNoteOk(i)}>✓</button>
              </div>
            </div>
          ))
        )}
      </div>
      {submitError && <div className={styles.modalError}>{submitError}</div>}
      <div className={styles.summaryFooter}>
        <button className={`${styles.btn} ${styles.btnSecondary}`} onClick={onAddItem}>
          Ajouter un item
        </button>
        <button
          className={`${styles.btn} ${styles.btnPrimary}`}
          disabled={isEmpty}
          onClick={onSubmit}
        >
          Valider la commande
        </button>
      </div>
    </>
  );
}
