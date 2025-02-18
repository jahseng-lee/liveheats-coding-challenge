import React, { useState, useEffect } from 'react';

import {
  Card,
  CardActionArea,
  CardContent,
  Typography
} from '@mui/material';

const fetchRaces = async () => {
  return fetch('/races')
    .then((response) => response.text())
    .then((data) => {
      return JSON.parse(data);
    });
};

const RacesList = () => {
  const [races, setRaces] = useState([]);

  useEffect(() => {
    fetchRaces().then((data) => {
      setRaces(data.races);
    });
  }, [])

  return (
    <>
      {(races.length !== 0) && (
        <>
          {races.map((race) => (
            <Card variant="outlined" sx={{ mb: 2}}>
              <CardActionArea href={`/race/${race.id}`}>
                <CardContent>
                  <Typography variant="h6" component="p">{race.name}</Typography>
                  <Typography>Status: {race.status}</Typography>
                </CardContent>
              </CardActionArea>
            </Card>
          ))}
        </>
      )}
    </>
  );
}

export default RacesList;
