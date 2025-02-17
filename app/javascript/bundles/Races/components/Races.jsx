import React, { useState } from 'react';

import * as style from './Races.module.css';

import AddIcon from '@mui/icons-material/Add';
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';

const Races = (props) => {
  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            LiveHeatsCodingChallenge
          </Typography>
          <Button color="inherit" startIcon={<AddIcon />}>Create race</Button>
        </Toolbar>
      </AppBar>
    </Box>
  );
};

export default Races;
