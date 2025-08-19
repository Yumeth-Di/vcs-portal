import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  String _downloadQuality = 'High';
  bool _autoPlayVideos = true;
  String? _newName;
  final List<String> _specialChar = ["!", "@", "#", "%"];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _emailNotifications = prefs.getBool('emailNotifications') ?? true;
      _downloadQuality = prefs.getString('downloadQuality') ?? 'High';
      _autoPlayVideos = prefs.getBool('autoPlayVideo') ?? true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vc_drone_view.png'),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {},
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('Profile'),
              backgroundColor:
                  const Color.fromARGB(225, 0, 6, 73).withOpacity(0.8),
              elevation: 0,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage('assets/images/profile_icon.png'),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Change Name',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      _newName = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changeName,
                    child: const Text('Save Name'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeName() {
    if (_newName != null && _newName!.isNotEmpty) {
      for (var char in _specialChar) {
        if (_newName!.contains(char)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name contains special characters')),
          );
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name changed to $_newName')),
      );
    }
  }
}
