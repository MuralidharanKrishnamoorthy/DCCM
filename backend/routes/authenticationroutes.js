const express = require("express");
const routes = express.Router();
const usermodel = require('../model/usermodel');
const bcrypt = require("bcrypt");
const ProjectDetails = require('../model/landdetails');
const jwt = require("jsonwebtoken");
const { validateRegister, validateLogin } = require('../validation');
const multer = require("multer");
const { spawn } = require('child_process');
const path = require('path');
const CompanyProfile = require('../model/companydetails')

// Multer Storage Setup
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

        // Added deviceId in response 
        const sendtoken = jwt.sign({ _id: user._id, role: user.Role, deviceId: user.deviceId }, process.env.secretkey, { expiresIn: '20d' });
        res.header('auth-token', sendtoken).json({ status: 'success', token: sendtoken, role: user.Role, deviceId: user.deviceId });
    } catch (error) {
        res.status(400).json({ message: 'Login failed', error: error.message });
    }
});

routes.post('/projectdetail', upload.fields([{ name: 'uploadedImages' }, { name: 'landPattaImage' }]), async (req, res) => {
    if (!req.files || !req.files['landPattaImage'] || !req.files['uploadedImages']) {
        return res.status(400).json({ error: 'Image uploads failed or missing required files.' });
    }

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

    const parsedLandSize = parseFloat(landSize);
    const parsedTreeAge = parseInt(treeAge);

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
        !landownername ||
        !metamaskid
    ) {
        return res.status(400).json({ error: 'All fields must be filled correctly, and at least one image must be uploaded.' });
    }

    const landPattaImage = req.files['landPattaImage'][0].path;

    const uploadedImages = req.files['uploadedImages'].map(file => file.path);

    try {
        // Initialize project details
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
            uploadedImages, 
            verified: false,
            creditPoints: 0,
            deviceId: req.body.deviceId
        });
        const savedProject = await projectDetails.save();

        // AI model 
        const pythonScriptPath = path.join(__dirname, '..', 'node_server', 'python_model', 'predict.py');
        const pythonProcess = spawn('python', [pythonScriptPath, treeSpecies, treeAge.toString(), landSize.toString()]);

        pythonProcess.stdout.on('data', async (data) => {
            const predictedCredits = parseFloat(data.toString().trim());
            console.log("Predicted Credits:", predictedCredits); 

            if (isNaN(predictedCredits)) {
                console.error('Invalid response from AI model');
                return res.status(500).json({ error: 'Invalid response from AI model' });
            }
            
            try {
                
                await ProjectDetails.findByIdAndUpdate(savedProject._id, {
                    creditPoints: predictedCredits,
                    verified: true
                }, { new: true }); // Optionally use { new: true } to return the updated document

                console.log("Project updated with credits and verification");
                res.status(201).json({ message: "Project saved and updated with AI result", projectId: savedProject._id });
            } catch (error) {
                console.error("Failed to save project with AI result:", error);
                res.status(500).json({ error: 'Failed to save project with AI result' });
            }
        });

        pythonProcess.stderr.on('data', (data) => {
            console.error(`Error in Python script: ${data}`);
            if (!res.headersSent) { // Only send response if not already sent
                res.status(500).json({ error: 'Error in AI verification process' });
            }
        });

    } catch (error) {
        console.error("Error in project detail upload:", error);
        if (!res.headersSent) { // Ensure headers are sent only once
            res.status(500).json({ error: error.message });
        }
    }
});

// Fetch Projects for the Given Device ID API
routes.get('/projects/:deviceId', async (req, res) => {
    try {
        const { deviceId } = req.params;
        const user = await usermodel.findOne({ deviceId });
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
        const projects = await ProjectDetails.find({ email: user.Email }).sort({ createdAt: -1 });
        res.json(projects);
    } catch (error) {
        res.status(500).json({ message: "Error fetching projects", error: error.message });
    }
});
routes.get('/all-projects', async (req, res) => {
    try {
        const projects = await ProjectDetails.find().sort({ createdAt: -1 });
        res.json(projects);
    } catch (error) {
        res.status(500).json({ message: "Error fetching projects", error: error.message });
    }
});
routes.get('/project/:id', async (req, res) => {
    try {
        const project = await ProjectDetails.findById(req.params.id);
        if (!project) {
            return res.status(404).json({ message: "Project not found" });
        }
        res.json(project);
    } catch (error) {
        res.status(500).json({ message: "Error fetching project", error: error.message });
    }
});
routes.post('/companyprofile', async (req, res) => {
    try {
        const { email, companyregid } = req.body;
        let companyProfile = await CompanyProfile.findOne({ $or: [{ email }, { companyregid }] });

        if (companyProfile) {
            // Update existing profile
            companyProfile = await CompanyProfile.findOneAndUpdate(
                { $or: [{ email }, { companyregid }] },
                req.body,
                { new: true, runValidators: true }
            );
        } else {
            // Create new profile
            companyProfile = new CompanyProfile(req.body);
            await companyProfile.save();
        }

        res.status(200).json(companyProfile);
    } catch (error) {
        console.error('Error in /companyprofile POST route:', error);
        res.status(400).json({ message: error.message });
    }
});
// GET Company Profile
routes.get('/companyprofile/:identifier', async (req, res) => {
    try {
        const { identifier } = req.params;
        const companyProfile = await CompanyProfile.findOne({
            $or: [{ email: identifier }, { companyregid: identifier }]
        });

        if (!companyProfile) {
            return res.status(404).json({ message: 'Company profile not found' });
        }

        res.json(companyProfile);
    } catch (error) {
        console.error('Error in /companyprofile GET route:', error);
        res.status(500).json({ message: 'Error fetching company profile', error: error.message });
    }
});
module.exports = routes;
