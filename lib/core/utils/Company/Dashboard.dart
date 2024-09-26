import 'package:dccm/Colors.dart';
import 'package:flutter/material.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: linen,
      body: SafeArea(
        child: Column(
          children: [
            _buildEmissionWidget(),
            Expanded(
              child: _buildProjectsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmissionWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: spruce,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.favorite_border, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const Text(
                '12 KgCo2',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Daily Emission',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manage Projects',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'See all',
                style: TextStyle(color: spruce),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildProjectCard(
                  'Pine Tree',
                  '8 Acres of pine Tree plantation at Affordable Cost',
                  'Alabama',
                ),
                const SizedBox(height: 16),
                _buildProjectCard(
                  'Pine Tree',
                  '9 Acres of pine Tree plantation at Affordable Cost',
                  'Alabama',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, String location) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            color: Colors.grey[300],
            width: double.infinity,
            child: const Center(child: Text('Forest Image')),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(location),
                    const Spacer(),
                    const Icon(Icons.favorite_border),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
