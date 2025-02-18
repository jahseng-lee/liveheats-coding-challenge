export const fetchStudents = async () => {
  return fetch('/students')
    .then((response) => response.text())
    .then((data) => {
      return JSON.parse(data);
    });
};

export const createRace = (body) => {
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

export const fetchRace = async (raceId) => {
  return fetch(`/races/${raceId}`)
    .then((response) => response.text())
    .then((data) => {
      return JSON.parse(data);
    });
};

export const completeRace = async(raceId, body) => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  return fetch(`/races/${raceId}`, {
    method: "PUT",
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

export const fetchRaces = async () => {
  return fetch('/races')
    .then((response) => response.text())
    .then((data) => {
      return JSON.parse(data);
    });
};