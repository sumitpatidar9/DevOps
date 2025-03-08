const express = require("express");
const app = express();

const PORT = 5000;

app.get("/", (req, res) => {
    res.send("Hello from Node.js App running in Docker!");
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
