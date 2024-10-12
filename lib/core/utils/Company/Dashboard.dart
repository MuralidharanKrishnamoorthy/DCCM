import 'package:dccm/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  static const Color kPrimaryGreen = Color(0xFF4CAF50);
  static const Color kAccentOrange = Color(0xFFFF9800);
  static const Color kTextColor = Color(0xFF333333);

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
                    _buildEmissionMetrics(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildPurchasedProjects(),
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
        Text(
          "Welcome back!",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Monitor your carbon emissions and offset through tree planting.",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: kTextColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildEmissionMetrics() {
    return Container(
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
                Text(
                  "Carbon Emission Overview",
                  style: GoogleFonts.poppins(
                    color: kLinen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildEmissionItem("Daily", "12", "KgCO2"),
                    _buildEmissionItem("Monthly", "360", "KgCO2"),
                    _buildEmissionItem("Yearly", "4,380", "KgCO2"),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTreePlantingSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTreePlantingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kLinen.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.tree,
                color: kLinen,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "Tree Planting Impact",
                style: GoogleFonts.poppins(
                  color: kLinen,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Plant 100 trees this year to offset your carbon footprint",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: kLinen.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Join our global initiative to combat climate change one tree at a time",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: kLinen.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            onPressed: () {
              // Handle button press
            },
            child: Text(
              'Start Planting',
              style: GoogleFonts.poppins(
                color: kLinen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmissionItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: kLinen,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: GoogleFonts.poppins(
            color: kLinen.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: kLinen.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                "Buy Carbon Credits",
                CupertinoIcons.cart_fill,
                kPrimaryGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                "View History",
                CupertinoIcons.chart_bar_square,
                kAccentOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
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
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasedProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Purchased Projects",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: kLinen,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                CupertinoIcons.doc_text,
                size: 40,
                color: kTextColor.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 8),
              Text(
                'Start investing in carbon offset projects to see them here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: kTextColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
