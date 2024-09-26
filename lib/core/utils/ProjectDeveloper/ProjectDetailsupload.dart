// ignore_for_file: non_constant_identifier_names

import 'package:dccm/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class ProjectDetailsUpload extends StatefulWidget {
  const ProjectDetailsUpload({super.key});

  @override
  State<ProjectDetailsUpload> createState() => _ProjectDetailsUploadState();
}

class _ProjectDetailsUploadState extends State<ProjectDetailsUpload> {
  final TextEditingController _landSizeController = TextEditingController();
  final TextEditingController _treeSpeciesController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _issuerIdController = TextEditingController();

  String _landType = 'Forest'; // Default land type selection

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
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload,
                        size: 40, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      'Upload Image',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Land size field
            Landsize(),
            const SizedBox(height: 20),

            // Land type section
            Text(
              'Land Type',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            LandType(),
            const SizedBox(height: 20),

            // Tree species field
            TreeSpecies(),
            const SizedBox(height: 20),

            // Age of tree field
            TreeAge(),
            const SizedBox(height: 20),

            // Location field
            ProjectLocation(),
            const SizedBox(height: 20),

            // Upload document section
            Text(
              'Upload Document:',
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
            const SizedBox(height: 20),

            // Issuer ID/Contact Info
            IssuerID(),
            const SizedBox(height: 20),

            // Submit button
            Submit(),
          ],
        ),
      ),
    );
  }

  SizedBox Submit() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Submit action
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

  ElevatedButton DocumentUpload() {
    return ElevatedButton.icon(
      onPressed: () {
        // Document upload functionality
      },
      icon: const Icon(Icons.cloud_upload_outlined),
      label: Text(
        'Browse',
        style: GoogleFonts.lato(fontSize: 16),
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

  TextFormField ProjectLocation() {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Location of the Project',
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

  TextFormField TreeSpecies() {
    return TextFormField(
      controller: _treeSpeciesController,
      decoration: InputDecoration(
        labelText: 'Tree Species (e.g. oak, pine)',
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

  Column LandType() {
    return Column(
      children: [
        RadioListTile(
          title: Text(
            'Forest',
            style: GoogleFonts.lato(fontSize: 14),
          ),
          value: 'Forest',
          groupValue: _landType,
          onChanged: (value) {
            setState(() {
              _landType = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text(
            'Agricultural',
            style: GoogleFonts.lato(fontSize: 14),
          ),
          value: 'Agricultural',
          groupValue: _landType,
          onChanged: (value) {
            setState(() {
              _landType = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text(
            'Barren',
            style: GoogleFonts.lato(fontSize: 14),
          ),
          value: 'Barren',
          groupValue: _landType,
          onChanged: (value) {
            setState(() {
              _landType = value.toString();
            });
          },
        ),
      ],
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
    );
  }
}
