import { useState } from 'react';
import { useOrderDraftContext } from '../../context/OrderDraftContext';
import type { MenuCategory } from '../../types';
import { StepTable } from './steps/StepTable';
import { StepCategory } from './steps/StepCategory';
import { StepItems } from './steps/StepItems';
import { StepQuantity } from './steps/StepQuantity';
import { StepSummary } from './steps/StepSummary';
import styles from './OrderModal.module.css';
import { createOrder } from '../../api/client';

interface OrderModalProps {
  onOrderCreated: (tableLabel: string) => void;
}

export function OrderModal({ onOrderCreated }: OrderModalProps) {
  const ctx = useOrderDraftContext();
  const [submitError, setSubmitError] = useState<string | null>(null);

  if (!ctx.isOpen) return null;

  function handleSelectTable(n: number) {
    ctx.setTableNumber(n);
    ctx.setCurrentStep(2);
  }

  function handleSelectCategory(cat: MenuCategory) {
    ctx.setCurrentCategory(cat);
    ctx.setCurrentStep(3);
  }

  function handleSelectItem(item: { id: number; name: string }) {
    ctx.setCurrentItem(item);
    ctx.setEditingItemIndex(null);
    ctx.setCurrentStep(4);
  }

  function handleConfirmQuantity(qty: number) {
    const { editingItemIndex, currentItem } = ctx;
    if (qty === 0 && editingItemIndex !== null) {
      ctx.removeItem(editingItemIndex);
      ctx.setEditingItemIndex(null);
      ctx.setCurrentStep(5);
    } else if (qty === 0) {
      ctx.setCurrentStep(3);
    } else if (editingItemIndex !== null) {
      ctx.updateItemQuantity(editingItemIndex, qty);
      ctx.setEditingItemIndex(null);
      ctx.setCurrentStep(5);
    } else if (currentItem) {
      ctx.addItem({ menuItemId: currentItem.id, name: currentItem.name, quantity: qty, note: null });
      ctx.setCurrentStep(3);
    }
  }

  function handleCancelQuantity() {
    if (ctx.editingItemIndex !== null) {
      ctx.setEditingItemIndex(null);
      ctx.setCurrentStep(5);
    } else {
      ctx.setCurrentStep(3);
    }
  }

  function handleEditItem(index: number) {
    const item = ctx.items[index];
    ctx.setCurrentItem({ id: item.menuItemId, name: item.name });
    ctx.setEditingItemIndex(index);
    ctx.setCurrentStep(4);
  }

  async function handleSubmit() {
    if (!ctx.tableNumber) return;
    setSubmitError(null);
    try {
      await createOrder({
        table_number: ctx.tableNumber,
        items: ctx.items.map(item => ({
          menu_item_id: item.menuItemId,
          quantity: item.quantity,
          note: item.note,
        })),
      });
      const label = ctx.tableNumber === 418 ? 'VIP 418' : String(ctx.tableNumber);
      ctx.closeModal();
      ctx.reset();
      onOrderCreated(label);
    } catch (err) {
      setSubmitError(`Erreur\u00a0: ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  return (
    <div className={`${styles.overlay} ${styles.overlayOpen}`}>
      <div className={styles.box}>
        <button className={styles.closeBtn} onClick={ctx.closeModal}>✕</button>
        {ctx.currentStep === 1 && (
          <StepTable onSelect={handleSelectTable} />
        )}
        {ctx.currentStep === 2 && (
          <StepCategory
            itemCount={ctx.items.length}
            onSelect={handleSelectCategory}
            onGoSummary={() => ctx.setCurrentStep(5)}
          />
        )}
        {ctx.currentStep === 3 && ctx.currentCategory && (
          <StepItems
            category={ctx.currentCategory}
            itemCount={ctx.items.length}
            onSelect={handleSelectItem}
            onBack={() => ctx.setCurrentStep(2)}
            onGoSummary={() => ctx.setCurrentStep(5)}
          />
        )}
        {ctx.currentStep === 4 && ctx.currentItem && (
          <StepQuantity
            itemName={ctx.currentItem.name}
            initialQuantity={
              ctx.editingItemIndex !== null
                ? ctx.items[ctx.editingItemIndex].quantity
                : 1
            }
            isEditing={ctx.editingItemIndex !== null}
            onConfirm={handleConfirmQuantity}
            onCancel={handleCancelQuantity}
          />
        )}
        {ctx.currentStep === 5 && ctx.tableNumber && (
          <StepSummary
            tableNumber={ctx.tableNumber}
            items={ctx.items}
            submitError={submitError}
            onAddItem={() => { ctx.setCurrentCategory(null); ctx.setCurrentStep(2); }}
            onEditItem={handleEditItem}
            onDeleteItem={ctx.removeItem}
            onNoteChange={ctx.updateItemNote}
            onSubmit={handleSubmit}
          />
        )}
      </div>
    </div>
  );
}
