import 'package:flutter/material.dart';
import 'package:vcs_portal/get_started_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.username, required this.role});

  final String username;
  final String role;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // Optional Profile Section
          ListTile(
            leading: const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                  "assets/images/profile_icon.png"), // Replace with your asset
            ),
            title: Text(widget.username),
            subtitle: Text(widget.role),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileNameChangePage(
                      username: widget.username,
                      role: widget.role,
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Change Password
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              // Navigate to change password page
            },
          ),

          // Notifications Toggle
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text("Enable Notifications"),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
            },
          ),

          // Theme Toggle
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: const Text("Dark Theme"),
            value: darkTheme,
            onChanged: (val) {
              setState(() => darkTheme = val);
              // You could add theme management logic here
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Logout logic here
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Close settings
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const GetStartedPage()),
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileNameChangePage extends StatefulWidget {
  const ProfileNameChangePage(
      {super.key, required this.username, required this.role});

  final String username;
  final String role;

  @override
  State<ProfileNameChangePage> createState() => _ProfileNameChangePageState();
}

class _ProfileNameChangePageState extends State<ProfileNameChangePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.username; // Pre-fill with current username
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'New Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to update the name
                Navigator.pop(context, _nameController.text);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
