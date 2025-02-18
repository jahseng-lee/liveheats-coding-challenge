import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router';

import {
  Box,
  Button,
  Card,
  CardContent,
  FormControl,
  InputLabel,
  MenuItem,
  Select,
  Typography
} from '@mui/material';

const fetchRace = async (raceId) => {
  return fetch(`/races/${raceId}`)
    .then((response) => response.text())
    .then((data) => {
      return JSON.parse(data);
    });
};

const Race = (props) => {
  const [race, setRace] = useState();
  const { id } = useParams();

  useEffect(() => {
    fetchRace(id).then((data) => {
      setRace(data.race);
    })
  }, [id]);
  
  const updatePlacings = (event, child) => {
    const participantId = child.props["data-participant-id"];

    // Find existing participant
    const existingParticipant = race.participants.find((participant) => {
      return participant.id == participantId
    })

    // Create new participants with the existing one removed
    const newParticipants = race.participants.filter((participant) => {
      return participant.id !== participantId
    })

    // Add back the participant with the new placing
    newParticipants.push({
      placing: event.target.value,
      participantId: participantId,
      name: existingParticipant.name,
      lane: existingParticipant.lane
    })

    setRace({
      ...race,
      participants: newParticipants
    })
  };

  const submitUpdatePlacings = () => {
    console.warn("TODO implement submitUpdatePlacings");
  }

  return (
    <>
      {!!race && (
        <>
          <Typography variant='h4' gutterBottom>
            {race.name}
          </Typography>

          {race.participants.sort((a, b) => a.lane - b.lane).map((participant) => (
            <Card variant='outlined' sx={{ mb: 2 }}>
              <CardContent sx={{ display: 'flex', alignItems: 'center' }}>
                <Box>
                  <Typography variant='h6' component='p'>
                    {participant.name}
                  </Typography>
                  <Typography>
                    Lane: {participant.lane}
                  </Typography>
                </Box>
                <FormControl
                  variant='standard'
                  sx={{ m: 1, minWidth: 120, marginLeft: 'auto' }}
                >
                  <InputLabel id={`participant-${participant.id}-placing-label`}>
                    Placing
                  </InputLabel>
                  <Select
                    id={`participant-${participant.id}-placing`}
                    labelId={`participant-${participant.id}-placing-label`}
                    value={participant.placing || ''}
                    label='Placing'
                    onChange={updatePlacings}
                  >
                    {[...Array(race.participants.length)].map((_, i) => (
                      <MenuItem 
                        data-participant-id={participant.id}
                        value={i+1}
                      >
                        {i+1}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </CardContent>
            </Card>
          ))}

          <Button
            variant='contained'
            onClick={submitUpdatePlacings}
          >
            Complete race
          </Button>
        </>
      )}
    </>
  );
};

export default Race;
