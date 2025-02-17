import React from 'react';
import { render, screen } from '@testing-library/react';

import '@testing-library/jest-dom'

import Navbar from './Navbar';

describe('<Navbar />', () => {
  it('renders the "Create race" button"', () => {
    render(<Navbar />);
  
    expect(screen.getByRole('link', { text: 'Create race'})).toBeInTheDocument();
  });
});