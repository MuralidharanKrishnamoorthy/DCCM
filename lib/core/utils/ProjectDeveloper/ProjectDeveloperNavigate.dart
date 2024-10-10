import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/ProjectDeveloper/ProjectDetailsupload.dart';
import 'package:dccm/core/utils/ProjectDeveloper/Projectdeveloperdashboard.dart';
import 'package:dccm/core/utils/ProjectDeveloper/Projectstatus.dart';
import 'package:flutter/material.dart';

class Projectdevnavigation extends StatefulWidget {
  const Projectdevnavigation({super.key});

  @override
  State<Projectdevnavigation> createState() => _ProjectdevnavigationState();
}

class _ProjectdevnavigationState extends State<Projectdevnavigation> {
  int currntindex = 0;
  final List<Widget> screens = [
    const Projectdevdashboard(),
    const ProjectDetailsUpload(),
    ProjectStatus(),
  ];
  void ontaped(int index) {
    setState(() {
      currntindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currntindex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: spruce,
        selectedItemColor: forest,
        unselectedItemColor: parchment,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.upload), label: "Details Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.verified), label: "Status")
        ],
        currentIndex: currntindex,
        onTap: ontaped,
      ),
    );
  }
}
