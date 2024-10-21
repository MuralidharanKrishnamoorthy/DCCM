import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dccm/core/utils/Company/Dashboard.dart';
import 'package:dccm/core/utils/Company/Marketplace.dart';
import 'package:dccm/core/utils/Company/Payments.dart';
import 'package:dccm/core/utils/Company/Profile.dart';

class CompanyNavigation extends StatefulWidget {
  const CompanyNavigation({super.key});

  @override
  State<CompanyNavigation> createState() => _CompanyNavigationState();
}

class _CompanyNavigationState extends State<CompanyNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    CompanyDashboard(),
    MarketplaceScreen(),
    PaymentScreen(project: {}),
    CompanyProfile()
  ];

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingBottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.withOpacity(0.7),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(CupertinoIcons.home, 'Home', 0),
                _buildNavItem(CupertinoIcons.chart_bar, 'Marketplace', 1),
                _buildNavItem(CupertinoIcons.money_dollar, 'Payments', 2),
                _buildNavItem(CupertinoIcons.person, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: isSelected ? 8 : 12),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemGrey,
              size: 24,
            ),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
