import 'package:flutter/cupertino.dart';
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        //middle:
        //Text('', style: GoogleFonts.poppins(color: CupertinoColors.white)),
        backgroundColor: spruce,
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: GoogleFonts.poppins()));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No projects available',
                    style: GoogleFonts.poppins()));
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'images/landimage.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: CupertinoColors.systemGrey5,
                  child: Center(
                      child: Text('Image not available',
                          style: GoogleFonts.poppins())),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['treeSpecies'] ?? 'Unknown Species',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: forest,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 16,
                      color: forest,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${project['state']}, ${project['country']}',
                      style: GoogleFonts.niramit(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'View Details',
                    style: GoogleFonts.poppins(color: spruce),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            ProjectDetailScreen(projectId: project['_id']),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
