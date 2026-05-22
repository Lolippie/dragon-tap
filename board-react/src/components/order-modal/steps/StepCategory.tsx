import type { MenuCategory } from '../../../types';
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

const CATEGORIES = Object.keys(CATEGORY_LABELS) as MenuCategory[];

interface StepCategoryProps {
  itemCount: number;
  onSelect: (category: MenuCategory) => void;
  onGoSummary: () => void;
}

export function StepCategory({ itemCount, onSelect, onGoSummary }: StepCategoryProps) {
  return (
    <>
      <h2 className={styles.modalTitle}>Choisir une catégorie</h2>
      <div className={styles.categoryGrid}>
        {CATEGORIES.map(cat => (
          <button key={cat} className={styles.categoryBtn} onClick={() => onSelect(cat)}>
            {CATEGORY_LABELS[cat]}
          </button>
        ))}
      </div>
      {itemCount > 0 && (
        <button className={styles.summaryBtn} onClick={onGoSummary}>
          Voir la commande ({itemCount} item{itemCount > 1 ? 's' : ''})
        </button>
      )}
    </>
  );
}
