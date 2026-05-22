import { useEffect, useRef, useState } from 'react';
import styles from './Toast.module.css';

export interface ToastMessage {
  id: number;
  message: string;
  type: 'success' | 'error';
}

interface ToastItemProps {
  toast: ToastMessage;
  onRemove: (id: number) => void;
}

function ToastItem({ toast, onRemove }: ToastItemProps) {
  const [visible, setVisible] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const frame = requestAnimationFrame(() => {
      requestAnimationFrame(() => setVisible(true));
    });
    const timer = setTimeout(() => {
      setVisible(false);
      const el = ref.current;
      if (el) {
        el.addEventListener('transitionend', () => onRemove(toast.id), { once: true });
      } else {
        onRemove(toast.id);
      }
    }, 3000);
    return () => {
      cancelAnimationFrame(frame);
      clearTimeout(timer);
    };
  }, [toast.id, onRemove]);

  return (
    <div
      ref={ref}
      className={`${styles.toast} ${styles[toast.type]} ${visible ? styles.show : ''}`}
    >
      {toast.message}
    </div>
  );
}

interface ToastContainerProps {
  toasts: ToastMessage[];
  onRemove: (id: number) => void;
}

export function ToastContainer({ toasts, onRemove }: ToastContainerProps) {
  return (
    <div className={styles.container}>
      {toasts.map(t => (
        <ToastItem key={t.id} toast={t} onRemove={onRemove} />
      ))}
    </div>
  );
}
