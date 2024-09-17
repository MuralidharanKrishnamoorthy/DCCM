const express = require("express");
const routes = express.Router();
const usermodel = require('../model/usermodel');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const {validateRegister,validateLogin} = require('../validation');

routes.post('/register', async (req, res) => {
    const { error } = validateRegister(req.body);
    if (error) {
      return res.status(400).json({ message: error.details[0].message });
    }
    try {
        const email = await usermodel.findOne({ Email: req.body.Email.trim() })
        if (email) {
            return res.status(400).json({ message: "Email is already registered" });

        }
        const salt = await bcrypt.genSalt(10);
        const hashpassword = await bcrypt.hash(req.body.Password, salt);
        const newuser = new usermodel({
            Email: req.body.Email,
            Password: hashpassword,
            Role: req.body.Role
        });
        const saveuser = await newuser.save();
        const sendtoken = jwt.sign({_id:saveuser._id},process.env.secretkey,{expiresIn:"20d"});
        res.header('auth-token', sendtoken).json({ status: 'success', token: sendtoken });


    }
    catch (error) {
        res.status(400).json({ message: "Registeration failed" , error : error.message});
    }

});

routes.post('/login', async (req, res) => {
    const { error } = validateLogin(req.body);
    if (error) {
      return res.status(400).json({ message: error.details[0].message });
    }
    try {
        const user = await usermodel.findOne({ Email: req.body.Email.trim() });
        if (!user) {
            return res.status(400).json({ message: 'Invalid email' });
        }
        
        const validPassword = await bcrypt.compare(req.body.Password, user.Password);
        if (!validPassword) {
            return res.status(400).json({ message: 'Invalid password' });
        }
        
        const sendtoken = jwt.sign({ _id: user._id }, process.env.secretkey, { expiresIn: '20d' });
        res.header('auth-token', sendtoken).json({ status: 'success', token: sendtoken });
    } catch (error) {
        res.status(400).json({ message: 'Login failed',error:error.message });
    }
});

