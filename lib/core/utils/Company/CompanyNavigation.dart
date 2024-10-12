import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/Company/Dashboard.dart';
import 'package:dccm/core/utils/Company/Marketplace.dart';
import 'package:dccm/core/utils/Company/Payments.dart';
import 'package:dccm/core/utils/Company/Profile.dart';
import 'package:flutter/material.dart';

class CompanyNavigation extends StatefulWidget {
  const CompanyNavigation({super.key});

  @override
  State<CompanyNavigation> createState() => _CompanyNavigationState();
}

class _CompanyNavigationState extends State<CompanyNavigation> {
  int currentindex = 0;
  final List<Widget> screens = const [
    CompanyDashboard(),
    MarketplaceScreen(),
    CompanyPayments(),
    CompanyProfile()
  ];
  void ontapped(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentindex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: forest,
        unselectedItemColor: parchment,
        backgroundColor: AppTheme.getNavBarBackgroundColor(context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Marketplace",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: "Payments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
        currentIndex: currentindex,
        onTap: ontapped,
      ),
    );
  }
}
