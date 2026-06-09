import type { MenuItem, Order, OrderStatus, MenuCategory, CreateOrderPayload } from '../types';


async function apiFetch<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch( path, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  if (!res.ok) {
    const body = await res.json().catch(() => ({})) as { error?: string };
    throw new Error(body.error ?? `HTTP ${res.status}`);
  }
  return res.json() as Promise<T>;
}

export async function fetchOrders(status?: OrderStatus): Promise<Order[]> {
  const query = status ? `?status=${status}` : '';
  return apiFetch<Order[]>(`/api/orders${query}`);
}

export async function fetchMenu(category?: MenuCategory): Promise<MenuItem[]> {
  const query = category ? `?category=${category}` : '';
  return apiFetch<MenuItem[]>(`/api/menu${query}`);
}

export async function createOrder(payload: CreateOrderPayload): Promise<Order> {
  return apiFetch<Order>('/api/orders', {
    method: 'POST',
    body: JSON.stringify(payload),
  });
}

export async function updateOrderStatus(id: number, status: OrderStatus): Promise<Order> {
  return apiFetch<Order>(`/api/orders/${id}/status`, {
    method: 'PATCH',
    body: JSON.stringify({ status }),
  });
}
