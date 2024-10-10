// ignore_for_file: non_constant_identifier_names

import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/ProjectDeveloper/data/sucsessdialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:dccm/core/utils/ProjectDeveloper/data/datasource.dart';

class ProjectDetailsUpload extends StatefulWidget {
  const ProjectDetailsUpload({super.key});

  @override
  State<ProjectDetailsUpload> createState() => _ProjectDetailsUploadState();
}

class _ProjectDetailsUploadState extends State<ProjectDetailsUpload> {
  final TextEditingController _landSizeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _issuerIdController = TextEditingController();
  final TextEditingController _surveyIdController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _projectDetailsController =
      TextEditingController();
  final TextEditingController _landownernameController =
      TextEditingController();
  final TextEditingController _metamaskidController = TextEditingController();

  String? _selectedTreeSpecies;

  final List<String> treespecies = [
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
  ];

  File? _landImage;
  File? _landPattaImage;

  @override
  void initState() {
    super.initState();
    _selectedTreeSpecies = treespecies.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: linen,
      appBar: AppBar(
        backgroundColor: spruce,
        elevation: 0,
        title: Text(
          'Upload Project',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image upload section
            GestureDetector(
              onTap: _pickLandImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: _landImage != null
                      ? DecorationImage(
                          image: FileImage(_landImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _landImage == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_upload,
                                size: 40, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text(
                              'Upload Land Image',
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Landownername(),
            const SizedBox(height: 20),
            // Project Details field
            ProjectDetails(),
            const SizedBox(height: 20),

            // Land size field
            Landsize(),
            const SizedBox(height: 20),

            // Survey ID field
            SurveyId(),
            const SizedBox(height: 20),

            // Tree species field
            TreeSpecies(),
            const SizedBox(height: 20),

            // Age of tree field
            TreeAge(),
            const SizedBox(height: 20),

            // Country field
            Country(),
            const SizedBox(height: 20),

            // State field
            State(),
            const SizedBox(height: 20),

            // Pincode field
            Pincode(),
            const SizedBox(height: 20),

            // Landmark field
            Landmark(),
            const SizedBox(height: 20),

            // Email field
            Email(),
            const SizedBox(height: 20),

            // Upload document section
            Text(
              'Upload Land Patta Document:',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DocumentUpload(),
            const SizedBox(height: 10),
            if (_landPattaImage != null)
              Text(
                'Land Patta Image uploaded',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Issuer ID/Contact Info
            IssuerID(),
            const SizedBox(height: 20),
            Metamaskwalletid(),
            const SizedBox(height: 20),
            // Submit button
            Submit(),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadProjectDetails() async {
    if (_landImage == null || _landPattaImage == null) {
      // Show an error message if images are not uploaded
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please upload both Land Image and Land Patta Document'),
      ));
      return;
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.6:8080/api/dccm/projectdetail'),
      );

      request.fields['landSize'] = _landSizeController.text;
      request.fields['treeAge'] = _ageController.text;
      request.fields['issuerId'] = _issuerIdController.text;
      request.fields['surveyId'] = _surveyIdController.text;
      request.fields['country'] = _countryController.text;
      request.fields['state'] = _stateController.text;
      request.fields['pincode'] = _pincodeController.text;
      request.fields['landmark'] = _landmarkController.text;
      request.fields['email'] = _emailController.text;
      request.fields['treeSpecies'] = _selectedTreeSpecies!;
      request.fields['projectDetail'] = _projectDetailsController.text;
      request.fields['landownername'] = _landownernameController.text;
      request.fields['metamaskid'] = _metamaskidController.text;

      // Add land image
      request.files.add(await http.MultipartFile.fromPath(
        'uploadedImages',
        _landImage!.path,
      ));

      // Add land patta image
      request.files.add(await http.MultipartFile.fromPath(
        'landPattaImage',
        _landPattaImage!.path,
      ));

      // Send the request
      final response = await request.send();
     

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Project details uploaded successfully!'),
        ));
        // ignore: use_build_context_synchronously
        showSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to upload project details. Status: ${response.statusCode}'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $error'),
      ));
    }
  }

  Future<void> _pickLandImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _landImage = File(image.path);
      });
    }
  }

  TextFormField ProjectDetails() {
    return TextFormField(
      controller: _projectDetailsController,
      decoration: InputDecoration(
        labelText: 'Project Details',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      maxLines: 5, // Allow multiple lines for detailed information
    );
  }

  SizedBox Submit() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Submit action
          _uploadProjectDetails();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: forest,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Submit',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  TextFormField IssuerID() {
    return TextFormField(
      controller: _issuerIdController,
      decoration: InputDecoration(
        labelText: 'Issuer ID/Contact Info',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextFormField Metamaskwalletid() {
    return TextFormField(
      controller: _metamaskidController,
      decoration: InputDecoration(
        labelText: 'Metamask Wallet ID ',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextFormField Landownername() {
    return TextFormField(
      controller: _landownernameController,
      decoration: InputDecoration(
        labelText: 'Landowner Name',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  ElevatedButton DocumentUpload() {
    return ElevatedButton.icon(
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _landPattaImage = File(image.path);
          });
        }
      },
      icon: const Icon(Icons.cloud_upload_outlined),
      label: Text(
        'Upload Land Patta',
        style: GoogleFonts.lato(fontSize: 16, color: parchment),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: spruce,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  TextFormField TreeAge() {
    return TextFormField(
      controller: _ageController,
      decoration: InputDecoration(
        labelText: 'Age of the Tree (in years)',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget TreeSpecies() {
    return DropdownButtonFormField<String>(
      value: _selectedTreeSpecies,
      decoration: InputDecoration(
        labelText: 'Tree Species',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      items: treespecies.map<DropdownMenuItem<String>>((species) {
        return DropdownMenuItem<String>(
          value: species,
          child: Text(species),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTreeSpecies = newValue;
        });
      },
    );
  }

  TextFormField SurveyId() {
    return TextFormField(
      controller: _surveyIdController,
      decoration: InputDecoration(
        labelText: 'Survey ID',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextFormField Landsize() {
    return TextFormField(
      controller: _landSizeController,
      decoration: InputDecoration(
        labelText: 'Land Size (hectares/acres)',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField Country() {
    return TextFormField(
      controller: _countryController,
      decoration: InputDecoration(
        labelText: 'Country',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextFormField State() {
    return TextFormField(
      controller: _stateController,
      decoration: InputDecoration(
        labelText: 'State',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextFormField Pincode() {
    return TextFormField(
      controller: _pincodeController,
      decoration: InputDecoration(
        labelText: 'Pincode',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField Landmark() {
    return TextFormField(
      controller: _landmarkController,
      decoration: InputDecoration(
        labelText: 'Landmark',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextFormField Email() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
