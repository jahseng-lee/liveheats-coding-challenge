import React from 'react';

import AddIcon from '@mui/icons-material/Add';
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';

const Navbar = () => {
  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            LiveHeatsCodingChallenge
          </Typography>
          <Button
            color="inherit"
            startIcon={<AddIcon />}
            href="/create_race"
          >Create race</Button>
        </Toolbar>
      </AppBar>
    </Box>
  )
}

export default Navbar;
