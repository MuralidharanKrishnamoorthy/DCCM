import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/ProjectDeveloper/ProjectDetailsupload.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

class ProjectDeveloperDashboard extends StatefulWidget {
  const ProjectDeveloperDashboard({super.key});

  @override
  State<ProjectDeveloperDashboard> createState() =>
      _ProjectDeveloperDashboardState();
}

class _ProjectDeveloperDashboardState extends State<ProjectDeveloperDashboard> {
  // Custom color scheme
  static const Color kPrimaryGreen = Color(0xFF4CAF50);
  static const Color kSecondaryBlue = Color(0xFF03A9F4);
  static const Color kAccentOrange = Color(0xFFFF9800);
  static const Color kTextColor = Color(0xFF333333);

  // Colors from your provided color scheme

  // Placeholder for project metrics
  int activeProjects = 0;
  int verifiedProjects = 0;
  int projectsSold = 0;

  @override
  void initState() {
    super.initState();
    _fetchProjectMetrics();
  }

  // Placeholder method to fetch project metrics
  void _fetchProjectMetrics() async {
    // TODO: Implement actual database fetch
    // For now, we'll use placeholder values
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network delay
    setState(() {
      activeProjects = 15; // Placeholder value
      verifiedProjects = 8; // Placeholder value
      projectsSold = 5; // Placeholder value
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: kParchment,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.getAppBarBackgroundColor(context),
        border: null,
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    const SizedBox(height: 24),
                    _buildProjectMetrics(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildManageProjects(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome back, ",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        const SizedBox(height: 8),
        Text(
          "Here's an overview of your current projects.",
          style: TextStyle(fontSize: 16, color: kTextColor.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildProjectMetrics() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kDeepBlue, skyBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kDeepBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Project Overview",
                  style: TextStyle(
                      color: kLinen, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricItem("Active Projects", "$activeProjects"),
                    _buildMetricItem("Verified Projects", "$verifiedProjects"),
                    _buildMetricItem("Projects Sold", "$projectsSold"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              color: kLinen, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: kLinen.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildActionCard(
                    "New Project", CupertinoIcons.add_circled, kPrimaryGreen)),
            const SizedBox(width: 16),
            Expanded(
                child: GestureDetector(
              child: _buildActionCard("Update Status",
                  CupertinoIcons.arrow_up_right_square, kSecondaryBlue),
            )),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildActionCard("View Reports",
                    CupertinoIcons.chart_bar_square, kAccentOrange)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildActionCard(
                    "Team Chat", CupertinoIcons.chat_bubble_2, kVibrantBlue)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProjectDetailsUpload()));
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Manage Projects",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: kLinen,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ],
    );
  }
}
