export type MenuCategory =
  | 'potions'
  | 'breuvages'
  | 'infusions_froides'
  | 'soupes_bouillons'
  | 'victuailles'
  | 'pains_viennoiseries'
  | 'fromages_affines'
  | 'desserts_douceurs';

export type OrderStatus = 'pending' | 'preparing' | 'served' | 'cancelled';

export interface MenuItem {
  id: number;
  name: string;
  category: MenuCategory;
  type: 'liquid' | 'solid';
  price: string;
  description: string;
}

export interface OrderItem {
  order_item_id: number;
  menu_item_id: number;
  name: string;
  quantity: number;
  note: string | null;
  unit_price: string;
}

export interface Order {
  id: number;
  table_number: number;
  status: OrderStatus;
  created_at: string;
  items: OrderItem[];
}

export interface DraftItem {
  menuItemId: number;
  name: string;
  quantity: number;
  note: string | null;
}

export interface CreateOrderPayload {
  table_number: number;
  items: { menu_item_id: number; quantity: number; note: string | null }[];
}
