import 'package:flutter/material.dart';
import 'package:vcs_portal/profile_page.dart';
import 'Past paper upper school grade 06 page.dart';
import 'Past paper upper school grade 07 page.dart';
import 'Past paper upper school grade 08 page.dart';
import 'Past paper upper school grade 09 page.dart';
import 'Past paper upper school grade 10 page.dart';
import 'Past paper upper school grade 11 page.dart';

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
      home: const UpperPastPaperPage(),
    );
  }
}

class UpperPastPaperPage extends StatelessWidget {
  const UpperPastPaperPage({super.key});

  final List<String> grades = const [
    'Grade 06',
    'Grade 07',
    'Grade 08',
    'Grade 09',
    'Grade 10',
    'Grade 11',
    'A/L',
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
                          _buildTitle('Text Book', 'lib/assets/bookshelf.png'),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Upper Section'),
                          const SizedBox(height: 40),
                          _buildGradeButton(
                              grades[0], SixPastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[1], SevenPastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[2], EightPastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[3], NinePastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[4], TenPastPaperPage(), context),
                          const SizedBox(height: 10),
                          _buildGradeButton(
                              grades[5], ElevenPastPaperPage(), context),
                          const SizedBox(height: 10),
                          //_buildGradeButton(grades[6],ALPastPaperPage(),context),
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
