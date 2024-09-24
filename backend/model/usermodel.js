
const mongoose= require("mongoose");
const UserSchema = new mongoose.Schema
({
    Email:{
        type : String,
        required : true,
        unique : true
    },
    Password:{
        type:String,
        required:true
    },
    Role:{
        type:String,
        enum:['Company' , 'Project Developer'],
        required:true

    },
    deviceId: {
        type: String,
        required: true,
        unique: true
      }
});
module.exports = mongoose.model('usermodel', UserSchema);
