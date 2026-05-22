import { useState } from 'react';
import { useMenu } from '../../hooks/useMenu';
import type { MenuCategory } from '../../types';
import { ErrorBanner } from '../ui/ErrorBanner';
import { MenuCard } from './MenuCard';
import styles from './MenuView.module.css';

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

export function MenuView() {
  const [category, setCategory] = useState<MenuCategory | undefined>(undefined);
  const { items, loading, error } = useMenu(category);

  return (
    <main className={styles.main}>
      {error && <ErrorBanner message={`Impossible de charger la carte\u00a0: ${error}`} />}
      <div className={styles.viewHeader}>
        <h2>La Carte</h2>
        <span className={styles.countLabel}>
          {items.length}&nbsp;référence{items.length > 1 ? 's' : ''}
        </span>
      </div>
      <div className={styles.filters}>
        <button
          className={`${styles.filterBtn} ${category === undefined ? styles.active : ''}`}
          onClick={() => setCategory(undefined)}
        >
          Tout
        </button>
        {CATEGORIES.map(cat => (
          <button
            key={cat}
            className={`${styles.filterBtn} ${category === cat ? styles.active : ''}`}
            onClick={() => setCategory(cat)}
          >
            {CATEGORY_LABELS[cat]}
          </button>
        ))}
      </div>
      {loading ? (
        <p className={styles.loading}>Chargement…</p>
      ) : (
        <div className={styles.grid}>
          {items.map(item => (
            <MenuCard key={item.id} item={item} />
          ))}
        </div>
      )}
    </main>
  );
}
