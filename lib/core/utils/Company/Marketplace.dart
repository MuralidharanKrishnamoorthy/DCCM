import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/Company/ProjectDetailscreen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  late Future<List<Map<String, dynamic>>> _projectsFuture;
  static const String baseUrl = 'http://192.168.1.6:8080/api/dccm';

  @override
  void initState() {
    super.initState();
    _projectsFuture = _fetchAllProjects();
  }

  Future<List<Map<String, dynamic>>> _fetchAllProjects() async {
    final String apiUrl = '$baseUrl/all-projects';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> projectsJson = json.decode(response.body);
        return projectsJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: linen,
      appBar: AppBar(
        backgroundColor: spruce,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No projects available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var project = snapshot.data![index];
                return _buildProjectCard(project);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            //project['uploadedImages'][0] ?? 'images/landimage.jpg',
            'images/landimage.jpg',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: const Color.fromARGB(255, 212, 209, 209),
                child: const Center(child: Text('Image not available')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['treeSpecies'] ?? 'Unknown Species',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16, color: forest),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: forest,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${project['state']}, ${project['country']}',
                      style: GoogleFonts.niramit(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  'View Details',
                  style: TextStyle(color: spruce),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectDetailScreen(projectId: project['_id']),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
