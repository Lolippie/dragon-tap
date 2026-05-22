import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { OrderModal } from '../../components/order-modal/OrderModal';
import { OrderDraftProvider, useOrderDraftContext } from '../../context/OrderDraftContext';
import * as client from '../../api/client';
import type { MenuItem, Order } from '../../types';

vi.mock('../../api/client');

const mockMenuItems: MenuItem[] = [
  { id: 10, name: 'Potion de Feu', category: 'potions', type: 'liquid', price: '8.00', description: 'Brûlante.' },
  { id: 11, name: 'Eau de Source', category: 'potions', type: 'liquid', price: '2.00', description: 'Pure.' },
];

const mockOrder: Order = {
  id: 99,
  table_number: 3,
  status: 'pending',
  created_at: '2024-01-01T12:00:00.000Z',
  items: [],
};

function ModalOpener({ children }: { children: React.ReactNode }) {
  const ctx = useOrderDraftContext();
  return (
    <>
      <button onClick={ctx.openModal}>Ouvrir</button>
      {children}
    </>
  );
}

function renderModal(onOrderCreated = vi.fn()) {
  return render(
    <OrderDraftProvider>
      <ModalOpener>
        <OrderModal onOrderCreated={onOrderCreated} />
      </ModalOpener>
    </OrderDraftProvider>
  );
}

async function openModal() {
  await userEvent.click(screen.getByText('Ouvrir'));
}

describe('OrderModal — flux complet', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.mocked(client.fetchMenu).mockResolvedValue(mockMenuItems);
    vi.mocked(client.createOrder).mockResolvedValue(mockOrder);
  });

  it('flux nominal : table → catégorie → item → quantité → soumission', async () => {
    const onOrderCreated = vi.fn();
    renderModal(onOrderCreated);
    await openModal();

    // Step 1 — table
    expect(screen.getByText('Quelle table ?')).toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: '3' }));

    // Step 2 — category
    expect(screen.getByText('Choisir une catégorie')).toBeInTheDocument();
    await userEvent.click(screen.getByText('Potions'));

    // Step 3 — items (wait for fetch)
    await waitFor(() => expect(screen.getByText('Potion de Feu')).toBeInTheDocument());
    await userEvent.click(screen.getByText('Potion de Feu'));

    // Step 4 — quantity (default 1)
    expect(screen.getByText('Potion de Feu')).toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: /Valider/ }));

    // Step 3 again — go to summary
    await waitFor(() => screen.getByText('Potions'));
    await userEvent.click(screen.getByText(/Voir la commande/));

    // Step 5 — summary
    expect(screen.getByText('Valider la commande')).toBeInTheDocument();
    await userEvent.click(screen.getByText('Valider la commande'));

    await waitFor(() => {
      expect(client.createOrder).toHaveBeenCalledWith({
        table_number: 3,
        items: [{ menu_item_id: 10, quantity: 1, note: null }],
      });
    });
    expect(onOrderCreated).toHaveBeenCalledWith('3');
  });

  it('bouton Valider désactivé si liste vide', async () => {
    renderModal();
    await openModal();

    await userEvent.click(screen.getByRole('button', { name: '5' }));
    await userEvent.click(screen.getByText('Potions'));
    await waitFor(() => screen.getByText('Potion de Feu'));
    await userEvent.click(screen.getByText('Potion de Feu'));
    await userEvent.click(screen.getByRole('button', { name: /Valider/ }));

    // go to summary
    await waitFor(() => screen.getByText(/Voir la commande/));
    await userEvent.click(screen.getByText(/Voir la commande/));

    // delete the item
    await userEvent.click(screen.getByText('Supprimer'));

    expect(screen.getByRole('button', { name: 'Valider la commande' })).toBeDisabled();
  });

  it('modification depuis le récapitulatif met à jour la quantité', async () => {
    renderModal();
    await openModal();

    await userEvent.click(screen.getByRole('button', { name: '2' }));
    await userEvent.click(screen.getByText('Potions'));
    await waitFor(() => screen.getByText('Eau de Source'));
    await userEvent.click(screen.getByText('Eau de Source'));
    await userEvent.click(screen.getByRole('button', { name: /Valider/ }));

    await waitFor(() => screen.getByText(/Voir la commande/));
    await userEvent.click(screen.getByText(/Voir la commande/));

    // Edit
    await userEvent.click(screen.getByText('Modifier'));

    // Change quantity to 3
    await userEvent.click(screen.getByRole('button', { name: '3' }));
    await userEvent.click(screen.getByRole('button', { name: /Mettre à jour/ }));

    // Back to summary — check updated quantity
    await waitFor(() => screen.getByText('Valider la commande'));
    expect(screen.getByText('3×')).toBeInTheDocument();
  });

  it("suppression depuis le récapitulatif retire l'item", async () => {
    renderModal();
    await openModal();

    await userEvent.click(screen.getByRole('button', { name: '4' }));
    await userEvent.click(screen.getByText('Potions'));
    await waitFor(() => screen.getByText('Potion de Feu'));
    await userEvent.click(screen.getByText('Potion de Feu'));
    await userEvent.click(screen.getByRole('button', { name: /Valider/ }));

    await waitFor(() => screen.getByText(/Voir la commande/));
    await userEvent.click(screen.getByText(/Voir la commande/));

    await userEvent.click(screen.getByText('Supprimer'));

    expect(screen.getByText(/Aucun item/)).toBeInTheDocument();
  });
});
