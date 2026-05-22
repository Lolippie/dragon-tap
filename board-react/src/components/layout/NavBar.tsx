import styles from './NavBar.module.css';

export type View = 'orders' | 'menu';

interface NavBarProps {
  currentView: View;
  onViewChange: (view: View) => void;
}

export function NavBar({ currentView, onViewChange }: NavBarProps) {
  return (
    <header className={styles.header}>
      <span className={styles.title}>L'Antre des 418 Dragons</span>
      <nav className={styles.tabs}>
        <button
          className={`${styles.tab} ${currentView === 'orders' ? styles.active : ''}`}
          onClick={() => onViewChange('orders')}
        >
          Commandes
        </button>
        <button
          className={`${styles.tab} ${currentView === 'menu' ? styles.active : ''}`}
          onClick={() => onViewChange('menu')}
        >
          La Carte
        </button>
      </nav>
      <span className={styles.versionTag}>version React</span>
    </header>
  );
}
