import React from 'react';
import { BrowserRouter, Routes, Route } from "react-router";

import CreateRace from './CreateRace';

import Box from '@mui/material/Box';
import Navbar from './Navbar/Navbar';

import * as style from './Races.module.css';

const Races = () => {
  return (
    <BrowserRouter>
      <Navbar />

      <Box sx={{ m: 2 }}>
        <Routes>
          <Route path="/create_race" element={<CreateRace />} />
        </Routes>
      </Box>
    </BrowserRouter>
  );
};

export default Races;
