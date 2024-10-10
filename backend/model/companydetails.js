const mongoose = require("mongoose");
const companyprofileschema = new mongoose.Schema({

    companyname: {
        type: String,
        required: true
    },
    email: {
        type:String , required : true
    },
    address: {
        type:String , required : true
    },
    mobilenumber: {
        type:Number , required : true
    },
    pincode: { type: Number, required: true },
    state: { type: String, required: true },
    country: { type: String, required: true },
    companyregid: { type: Number, required: true },
    co2emissionrate: { type: Number, required: true }

});
const companyprofile = mongoose.model('companyprofile',companyprofileschema );

module.exports = companyprofile;