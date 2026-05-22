import { useEffect, useState } from 'react';
import { fetchMenu } from '../../../api/client';
import type { MenuCategory, MenuItem } from '../../../types';
import styles from './steps.module.css';

const CATEGORY_LABELS: Record<MenuCategory, string> = {
  potions:             'Potions',
  breuvages:           'Breuvages',
  infusions_froides:   'Infusions Froides',
  soupes_bouillons:    'Soupes & Bouillons',
  victuailles:         'Victuailles',
  pains_viennoiseries: 'Pains & Viennoiseries',
  fromages_affines:    'Fromages Affinés',
  desserts_douceurs:   'Desserts & Douceurs',
};

interface StepItemsProps {
  category: MenuCategory;
  itemCount: number;
  onSelect: (item: { id: number; name: string }) => void;
  onBack: () => void;
  onGoSummary: () => void;
}

export function StepItems({ category, itemCount, onSelect, onBack, onGoSummary }: StepItemsProps) {
  const [items, setItems] = useState<MenuItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    setError(null);
    fetchMenu(category)
      .then(data => {
        setItems(data);
        setLoading(false);
      })
      .catch((err: unknown) => {
        setError(err instanceof Error ? err.message : String(err));
        setLoading(false);
      });
  }, [category]);

  const label = CATEGORY_LABELS[category];

  return (
    <>
      <div className={styles.stepHeader}>
        <button className={styles.backBtn} onClick={onBack}>←</button>
        <h2 className={styles.modalTitle}>{label}</h2>
      </div>
      {error ? (
        <p className={styles.modalLoading}>Erreur : {error}</p>
      ) : loading ? (
        <p className={styles.modalLoading}>Chargement…</p>
      ) : (
        <div className={styles.itemGrid}>
          {items.map(item => (
            <button
              key={item.id}
              className={styles.itemBtn}
              onClick={() => onSelect({ id: item.id, name: item.name })}
            >
              {item.name}
              <span className={styles.itemPrice}>
                {item.price}&nbsp;<span className={styles.dragorIcon} />
              </span>
            </button>
          ))}
        </div>
      )}
      {itemCount > 0 && (
        <button className={styles.summaryBtn} onClick={onGoSummary}>
          Voir la commande ({itemCount} item{itemCount > 1 ? 's' : ''})
        </button>
      )}
    </>
  );
}
