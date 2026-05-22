import { useState } from 'react';
import styles from './steps.module.css';

interface StepQuantityProps {
  itemName: string;
  initialQuantity: number;
  isEditing: boolean;
  onConfirm: (quantity: number) => void;
  onCancel: () => void;
}

export function StepQuantity({ itemName, initialQuantity, isEditing, onConfirm, onCancel }: StepQuantityProps) {
  const [qtyStr, setQtyStr] = useState(String(initialQuantity));
  const [started, setStarted] = useState(false);

  function handleDigit(d: string) {
    if (!started) {
      setQtyStr(d);
      setStarted(true);
    } else {
      setQtyStr(q => q + d);
    }
  }

  function handlePlus() {
    setQtyStr(q => String((parseInt(q) || 0) + 1));
    setStarted(false);
  }

  function handleMinus() {
    setQtyStr(q => String(Math.max(0, (parseInt(q) || 0) - 1)));
    setStarted(false);
  }

  function handleCorrect() {
    setQtyStr(q => {
      const next = q.length <= 1 ? '0' : q.slice(0, -1);
      setStarted(next !== '0');
      return next;
    });
  }

  return (
    <>
      <h2 className={styles.modalTitle}>{itemName}</h2>
      <div className={styles.qtyDisplay}>{qtyStr}</div>
      <div className={styles.numpad}>
        {['1','2','3','4','5','6','7','8','9'].map(d => (
          <button key={d} className={styles.numpadBtn} onClick={() => handleDigit(d)}>{d}</button>
        ))}
        <button className={`${styles.numpadBtn} ${styles.numpadSpecial}`} onClick={handleMinus}>−</button>
        <button className={styles.numpadBtn} onClick={() => handleDigit('0')}>0</button>
        <button className={`${styles.numpadBtn} ${styles.numpadSpecial}`} onClick={handlePlus}>+</button>
      </div>
      <div className={styles.qtyFooter}>
        <button className={`${styles.btn} ${styles.btnSecondary}`} onClick={handleCorrect}>Corriger</button>
        <button className={`${styles.btn} ${styles.btnDanger}`} onClick={onCancel}>Annuler</button>
        <button className={`${styles.btn} ${styles.btnPrimary}`} onClick={() => onConfirm(parseInt(qtyStr) || 0)}>
          {isEditing ? 'Mettre à jour' : 'Valider'}
        </button>
      </div>
    </>
  );
}
