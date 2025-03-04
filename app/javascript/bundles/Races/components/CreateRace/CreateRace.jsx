import React, { useState, useEffect } from 'react';
import { useNavigate } from "react-router";
import { createRace, fetchStudents } from '../../queries';

import {
  Alert,
  Box,
  Button,
  FormControl,
  InputLabel,
  MenuItem,
  Select,
  TextField,
  Typography
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';

const CreateRace = () => {
  const [name, setName] = useState("");
  const [students, setStudents] = useState([]);
  const [participants, setParticipants] = useState([
    { studentId: null, lane: 1 },
    { studentId: null, lane: 2 }
  ]);
  const [error, setError] = useState("");

  let navigate = useNavigate();

  useEffect(() => {
    fetchStudents().then((data) => {
      setStudents(data.students);
    });
  }, [])

  const updateParticipants = (event, child) => {
    const newParticipants = participants
      .filter((participant) => {
        // Remove existing lane...
        return participant.lane !== child.props["data-lane"]
      });

    // ... and add it back with the correct student value
    newParticipants.push({
      studentId: event.target.value,
      lane: child.props["data-lane"]}
    );

    setParticipants(newParticipants);
  };

  const addLane = () => {
    setParticipants(
      [
        ...participants,
        { studentId: null, lane: participants.length + 1 }
      ]
    );
  };

  const submitCreateRace = () => {
    createRace({
      race: {
        name: name,
        participants: participants.map((participant) => ({
          student_id: participant.studentId,
          lane: participant.lane
        }))
      }
    })
      .then((data) => {
        if(data.status === 201) {
          setError("");
          navigate("/");
        } else {
          setError(data.message);
        }
      })
  };

  return (
    <>
      <Typography variant="h4" gutterBottom>
        Create a new race
      </Typography>

      {!!error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert> }

      <TextField
        id="outlined-basic"
        label="Name"
        variant="outlined"
        fullWidth
        onChange={(event) => setName(event.target.value)}
        sx={{ mb: 1}}
      />

      <hr />

      {participants.sort((a, b) => a.lane - b.lane).map(({studentId, lane }) => (
        <FormControl key={lane} sx={{ mb: 1 }} fullWidth>
          <InputLabel id={`select-lane-${lane}`}>Lane {lane}</InputLabel>
          <Select
            labelId={`select-lane-${lane}`}
            id={`lane-${lane}`}
            value={studentId || ''}
            onChange={updateParticipants}
            displayEmpty
          >
            {students.map((student) => (
              <MenuItem                
                key={`student-${student.id}-lane-${lane.id}`}
                data-lane={lane}
                value={student.id}
                >
                  {student.name}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      ))}

      <Box>
        {
          (participants.length !== students.length) && (
            <Button
              variant='outlined'
              startIcon={<AddIcon />}
              sx={{ mr: 1 }}
              onClick={addLane}
              >
                Add lane
            </Button>
          )
        }
        <Button
          variant='contained'
          onClick={submitCreateRace}
          >
            Create
        </Button>
      </Box>
    </>
  );
}

export default CreateRace;
