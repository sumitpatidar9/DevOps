



const express = require('express');
const app = express();


app.get('/data', (req, res)=>{
    res.send({'message' : 'Home page'});
});


const port = 8000;
app.listen(port, ()=>{
    console.log(`App is running on ${port}`)
})