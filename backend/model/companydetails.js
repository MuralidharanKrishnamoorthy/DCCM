const mongoose = require('mongoose');

const companyProfileSchema = new mongoose.Schema({
    companyname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    mobilenumber: { type: String },
    address: { type: String },
    pincode: { type: String },
    state: { type: String },
    country: { type: String },
    companyregid: { type: String, required: true, unique: true },
    co2emissionrate: { type: Number },
    emissionperiod: { type: String }
}, { timestamps: true });

module.exports = mongoose.model('CompanyProfile', companyProfileSchema);