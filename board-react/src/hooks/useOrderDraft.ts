import { createOrder } from '../api/client';
import { useOrderDraftContext } from '../context/OrderDraftContext';
import type { MenuCategory } from '../types';

export function useOrderDraft() {
  const ctx = useOrderDraftContext();

  async function submitOrder(): Promise<void> {
    if (!ctx.tableNumber) throw new Error('Aucune table sélectionnée');
    if (ctx.items.length === 0) throw new Error('Aucun item dans la commande');

    await createOrder({
      table_number: ctx.tableNumber,
      items: ctx.items.map(item => ({
        menu_item_id: item.menuItemId,
        quantity: item.quantity,
        note: item.note,
      })),
    });

    ctx.reset();
  }

  function goToStep(step: 1 | 2 | 3 | 4 | 5) {
    ctx.setCurrentStep(step);
  }

  function selectTable(tableNumber: number) {
    ctx.setTableNumber(tableNumber);
    ctx.setCurrentStep(2);
  }

  function selectCategory(category: MenuCategory) {
    ctx.setCurrentCategory(category);
    ctx.setCurrentStep(3);
  }

  function selectItem(item: { id: number; name: string }) {
    ctx.setCurrentItem(item);
    ctx.setEditingItemIndex(null);
    ctx.setCurrentStep(4);
  }

  function confirmQuantity(quantity: number) {
    const { editingItemIndex, currentItem } = ctx;
    if (quantity === 0 && editingItemIndex !== null) {
      ctx.removeItem(editingItemIndex);
      ctx.setEditingItemIndex(null);
      ctx.setCurrentStep(5);
    } else if (quantity === 0) {
      ctx.setCurrentStep(3);
    } else if (editingItemIndex !== null) {
      ctx.updateItemQuantity(editingItemIndex, quantity);
      ctx.setEditingItemIndex(null);
      ctx.setCurrentStep(5);
    } else if (currentItem) {
      ctx.addItem({ menuItemId: currentItem.id, name: currentItem.name, quantity, note: null });
      ctx.setCurrentItem({ id: 0, name: '' });
      ctx.setCurrentStep(3);
    }
  }

  function startEditItem(index: number) {
    const item = ctx.items[index];
    ctx.setCurrentItem({ id: item.menuItemId, name: item.name });
    ctx.setEditingItemIndex(index);
    ctx.setCurrentStep(4);
  }

  return {
    ...ctx,
    goToStep,
    selectTable,
    selectCategory,
    selectItem,
    confirmQuantity,
    startEditItem,
    submitOrder,
  };
}
