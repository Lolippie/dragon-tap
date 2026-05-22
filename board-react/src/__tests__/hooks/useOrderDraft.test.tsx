import { renderHook, act } from '@testing-library/react';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { useOrderDraft } from '../../hooks/useOrderDraft';
import { OrderDraftProvider } from '../../context/OrderDraftContext';
import * as client from '../../api/client';
import type { Order } from '../../types';

vi.mock('../../api/client');

const wrapper = ({ children }: { children: React.ReactNode }) => (
  <OrderDraftProvider>{children}</OrderDraftProvider>
);

const mockOrder: Order = {
  id: 1,
  table_number: 3,
  status: 'pending',
  created_at: '2024-01-01T12:00:00.000Z',
  items: [],
};

describe('useOrderDraft', () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it('starts with empty items and null tableNumber', () => {
    const { result } = renderHook(() => useOrderDraft(), { wrapper });
    expect(result.current.items).toEqual([]);
    expect(result.current.tableNumber).toBeNull();
  });

  it('selectTable sets table and goes to step 2', () => {
    const { result } = renderHook(() => useOrderDraft(), { wrapper });
    act(() => result.current.selectTable(5));
    expect(result.current.tableNumber).toBe(5);
    expect(result.current.currentStep).toBe(2);
  });

  it('addItem and removeItem work correctly', () => {
    const { result } = renderHook(() => useOrderDraft(), { wrapper });
    act(() => result.current.addItem({ menuItemId: 1, name: 'Potion', quantity: 2, note: null }));
    expect(result.current.items).toHaveLength(1);
    act(() => result.current.removeItem(0));
    expect(result.current.items).toHaveLength(0);
  });

  it('submitOrder calls createOrder with correct payload', async () => {
    vi.mocked(client.createOrder).mockResolvedValue(mockOrder);
    const { result } = renderHook(() => useOrderDraft(), { wrapper });
    act(() => {
      result.current.selectTable(3);
      result.current.addItem({ menuItemId: 42, name: 'Bière', quantity: 3, note: 'fraîche' });
    });
    await act(async () => { await result.current.submitOrder(); });
    expect(client.createOrder).toHaveBeenCalledWith({
      table_number: 3,
      items: [{ menu_item_id: 42, quantity: 3, note: 'fraîche' }],
    });
  });

  it('submitOrder throws when items are empty', async () => {
    const { result } = renderHook(() => useOrderDraft(), { wrapper });
    act(() => result.current.selectTable(3));
    await expect(
      act(async () => { await result.current.submitOrder(); })
    ).rejects.toThrow('Aucun item dans la commande');
  });
});
