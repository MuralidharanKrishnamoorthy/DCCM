const express = require("express");
const routes = express.Router();
const usermodel = require('../model/usermodel');
const bcrypt = require("bcrypt");
const ProjectDetails = require('../model/landdetails');
const jwt = require("jsonwebtoken");
const { validateRegister, validateLogin } = require('../validation');
const multer = require("multer")

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/'); 
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname); 
    }
});

// Initialize multer
const upload = multer({ storage: storage });

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
       // const sendtoken = jwt.sign({ _id: saveuser._id,role:user.Role,deviceId:user.deviceId }, process.env.secretkey, { expiresIn: "20d" });
       const sendtoken = jwt.sign({ _id: saveuser._id, role: saveuser.Role, deviceId: saveuser.deviceId }, process.env.secretkey, { expiresIn: "20d" });

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

        
        if (user.deviceId !== req.body.deviceId) {
            return res.status(400).json({ message: 'Device not bound to this account' });
        }

        const sendtoken = jwt.sign({ _id: user._id,role:user.Role,deviceId:user.deviceId }, process.env.secretkey, { expiresIn: '20d' });
        res.header('auth-token', sendtoken).json({ status: 'success', token: sendtoken , role:user.Role});
    } catch (error) {
        res.status(400).json({ message: 'Login failed', error: error.message });

    }
});


routes.post('/projectdetail', upload.fields([{ name: 'uploadedImages' }, { name: 'landPattaImage' }]), async (req, res) => {
    const {
        landSize,
        surveyId,
        treeSpecies,
        treeAge,
        country,
        state,
        pincode,
        landmark,
        email,
        issuerId,
        projectDetail,
        landownername,
        metamaskid
    } = req.body;

    // Ensure correct data types
    const parsedLandSize = parseFloat(landSize);
    const parsedTreeAge = parseInt(treeAge);

    // Validate required fields
    if (
        !parsedLandSize || 
        !surveyId || 
        !treeSpecies ||
        !parsedTreeAge || 
        !country || 
        !state || 
        !pincode || 
        !landmark || 
        !email || 
        !issuerId || 
        !projectDetail ||
        !landownername||
        !metamaskid
    ) {
        return res.status(400).json({ error: 'All fields must be filled correctly, and at least one image must be uploaded.' });
    }

    // Check for at least one image
    const landPattaImage = req.files['landPattaImage'] ? req.files['landPattaImage'][0].path : null;
    if (!landPattaImage) {
        return res.status(400).json({ error: 'Land Patta Image is required.' });
    }

    if (!req.files['uploadedImages'] || req.files['uploadedImages'].length === 0) {
        return res.status(400).json({ error: 'At least one image must be uploaded.' });
    }

    try {
        const projectDetails = new ProjectDetails({
            landSize: parsedLandSize,
            surveyId,
            treeSpecies,
            treeAge: parsedTreeAge,
            country,
            state,
            pincode,
            landmark,
            email,
            issuerId,
            landPattaImage,
            projectDetail,
            landownername,
            metamaskid,
            uploadedImages: req.files['uploadedImages'].map(file => file.path), // Ensure you're storing the correct field
        });

        await projectDetails.save();
        res.status(201).json(projectDetails);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});



module.exports = routes;