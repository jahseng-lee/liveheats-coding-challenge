import React, { useState, useEffect } from 'react';
import { fetchRaces } from '../queries';

import {
  Card,
  CardActionArea,
  CardContent,
  Link,
  Typography
} from '@mui/material';

const RacesList = () => {
  const [races, setRaces] = useState();

  useEffect(() => {
    fetchRaces().then((data) => {
      setRaces(data.races);
    });
  }, [])

  return (
    <>
      {!!races && (
        <>
          {(races.length === 0) && (
            <>
              <Typography>
                No races created yet.&nbsp;
                <Link href="/create_race">Create one now</Link>
              </Typography>
            </>
          )}

          {races.map((race) => (
            <Card variant='outlined' sx={{ mb: 2}}>
              <CardActionArea href={`/race/${race.id}`}>
                <CardContent>
                  <Typography variant='h6' component='p'>{race.name}</Typography>
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
