import React, { useState, useEffect } from 'react';
import { useNavigate } from "react-router";

import {
  Alert,
  Box,
  Button,
  FormControl,
  MenuItem,
  Select,
  TextField,
  Typography
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';

const fetchStudents = async () => {
  return fetch('/students')
    .then((response) => response.text())
    .then((data) => {
      return JSON.parse(data);
    });
};

const createRace = (body) => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  return fetch('/races', {
    method: "POST",
    headers: {
      "X-CSRF-Token": csrfToken,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(body),
  })
    .then((response) => response.text())
    .then((data) => {
      return JSON.parse(data);
    })
};

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
    console.log(participants);
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
      />

      {participants.sort((a, b) => a.lane - b.lane).map(({studentId, lane }) => (
        <FormControl key={lane} sx={{ mb: 1 }} fullWidth>
          <Typography>Lane {lane}</Typography>
          <Select
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
              variant="outlined"
              startIcon={<AddIcon />}
              sx={{ mr: 1 }}
              onClick={addLane}
              >
                Add lane
            </Button>
          )
        }
        <Button
          variant="contained"
          onClick={submitCreateRace}
          >
            Create
        </Button>
      </Box>
    </>
  );
}

export default CreateRace;
