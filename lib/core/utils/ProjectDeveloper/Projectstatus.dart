import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dccm/Colors.dart';

import 'package:dccm/core/utils/ProjectDeveloper/Projectdeveloperdashboard.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For storing/retrieving the token

class Project {
  final String id;
  final String treeSpecies;
  final int treeAge;
  final double landSize;
  final bool verified;
  final double creditPoints;

  Project({
    required this.id,
    required this.treeSpecies,
    required this.treeAge,
    required this.landSize,
    required this.verified,
    required this.creditPoints,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      treeSpecies: json['treeSpecies'],
      treeAge: json['treeAge'],
      landSize: json['landSize'],
      verified: json['verified'],
      creditPoints: json['creditPoints'].toDouble(),
    );
  }
}

class ProjectStatus extends StatefulWidget {
  @override
  _ProjectStatusState createState() => _ProjectStatusState();
}

class _ProjectStatusState extends State<ProjectStatus>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Project> _projects = [];
  late Timer _timer;
  bool _isLoading = true;
  final AuthRepository authRepository =
      AuthRepository(baseUrl: 'http://192.168.1.6:8080/api/dccm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProjects();

    // Periodically check for updates every 10 seconds
    _timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => _fetchProjects());
  }

  Future<void> _pollForUpdates() async {
    // This function will be called periodically to refresh project data
    await _fetchProjects();

    // Continue polling every 10 seconds
    Future.delayed(Duration(seconds: 10), _pollForUpdates);
  }

  Future<void> _fetchProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the deviceId and auth-token from the auth repository
      final deviceId = await authRepository.getDeviceId();
      final authToken = await authRepository.getAuthToken(); // Fetch auth-token

      if (deviceId == null || authToken == null) {
        throw Exception('Device ID or Auth Token not found');
      }

      // Make the API request with the deviceId and auth-token
      final response = await http.get(
        Uri.parse('${authRepository.baseUrl}/projects/$deviceId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $authToken', // Include the token in the header
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> projectsJson = json.decode(response.body);
        setState(() {
          _projects =
              projectsJson.map((json) => Project.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      print('Error fetching projects: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: linen,
      appBar: AppBar(
        backgroundColor: spruce,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: parchment),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Projectdevdashboard()));
          },
        ),
        bottom: TabBar(
          indicatorColor: parchment,
          labelColor: parchment,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Verified'),
            Tab(text: 'In Progress'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildProjectList(false), // Verified projects
                _buildProjectList(true), // In Progress projects
              ],
            ),
    );
  }

  Widget _buildProjectList(bool verified) {
    final filteredProjects =
        _projects.where((project) => project.verified == verified).toList();

    return ListView.builder(
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Species: ${project.treeSpecies}'),
            subtitle: Text(
                'Age: ${project.treeAge}, Size: ${project.landSize} acres, Points: ${project.creditPoints}'),
            trailing: Icon(
                project.verified ? Icons.check_circle : Icons.hourglass_empty),
          ),
        );
      },
    );
  }
}

class AuthRepository {
  final String baseUrl;
  AuthRepository({required this.baseUrl});

  Future<String?> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceId');
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth-token');
  }
}
