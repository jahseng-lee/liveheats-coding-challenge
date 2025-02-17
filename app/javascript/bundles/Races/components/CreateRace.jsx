import React, { useState } from 'react';
import {
  Box,
  Button,
  FormControl,
  MenuItem,
  Select,
  Typography
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';

const CreateRace = () => {
  // TODO call Rails backend and load all students
  const [students, setStudents] = useState([
    { id: 1, name: "Megumi Fushigoro" },
    { id: 2, name: "Yuji Itadori" },
    { id: 3, name: "Nobara Kugisaki"},
    { id: 4, name: "Aoi Todo" }
  ]);
  const [brackets, setBrackets] = useState([
    { studentId: null, lane: 1 },
    { studentId: null, lane: 2 }
  ]);

  const updateBrackets = (event, child) => {
    const newBrackets = brackets
      .filter((bracket) => {
        // Remove existing lane...
        return bracket.lane !== child.props["data-lane"]
      });

    // ... and add it back with the correct student value
    newBrackets.push({
      studentId: event.target.value,
      lane: child.props["data-lane"]}
    );

    setBrackets(newBrackets);
  };

  const addLane = () => {
    setBrackets(
      [
        ...brackets,
        { studentId: null, lane: brackets.length + 1 }
      ]
    );
  };

  const createRace = () => {
    console.log("TODO implement createRace");
  };

  return (
    <>
      <Typography variant="h4" gutterBottom>
        Create a new race
      </Typography>

      {brackets.sort((a, b) => a.lane - b.lane).map(({studentId, lane }) => (
        <FormControl key={lane} fullWidth sx={{ mb: 1 }}>
          <Typography>Lane {lane}</Typography>
          <Select
            id={`lane-${lane}`}
            value={studentId || ''}
            onChange={updateBrackets}
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
          (brackets.length !== students.length) && (
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
          onClick={createRace}
          >
            Create
        </Button>
      </Box>
    </>
  );
}

export default CreateRace;
