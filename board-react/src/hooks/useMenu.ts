import { useEffect, useState } from 'react';
import { fetchMenu } from '../api/client';
import type { MenuItem, MenuCategory } from '../types';

interface UseMenuResult {
  items: MenuItem[];
  loading: boolean;
  error: string | null;
}

export function useMenu(category?: MenuCategory): UseMenuResult {
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

  return { items, loading, error };
}
