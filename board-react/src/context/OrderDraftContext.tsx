import { createContext, useContext, useState } from 'react';
import type { ReactNode } from 'react';
import type { DraftItem, MenuCategory } from '../types';

interface OrderDraftState {
  isOpen: boolean;
  tableNumber: number | null;
  items: DraftItem[];
  currentStep: 1 | 2 | 3 | 4 | 5;
  currentCategory: MenuCategory | null;
  currentItem: { id: number; name: string } | null;
  editingItemIndex: number | null;
}

interface OrderDraftContextValue extends OrderDraftState {
  openModal: () => void;
  closeModal: () => void;
  setTableNumber: (n: number) => void;
  setCurrentCategory: (cat: MenuCategory | null) => void;
  setCurrentItem: (item: { id: number; name: string }) => void;
  setCurrentStep: (step: 1 | 2 | 3 | 4 | 5) => void;
  setEditingItemIndex: (i: number | null) => void;
  addItem: (item: DraftItem) => void;
  updateItemQuantity: (index: number, quantity: number) => void;
  updateItemNote: (index: number, note: string | null) => void;
  removeItem: (index: number) => void;
  reset: () => void;
}

const OrderDraftContext = createContext<OrderDraftContextValue | null>(null);

const initialState: OrderDraftState = {
  isOpen: false,
  tableNumber: null,
  items: [],
  currentStep: 1,
  currentCategory: null,
  currentItem: null,
  editingItemIndex: null,
};

export function OrderDraftProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<OrderDraftState>(initialState);

  function openModal() {
    setState({ ...initialState, isOpen: true });
  }

  function closeModal() {
    setState(s => ({ ...s, isOpen: false }));
  }

  function reset() {
    setState(initialState);
  }

  function setTableNumber(n: number) {
    setState(s => ({ ...s, tableNumber: n }));
  }

  function setCurrentCategory(cat: MenuCategory | null) {
    setState(s => ({ ...s, currentCategory: cat }));
  }

  function setCurrentItem(item: { id: number; name: string }) {
    setState(s => ({ ...s, currentItem: item }));
  }

  function setCurrentStep(step: 1 | 2 | 3 | 4 | 5) {
    setState(s => ({ ...s, currentStep: step }));
  }

  function setEditingItemIndex(i: number | null) {
    setState(s => ({ ...s, editingItemIndex: i }));
  }

  function addItem(item: DraftItem) {
    setState(s => ({ ...s, items: [...s.items, item] }));
  }

  function updateItemQuantity(index: number, quantity: number) {
    setState(s => {
      const items = [...s.items];
      items[index] = { ...items[index], quantity };
      return { ...s, items };
    });
  }

  function updateItemNote(index: number, note: string | null) {
    setState(s => {
      const items = [...s.items];
      items[index] = { ...items[index], note };
      return { ...s, items };
    });
  }

  function removeItem(index: number) {
    setState(s => ({ ...s, items: s.items.filter((_, i) => i !== index) }));
  }

  const value: OrderDraftContextValue = {
    ...state,
    openModal,
    closeModal,
    setTableNumber,
    setCurrentCategory,
    setCurrentItem,
    setCurrentStep,
    setEditingItemIndex,
    addItem,
    updateItemQuantity,
    updateItemNote,
    removeItem,
    reset,
  };

  return (
    <OrderDraftContext.Provider value={value}>
      {children}
    </OrderDraftContext.Provider>
  );
}

export function useOrderDraftContext(): OrderDraftContextValue {
  const ctx = useContext(OrderDraftContext);
  if (!ctx) {
    throw new Error('useOrderDraftContext must be used inside OrderDraftProvider');
  }
  return ctx;
}
