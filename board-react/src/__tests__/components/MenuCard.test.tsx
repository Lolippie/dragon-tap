import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { MenuCard } from '../../components/menu/MenuCard';
import type { MenuItem } from '../../types';

const item: MenuItem = {
  id: 1,
  name: 'Potion de Clarté Mentale',
  category: 'potions',
  type: 'liquid',
  price: '12.50',
  description: 'Un liquide translucide aux reflets bleutés.',
};

describe('MenuCard', () => {
  it('displays name, price, category label and description', () => {
    render(<MenuCard item={item} />);
    expect(screen.getByText('Potion de Clarté Mentale')).toBeInTheDocument();
    expect(screen.getByText(/12\.50/)).toBeInTheDocument();
    expect(screen.getByText('Potions')).toBeInTheDocument();
    expect(screen.getByText('Un liquide translucide aux reflets bleutés.')).toBeInTheDocument();
  });
});
