const mongoose = require('mongoose');

const projectSchema = new mongoose.Schema({
  landSize: {
    type: Number,
    required: true
  },
  surveyId: {
    type: String,
    required: true
  },
  treeSpecies: {
    type: String,
    enum: [
      'Mangrove',
      'Bamboo',
      'Eucalyptus',
      'Oak',
      'Pine',
      'Acacia',
      'Palm',
      'Birch',
      'Cypress',
      'Willow'
    ],
    required: true
  },
  treeAge: {
    type: Number,
    required: true
  },
  country: {
    type: String,
    required: true
  },
  state: {
    type: String,
    required: true
  },
  pincode: {
    type: String,
    required: true
  },
  landmark: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true,
   
  },
  issuerId: {
    type: String,
    required: true
  },
  landPattaImage: {
    type: String, 
    required: true
  },
  uploadedImages: {
    type: [String],
    required: true
  },
  projectDetail: { 
    type: String,
    required: true,
  },
  landownername:{
    type:String,
    required:true
  },
  metamaskid:{
    type:String,
    required:true
  }
}, { timestamps: true });

const Project = mongoose.model('Project', projectSchema);

module.exports = Project;
