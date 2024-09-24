const express = require("express");
const routes = express.Router();
const usermodel = require('../model/usermodel');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { validateRegister, validateLogin } = require('../validation');

// Check Device Binding API
routes.post('/check-device-binding', async (req, res) => {
    try {
        const { deviceId } = req.body;
        if (!deviceId) {
            return res.status(400).json({ message: "Device ID is required" });
        }
        const user = await usermodel.findOne({ deviceId });
        res.json({ isBound: !!user });
    } catch (error) {
        res.status(500).json({ message: "Device binding check failed", error: error.message });
    }
});

// Register API
routes.post('/register', async (req, res) => {
    const { error } = validateRegister(req.body);
    if (error) {
        return res.status(400).json({ message: error.details[0].message });
    }
    try {
        const email = await usermodel.findOne({ Email: req.body.Email });
        if (email) {
            return res.status(400).json({ message: "Email is already registered" });
        }

        // Check if device is already bound
        const existingDevice = await usermodel.findOne({ deviceId: req.body.deviceId });
        if (existingDevice) {
            return res.status(400).json({ message: "Device is already bound to an account" });
        }

        const salt = await bcrypt.genSalt(10);
        const hashpassword = await bcrypt.hash(req.body.Password, salt);
        const newuser = new usermodel({
            Email: req.body.Email,
            Password: hashpassword,
            Role: req.body.Role,
            deviceId: req.body.deviceId // Add deviceId to the user model
        });
        const saveuser = await newuser.save();
        const sendtoken = jwt.sign({ _id: saveuser._id,role:user.Role,deviceId:user.deviceId }, process.env.secretkey, { expiresIn: "20d" });
        res.header('auth-token', sendtoken).json({ status: 'success', token: sendtoken });
    }
    catch (error) {
        res.status(400).json({ message: "Registration failed", error: error.message });
    }
});

// Login API
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

        // Check if the login is from the bound device
        if (user.deviceId !== req.body.deviceId) {
            return res.status(400).json({ message: 'Device not bound to this account' });
        }

        const sendtoken = jwt.sign({ _id: user._id,role:user.Role,deviceId:user.deviceId }, process.env.secretkey, { expiresIn: '20d' });
        res.header('auth-token', sendtoken).json({ status: 'success', token: sendtoken });
    } catch (error) {
        res.status(400).json({ message: 'Login failed', error: error.message });
    }
});

module.exports = routes;