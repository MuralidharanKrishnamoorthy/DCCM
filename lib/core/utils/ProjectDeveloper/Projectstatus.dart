import 'dart:async';
import 'dart:convert';
import 'package:dccm/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dccm/core/utils/ProjectDeveloper/ProjectDeveloperNavigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Project {
  final String id;
  final String treeSpecies;
  final int treeAge;
  final double landSize;
  final bool verified;
  final double creditPoints;
  final String email;

  Project({
    required this.id,
    required this.treeSpecies,
    required this.treeAge,
    required this.landSize,
    required this.verified,
    required this.creditPoints,
    required this.email,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      treeSpecies: json['treeSpecies'],
      treeAge: json['treeAge'],
      landSize: json['landSize'].toDouble(),
      verified: json['verified'] ?? false,
      creditPoints: (json['creditPoints'] ?? 0).toDouble(),
      email: json['email'],
    );
  }
}

class ProjectStatus extends StatefulWidget {
  const ProjectStatus({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProjectStatusState createState() => _ProjectStatusState();
}

class _ProjectStatusState extends State<ProjectStatus>
    with SingleTickerProviderStateMixin {
  int verifiedProjectCount = 0;
  int inProgressProjectCount = 0;
  late TabController _tabController;
  List<Project> _projects = [];
  bool _isLoading = true;
  String? _deviceId;
  final AuthRepository authRepository =
      AuthRepository(baseUrl: 'http://192.168.122.19:8080/api/dccm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData().then((_) => _fetchProjects());
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _deviceId = prefs.getString('device_id');
    });
  }

  Future<void> _fetchProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authToken = await authRepository.getAuthToken();

      if (_deviceId == null || authToken == null) {
        throw Exception('Device ID or Auth Token not found');
      }

      final response = await http.get(
        Uri.parse('${authRepository.baseUrl}/projects/$_deviceId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> projectsJson = json.decode(response.body);
        setState(() {
          _projects =
              projectsJson.map((json) => Project.fromJson(json)).toList();
          _isLoading = false;
        });

        await _saveProjectsLocally(_projects);
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      await _loadProjectsLocally();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProjectsLocally(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = projects
        .map((p) => {
              'id': p.id,
              'treeSpecies': p.treeSpecies,
              'treeAge': p.treeAge,
              'landSize': p.landSize,
              'verified': p.verified,
              'creditPoints': p.creditPoints,
              'email': p.email,
            })
        .toList();
    await prefs.setString('projects', json.encode(projectsJson));
  }

  Future<void> _loadProjectsLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getString('projects');
    if (projectsJson != null) {
      final List<dynamic> decoded = json.decode(projectsJson);
      setState(() {
        _projects = decoded.map((json) => Project.fromJson(json)).toList();
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
    return CupertinoPageScaffold(
      backgroundColor: kParchment,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.getAppBarBackgroundColor(context),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: CircleAvatar(
            backgroundColor: AppTheme.getAppBarForegroundColor(context)
                .withOpacity(0.1), // Color with opacity
            radius: 18,
            child: Icon(
              CupertinoIcons.back,
              color: AppTheme.getActionIconColor(context),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => const Projectdevnavigation(
                        projectCounts: {},
                      )),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoSegmentedControl<int>(
              padding: const EdgeInsets.symmetric(vertical: 20),
              selectedColor:
                  AppTheme.getTabBarIconColor(context, isSelected: true),
              borderColor:
                  AppTheme.getTabBarIconColor(context, isSelected: true),
              children: const {
                0: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text('Verified'),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text('In Progress'),
                ),
              },
              onValueChanged: (int index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              groupValue: _tabController.index,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildProjectList(true),
                        _buildProjectList(false),
                      ],
                    ),
            ),
          ],
        ),
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.getCardBackgroundColor(context),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  CupertinoColors.activeGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                                CupertinoIcons.leaf_arrow_circlepath,
                                color: CupertinoColors.activeGreen),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(project.treeSpecies,
                                  style: AppTheme.getHeadlineStyle(context)),
                              Text('ID: ${project.id}',
                                  style: TextStyle(
                                      color: AppTheme.getSecondaryTextColor(
                                          context))),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        project.verified
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons.clock,
                        color: project.verified
                            ? CupertinoColors.activeGreen
                            : CupertinoColors.systemGrey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem('Age', '${project.treeAge} years'),
                      _buildInfoItem('Land Size', '${project.landSize} acres'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                          'Credit Points', project.creditPoints.toString(),
                          isHighlighted: true),
                      _buildInfoItem('Email', project.email, isSmall: true),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value,
      {bool isHighlighted = false, bool isSmall = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTheme.getHeadlineStyle(context).copyWith(fontSize: 15)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmall ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: isHighlighted
                ? CupertinoColors.activeGreen
                : AppTheme.getSecondaryTextColor(context),
          ),
        ),
      ],
    );
  }
}

class AuthRepository {
  final String baseUrl;
  // ignore: constant_identifier_names
  static const String DEVICE_ID_KEY = 'device_id';
  // ignore: constant_identifier_names
  static const String AUTH_TOKEN_KEY = 'auth-token';

  AuthRepository({required this.baseUrl});

  Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(DEVICE_ID_KEY);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN_KEY);
  }
}
