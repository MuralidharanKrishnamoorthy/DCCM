
require('dotenv').config()

const express = require('express');
const cors = require('cors');
const bodyparser = require('body-parser');
const app = express();
const mongoose = require('mongoose')
const dotenv = require('dotenv');
const routes = require('./routes/authenticationroutes');

const PORT = 8000;
// middleware
app.use(express.json())
app.use(express.urlencoded({ extended: true }));
app.use(cors())



// routing middleware 
app.use('/api/dccm', routes);

// db connect
mongoose.connect(process.env.db_url)
    .then(() => console.log("connected"))
    .catch((error) => console.error("failed to connect ", error));


// server listening 
app.listen(PORT, '192.168.212.27', () => {
    console.log(`server connected http://192.168.212.27:${PORT}`);
});
