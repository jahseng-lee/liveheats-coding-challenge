import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom'

import Navbar from './Navbar';

describe('<Navbar />', () => {
  it('renders the "Create race" button"', () => {
    render(<Navbar />);
  
    expect(screen.getByRole('link', { name: 'Create race'})).toBeInTheDocument();
  });

  it('renders the "Race" button"', () => {
    render(<Navbar />);
  
    expect(screen.getByRole('link', { name: 'Races'})).toBeInTheDocument();
  });
});