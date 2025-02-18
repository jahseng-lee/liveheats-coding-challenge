import React from 'react';
import { fireEvent, render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom'

import CreateRace from './CreateRace';

// Mock react-router's useNavigate
const mockedUsedNavigate = jest.fn();
jest.mock('react-router', () => ({
  useNavigate: () => mockedUsedNavigate,
}));

// Mock CreateRace fetchStudents
const mockFetchStudents = jest.fn(() => {
  return Promise.resolve({
    students: [
      { id: 1, name: 'Harry Potter'},
      { id: 2, name: 'Hermoine Granger'},
      { id: 3, name: 'Ronald Weasley' }
    ]
  })
});
const mockCreateRace = jest.fn((_) => {
  return Promise.resolve({
    status: 201
  })
})
jest.mock('../../queries.js', () => ({
  fetchStudents: () => mockFetchStudents(),
  createRace: (body) => mockCreateRace(body)
}));

describe('<CreateRace />', () => {
  it('fetches list of students on render', async () => {
    await waitFor(() => render(<CreateRace />));

    expect(mockFetchStudents).toHaveBeenCalled();
  });

  it('renders 2 lanes by default', async () => {
    await waitFor(() => render(<CreateRace />));

    expect(screen.getByLabelText('Lane 1')).toBeInTheDocument();
    expect(screen.getByLabelText('Lane 2')).toBeInTheDocument();
  });

  describe('clicking on "Add lane"', () => {
    it('adds another lane to the form', async () => {
      await waitFor(() => render(<CreateRace />));

      await waitFor(() => screen.getByText('Add lane').click());

      expect(screen.getByLabelText('Lane 1')).toBeInTheDocument();
      expect(screen.getByLabelText('Lane 2')).toBeInTheDocument();
      expect(screen.getByLabelText('Lane 3')).toBeInTheDocument();
    });
  });

  describe('filling out the form then clicking "Create"', () => {
    it('calls the createRace function', async () => {
      await waitFor(() => render(<CreateRace />));

      const nameInput = screen.getByLabelText('Name');
      fireEvent.change(
        nameInput,
        { target: { value: '100km ultramarathon' }}
      );

      // MaterialUI select doesn't like screen.click(), but does
      // like fireEvent.mouseDown()
      fireEvent.mouseDown(screen.getByLabelText('Lane 1'));
      fireEvent.click(screen.getByText('Harry Potter'));

      fireEvent.mouseDown(screen.getByLabelText('Lane 2'));
      userEvent.click(screen.getAllByText('Ronald Weasley')[1]);

      await userEvent.click(screen.getByText('Create'));

      expect(mockCreateRace).toHaveBeenCalledWith({
        race: {
          name: '100km ultramarathon',
          participants: [
            { student_id: 1, lane: 1 },
            { student_id: 3, lane: 2 }
          ]
        }
      });
    });
  });
})