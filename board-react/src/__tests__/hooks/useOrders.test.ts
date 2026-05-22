import { renderHook, waitFor } from '@testing-library/react';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { useOrders } from '../../hooks/useOrders';
import * as client from '../../api/client';
import type { Order } from '../../types';

vi.mock('../../api/client');

const mockOrders: Order[] = [
  {
    id: 1,
    table_number: 3,
    status: 'pending',
    created_at: '2024-01-01T12:00:00.000Z',
    items: [],
  },
];

describe('useOrders', () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it('starts with loading true and empty orders', () => {
    vi.mocked(client.fetchOrders).mockReturnValue(new Promise(() => {}));
    const { result } = renderHook(() => useOrders());
    expect(result.current.loading).toBe(true);
    expect(result.current.orders).toEqual([]);
    expect(result.current.error).toBeNull();
  });

  it('exposes orders after successful fetch', async () => {
    vi.mocked(client.fetchOrders).mockResolvedValue(mockOrders);
    const { result } = renderHook(() => useOrders());
    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(result.current.orders).toEqual(mockOrders);
    expect(result.current.error).toBeNull();
  });

  it('exposes error when fetch fails', async () => {
    vi.mocked(client.fetchOrders).mockRejectedValue(new Error('Network error'));
    const { result } = renderHook(() => useOrders());
    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(result.current.error).toBe('Network error');
    expect(result.current.orders).toEqual([]);
  });

  it('refresh re-fetches orders', async () => {
    vi.mocked(client.fetchOrders).mockResolvedValue(mockOrders);
    const { result } = renderHook(() => useOrders());
    await waitFor(() => expect(result.current.loading).toBe(false));
    result.current.refresh();
    await waitFor(() => expect(client.fetchOrders).toHaveBeenCalledTimes(2));
  });
});
