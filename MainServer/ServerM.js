const express = require('express');
const axios = require('axios');
const app = express();


const servers = [
    { name: "Server 1", url: "http://data-providers:7000/data" },
    { name: "Server 2", url: "http://data-providers:8000/data" },
    { name: "Server 3", url: "http://data-providers:9000/data" }
];

app.get('/home', async (req, res) => {
    let results = [];

    const fetchData = async (server) => {
        try {
            const response = await axios.get(server.url, { timeout: 1000 }); 
            return { name: server.name, data: response.data, status: "alive" };
        } catch (error) {
            return { name: server.name, data: null, status: "down" };
        }
    };


    results = await Promise.all(servers.map(fetchData));
    res.json({ servers: results });
});

const port = 5000;
app.listen(port, ()=>{
    console.log(`App is running on ${port}`)
})