require('dotenv').config()

const express = require('express');
const cors = require('cors');
const bodyparser = require('body-parser');
const app = express();
const mongoose = require('mongoose')
const { PythonShell } = require('python-shell');
const path = require('path');



const routes = require('./routes/authenticationroutes');

const PORT = 8080;
// middleware
app.use(express.json())
app.use(express.urlencoded({ extended: true }));
app.use(cors())



// routing middleware 
app.use('/api/dccm', routes);

// Prediction endpoint // here changes made in req.body 
app.post('/api/predict', (req, res) => {
    const { treeSpecies, treeAge, landSize } = req.body;
  
    let options = {
      mode: 'text',
      pythonPath: 'python',
      scriptPath: path.join(__dirname, 'python_model'),
      args: [treeSpecies, treeAge, landSize]
    };
  
    PythonShell.run('predict.py', options, function (err, results) {
      if (err) {
        console.error('Error running prediction:', err);
        return res.status(500).json({ error: 'Failed to run prediction' });
      }
      res.json({ predicted_credits: parseFloat(results[0]) });
    });
  });
  

// db connect
mongoose.connect(process.env.db_url)

    .then(() => console.log(" database connected"))
    .catch((error) => console.error("failed to connect ", error));
    




// server listening 
app.listen(PORT, '192.168.41.122', () => {
    //server need to change//
    console.log(`server connected http://192.168.41.122:${PORT}`);
});

