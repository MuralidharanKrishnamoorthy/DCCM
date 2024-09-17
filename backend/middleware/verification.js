
const user = require("../model/usermodel");
const jwt = require("jsonwebtoken");
function auth(req, res, next) {
    const token = req.header('auth-token');
    if (!token)
        return res.status(401).send('Access denied');
    try {
        const verified = jwt.verify(token, process.env.secretkey);
        req.user = verified;
        console.log('Verified User:', req.user);
        next();
    } catch (error) {
        res.status(400).send('Invalid token');
    }
}