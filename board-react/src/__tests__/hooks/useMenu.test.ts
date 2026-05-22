import { renderHook, waitFor } from '@testing-library/react';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { useMenu } from '../../hooks/useMenu';
import * as client from '../../api/client';
import type { MenuItem } from '../../types';

vi.mock('../../api/client');

const mockItems: MenuItem[] = [
  {
    id: 1,
    name: 'Potion de Clarté',
    category: 'potions',
    type: 'liquid',
    price: '12.50',
    description: 'Un liquide bleuté.',
  },
];

describe('useMenu', () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it('starts with loading true and empty items', () => {
    vi.mocked(client.fetchMenu).mockReturnValue(new Promise(() => {}));
    const { result } = renderHook(() => useMenu());
    expect(result.current.loading).toBe(true);
    expect(result.current.items).toEqual([]);
    expect(result.current.error).toBeNull();
  });

  it('exposes items after successful fetch', async () => {
    vi.mocked(client.fetchMenu).mockResolvedValue(mockItems);
    const { result } = renderHook(() => useMenu());
    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(result.current.items).toEqual(mockItems);
    expect(result.current.error).toBeNull();
  });

  it('exposes error when fetch fails', async () => {
    vi.mocked(client.fetchMenu).mockRejectedValue(new Error('Server error'));
    const { result } = renderHook(() => useMenu());
    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(result.current.error).toBe('Server error');
    expect(result.current.items).toEqual([]);
  });

  it('filters by category', async () => {
    vi.mocked(client.fetchMenu).mockResolvedValue(mockItems);
    const { result } = renderHook(() => useMenu('potions'));
    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(client.fetchMenu).toHaveBeenCalledWith('potions');
  });
});
