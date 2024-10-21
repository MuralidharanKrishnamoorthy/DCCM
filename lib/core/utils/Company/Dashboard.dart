import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/Company/Marketplace.dart';
import 'package:dccm/customappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  static const Color kPrimaryGreen = Color(0xFF4CAF50);
  static const Color kAccentOrange = Color(0xFFFF9800);
  static const Color kTextColor = Color(0xFF333333);
  double _co2EmissionRate = 0.0;
  @override
  void initState() {
    super.initState();
    _loadCO2EmissionRate();
  }

  Future<void> _loadCO2EmissionRate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dynamic rateValue = prefs.get('co2_emission_rate');
      print('Loaded CO2 emission rate value: $rateValue'); // Debug print
      print(
          'Type of loaded emission rate: ${rateValue.runtimeType}'); // Debug print

      if (rateValue != null) {
        double? rate;
        if (rateValue is String) {
          rate = double.tryParse(rateValue);
        } else if (rateValue is double) {
          rate = rateValue;
        } else if (rateValue is int) {
          rate = rateValue.toDouble();
        }

        if (rate != null) {
          setState(() {
            _co2EmissionRate = rate!;
          });
          print('Parsed CO2 emission rate: $_co2EmissionRate'); // Debug print
        } else {
          print('Failed to parse CO2 emission rate: $rateValue');
          _co2EmissionRate = 0.0;
        }
      } else {
        print('CO2 emission rate not found in SharedPreferences');
        _co2EmissionRate = 0.0; // Set a default value if no data is found
      }
    } catch (e) {
      print('Error loading CO2 emission rate: $e');
      _co2EmissionRate = 0.0; // Set a default value if an error occurs
    }
  }

  String _calculateEmission(String period) {
    print(
        'Calculating emission for $period, daily rate: $_co2EmissionRate'); // Debug print
    switch (period) {
      case 'Daily':
        return _co2EmissionRate.toStringAsFixed(2);
      case 'Monthly':
        return (_co2EmissionRate * 30).toStringAsFixed(2);
      case 'Yearly':
        return (_co2EmissionRate * 365).toStringAsFixed(2);
      default:
        return '0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: kParchment,
        navigationBar: const CustomAppbar(),
        // CupertinoNavigationBar(
        //   backgroundColor: AppTheme.getAppBarBackgroundColor(context),
        //   border: null,
        //   automaticallyImplyLeading: false,
        // ),
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
                    Expanded(
                        child: _buildEmissionItem(
                            "Daily", _calculateEmission("Daily"), "KgCO2")),
                    Expanded(
                        child: _buildEmissionItem(
                            "Monthly", _calculateEmission("Monthly"), "KgCO2")),
                    Expanded(
                        child: _buildEmissionItem(
                            "Yearly", _calculateEmission("Yearly"), "KgCO2")),
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
              const Icon(
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
    String addSpacesToValue(String input) {
      return input.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      );
    }

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            addSpacesToValue(value),
            style: GoogleFonts.poppins(
              color: kLinen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing:
                  1.2, // Add some letter spacing for better readability
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: GoogleFonts.poppins(
            color: kLinen.withOpacity(0.8),
            fontSize: 12,
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MarketplaceScreen()));
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
              style: GoogleFonts.poppins(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
