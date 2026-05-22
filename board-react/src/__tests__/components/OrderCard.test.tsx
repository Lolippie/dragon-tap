import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { vi, describe, it, expect } from 'vitest';
import { OrderCard } from '../../components/orders/OrderCard';
import type { Order } from '../../types';

function makeOrder(status: Order['status']): Order {
  return {
    id: 42,
    table_number: 7,
    status,
    created_at: '2024-01-01T14:30:00.000Z',
    items: [
      { order_item_id: 1, menu_item_id: 10, name: 'Bière', quantity: 2, note: 'fraîche', unit_price: '5.00' },
    ],
  };
}

describe('OrderCard', () => {
  it('renders table number and items', () => {
    render(<OrderCard order={makeOrder('pending')} onStatusChange={vi.fn()} />);
    expect(screen.getByText('Table 7')).toBeInTheDocument();
    expect(screen.getByText(/2.*Bière/)).toBeInTheDocument();
  });

  it('pending: shows preparing and cancel buttons', () => {
    render(<OrderCard order={makeOrder('pending')} onStatusChange={vi.fn()} />);
    expect(screen.getByText('Mettre en préparation')).toBeInTheDocument();
    expect(screen.getByText('Annuler')).toBeInTheDocument();
  });

  it('preparing: shows served button only', () => {
    render(<OrderCard order={makeOrder('preparing')} onStatusChange={vi.fn()} />);
    expect(screen.getByText('Marquer comme servi')).toBeInTheDocument();
    expect(screen.queryByText('Mettre en préparation')).toBeNull();
  });

  it('served: no action buttons', () => {
    render(<OrderCard order={makeOrder('served')} onStatusChange={vi.fn()} />);
    expect(screen.queryByRole('button')).toBeNull();
  });

  it('cancelled: no action buttons', () => {
    render(<OrderCard order={makeOrder('cancelled')} onStatusChange={vi.fn()} />);
    expect(screen.queryByRole('button')).toBeNull();
  });

  it('calls onStatusChange with preparing when preparing button clicked', async () => {
    const onStatusChange = vi.fn();
    render(<OrderCard order={makeOrder('pending')} onStatusChange={onStatusChange} />);
    await userEvent.click(screen.getByText('Mettre en préparation'));
    expect(onStatusChange).toHaveBeenCalledWith(42, 'preparing');
  });

  it('calls onStatusChange with cancelled when cancel button clicked', async () => {
    const onStatusChange = vi.fn();
    render(<OrderCard order={makeOrder('pending')} onStatusChange={onStatusChange} />);
    await userEvent.click(screen.getByText('Annuler'));
    expect(onStatusChange).toHaveBeenCalledWith(42, 'cancelled');
  });

  it('calls onStatusChange with served when served button clicked', async () => {
    const onStatusChange = vi.fn();
    render(<OrderCard order={makeOrder('preparing')} onStatusChange={onStatusChange} />);
    await userEvent.click(screen.getByText('Marquer comme servi'));
    expect(onStatusChange).toHaveBeenCalledWith(42, 'served');
  });
});
