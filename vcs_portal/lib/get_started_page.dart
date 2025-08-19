import 'package:flutter/material.dart';
import 'login_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/vc_drone_view.png'), // Your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(70.0),
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/VC_icon.png',
                    height: 65.0,
                    width: 65.0,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to the Vidura College Student Portal',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 28.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                const Text(
                  'The place where all of your academic work is organized and kept in place.',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 36, 66),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login and Get Started',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
