import 'package:flutter/material.dart';
import 'package:vcs_portal/profile_page.dart';
import 'Past paper lower school grade 01 page.dart';
import 'Past paper lower school grade 02 page.dart';
import 'Past paper lower school grade 03 page.dart';
import 'Past paper lower school grade 04 page.dart';
import 'Past paper lower school grade 05 page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VCS Portal',
      home: const PrimaryPastPaperPage(),
    );
  }
}

class PrimaryPastPaperPage extends StatelessWidget {
  const PrimaryPastPaperPage({super.key});

  final List<String> grades = const [
    'Grade 01',
    'Grade 02',
    'Grade 03',
    'Grade 04',
    'Grade 05',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/background_image.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 16),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTitle('Past Paper', 'lib/assets/paper.png'),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Primary Section'),
                          const SizedBox(height: 40),
                          _buildGradeButton(
                              grades[0], OnePastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[1], TwoPastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[2], ThreePastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[3], FourPastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[4], FivePastPaperPage(), context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 70,
      color: const Color.fromARGB(255, 0, 6, 75),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Image.asset('lib/assets/logo.png', height: 40),
              const SizedBox(width: 10),
              const Text(
                'VCS Portal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/profile.png'),
              radius: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title, String iconPath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 6, 75).withOpacity(0.8),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 40, width: 40),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 6, 75).withOpacity(0.8),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGradeButton(String grade, Widget page, BuildContext cont) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            cont,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              grade,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
