// ignore: file_names

import "package:dccm/Colors.dart";
import "package:flutter/material.dart";

class Projectdevdashboard extends StatefulWidget {
  const Projectdevdashboard({super.key});

  @override
  State<Projectdevdashboard> createState() => _ProjectdevdashboardState();
}

class _ProjectdevdashboardState extends State<Projectdevdashboard> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // List of environmental quotes
  final List<Map<String, String>> environmentalQuotes = [
    {
      "title": "Plant for the Planet",
      "quote":
          "Every tree planted is a carbon capture device in action. Join us in growing a greener future, one sapling at a time."
    },
    {
      "title": "Invest in Earth",
      "quote":
          "Reducing your carbon footprint isn't just a choice, it's an investment in Earth's future. Small changes today create big impacts tomorrow."
    },
    {
      "title": "Nature's Importance",
      "quote":
          "Nature doesn't need people - people need nature. Protect what protects you: our forests, our air, our planet."
    },
    {
      "title": "Be the Solution",
      "quote":
          "Be part of the solution, not the pollution. Together, we can turn the tide on CO2 emissions and breathe life back into our world."
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: spruce,
      body: Stack(
        children: [
          const Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage('https://placeholder.com/40x40'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "John's Forest",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Good Morning",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.notifications_none, color: Colors.white),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.75,
            child: ClipPath(
              clipper: CurvedTopClipper(),
              child: Container(
                color: linen,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemCount: environmentalQuotes.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: parchment,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    environmentalQuotes[index]["title"]!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F4A26)),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    environmentalQuotes[index]["quote"]!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            environmentalQuotes.length,
                            (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? const Color(0xFF0F4A26)
                                        : Colors.grey.shade300,
                                  ),
                                )),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Manage Projects",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implement see all functionality
                            },
                            child: Text(
                              "See all",
                              style: TextStyle(color: spruce),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Project list will be populated from backend",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
