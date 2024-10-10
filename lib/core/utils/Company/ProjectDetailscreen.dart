import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/Company/Payments.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Future<Map<String, dynamic>> _projectFuture;
  static const String baseUrl = 'http://192.168.1.6:8080/api/dccm';
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(3, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _projectFuture = _fetchProjectDetails();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchProjectDetails() async {
    final response =
        await http.get(Uri.parse('$baseUrl/project/${widget.projectId}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load project details');
    }
  }

  void _scrollToSection(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: linen,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          var project = snapshot.data!;
          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: _buildHeaderImage(project)),
                  SliverToBoxAdapter(child: _buildTabBar()),
                  SliverToBoxAdapter(
                      child: _buildDetailsSection(project, _sectionKeys[0])),
                  SliverToBoxAdapter(
                      child: _buildLocationSection(project, _sectionKeys[1])),
                  SliverToBoxAdapter(
                      child: _buildContactSection(project, _sectionKeys[2])),
                  SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                ],
              ),
              _buildBackButton(),
              _buildBottomBar(project),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderImage(Map<String, dynamic> project) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              project['uploadedImages']?[0] ?? 'images/landimage.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 20,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTab('Details', onTap: () => _scrollToSection(0)),
          _buildTab('Location', onTap: () => _scrollToSection(1)),
          _buildTab('Contact', onTap: () => _scrollToSection(2)),
        ],
      ),
    );
  }

  Widget _buildTab(String title, {required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic> project, Key key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Details',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold, color: forest)),
          const SizedBox(height: 10),
          Text('Project ID: ${project['projectId'] ?? 'N/A'}'),
          Text('Issuer ID: ${project['issuerId'] ?? 'N/A'}'),
          Text('Survey ID: ${project['surveyId'] ?? 'N/A'}'),
          const SizedBox(height: 10),
          Text(project['projectDetail'] ?? 'No details available'),
          const SizedBox(height: 20),
          Text('Tree Information',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold, color: forest)),
          const SizedBox(height: 10),
          Text('Land Size: ${project['landSize'] ?? 'N/A'}'),
          Text('Tree Age: ${project['treeAge'] ?? 'N/A'}'),
          Text('Tree Species: ${project['treeSpecies'] ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> project, Key key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold, color: forest)),
          const SizedBox(height: 10),
          Text('Country: ${project['country'] ?? 'N/A'}'),
          Text('State: ${project['state'] ?? 'N/A'}'),
          Text('Pincode: ${project['pincode'] ?? 'N/A'}'),
          Text('Landmark: ${project['landmark'] ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildContactSection(Map<String, dynamic> project, Key key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold, color: forest)),
          const SizedBox(height: 10),
          Text('Landowner: ${project['landownername'] ?? 'N/A'}'),
          Text('Email: ${project['email'] ?? 'N/A'}'),
          Text('Phone: ${project['phone'] ?? 'Not provided'}'),
          const SizedBox(height: 20),
          Text(
            'Credits you Earn',
            style: GoogleFonts.poppins(
                color: forest, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
              'If you buy this project you will reduce ${project['creditPoints']} Tons of CO2 from the Environment'),
          const SizedBox(height: 10),
          Text('Additional Information',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold, color: forest)),
          const SizedBox(height: 10),
          Text('Metamask ID: ${project['metamaskid'] ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Map<String, dynamic> project) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price',
                    style: GoogleFonts.poppins(
                        color: spruce, fontWeight: FontWeight.bold)),
                Text('\$${project['price'] ?? '0.00'}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CompanyPayments()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: spruce,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Buy Now',
                  style: TextStyle(fontSize: 18, color: parchment)),
            ),
          ],
        ),
      ),
    );
  }
}
