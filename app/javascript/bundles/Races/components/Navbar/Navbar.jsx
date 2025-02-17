import React from 'react';

import {
  AppBar,
  Box,
  Button,
  Toolbar,
  Typography,
} from '@mui/material';
import {
  Add as AddIcon,
  EmojiEvents as EmojiEventsIcon
} from '@mui/icons-material';

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
            startIcon={<EmojiEventsIcon />}
            href="/"
          >
            Races
          </Button>
          <Button
            color="inherit"
            startIcon={<AddIcon />}
            href="/create_race"
          >
            Create race
          </Button>
        </Toolbar>
      </AppBar>
    </Box>
  )
}

export default Navbar;
