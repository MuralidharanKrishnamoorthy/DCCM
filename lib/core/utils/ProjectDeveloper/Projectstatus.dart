import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/ProjectDeveloper/Projectdeveloperdashboard.dart';
import 'package:flutter/material.dart';

class Projectstatus extends StatefulWidget {
  @override
  _Projectstatus createState() => _Projectstatus();
}

class _Projectstatus extends State<Projectstatus>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: parchment,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Projectdevdashboard())); // Navigate back to the previous page
          },
        ),
        //title: Text('Status', style: GoogleFonts.lato(fontSize: 20)),
        bottom: TabBar(
          indicatorColor: parchment,
          indicatorWeight: 1,
          labelColor: parchment,
          controller: _tabController,
          dividerColor: parchment,
          tabs: const [
            Tab(text: 'Verified'),
            Tab(text: 'In Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVerifiedTab(),
          _buildInProgressTab(),
        ],
      ),
    );
  }

  Widget _buildVerifiedTab() {
    return const Center(
      child: Text(
        '', // Placeholder for Verified content
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildInProgressTab() {
    return const Center(
      child: Text(
        '', // Placeholder for In Progress content
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
