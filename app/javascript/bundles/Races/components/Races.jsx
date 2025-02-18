import React from 'react';
import { BrowserRouter, Routes, Route } from "react-router";

import CreateRace from './CreateRace';
import Race from './Race';
import RacesList from './RacesList';
import Navbar from './Navbar/Navbar';

import {
  Box
} from '@mui/material';

import './Races.module.css';

const Races = () => {
  return (
    <BrowserRouter>
      <Navbar />

      <Box sx={{ m: 2 }}>
        <Routes>
          <Route path="/" element={<RacesList />} />
          <Route path="/create_race" element={<CreateRace />} />
          <Route path="/race/:id" element={<Race />} />
        </Routes>
      </Box>
    </BrowserRouter>
  );
};

export default Races;
