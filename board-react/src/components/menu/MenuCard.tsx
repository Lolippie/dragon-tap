import type { MenuItem, MenuCategory } from '../../types';
import styles from './MenuCard.module.css';

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

interface MenuCardProps {
  item: MenuItem;
}

export function MenuCard({ item }: MenuCardProps) {
  return (
    <article className={styles.card}>
      <div className={styles.cardHeader}>
        <span className={styles.name}>{item.name}</span>
        <span className={styles.price}>
          {item.price}&nbsp;<span className={styles.dragorIcon} />
        </span>
      </div>
      <div className={styles.meta}>
        <span className={styles.category}>
          {CATEGORY_LABELS[item.category] ?? item.category}
        </span>
      </div>
      <p className={styles.description}>{item.description}</p>
    </article>
  );
}
