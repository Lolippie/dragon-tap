import { useCallback, useEffect, useState } from 'react';
import { fetchOrders } from '../api/client';
import type { Order, OrderStatus } from '../types';

interface UseOrdersResult {
  orders: Order[];
  loading: boolean;
  error: string | null;
  refresh: () => void;
}

export function useOrders(status?: OrderStatus): UseOrdersResult {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(() => {
    setLoading(true);
    setError(null);
    fetchOrders(status)
      .then(data => {
        setOrders(data);
        setLoading(false);
      })
      .catch((err: unknown) => {
        setError(err instanceof Error ? err.message : String(err));
        setLoading(false);
      });
  }, [status]);

  useEffect(() => {
    load();
  }, [load]);

  return { orders, loading, error, refresh: load };
}
