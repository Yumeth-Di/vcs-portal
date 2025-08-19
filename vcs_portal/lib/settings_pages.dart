import 'package:flutter/material.dart';
import 'package:vcs_portal/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vcs_portal/get_started_page.dart';

class SettingsPageStudents extends StatefulWidget {
  const SettingsPageStudents({super.key});

  @override
  State<SettingsPageStudents> createState() => _SettingsPageStudentsState();
}

class _SettingsPageStudentsState extends State<SettingsPageStudents> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  String _downloadQuality = 'High';
  bool _autoPlayVideos = true;

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
      _autoPlayVideos = prefs.getBool('autoPlayVideos') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vc_drone_view.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // App Bar with Icon and Title
                Container(
                  height: 70,
                  color: const Color.fromARGB(255, 0, 6, 73),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Image.asset('assets/images/VC_icon.png', height: 40),
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
                          // Navigate to profile page if needed
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: const AssetImage(
                            'assets/images/profile_icon.png',
                          ),
                          radius: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 50),

                        // Title
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              0,
                              6,
                              75,
                            ).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/settings.png', // icon image for past paper
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Settings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 50),

                        // Account Section
                        _buildSectionCard(
                          title: 'Account and preferences',
                          children: [
                            _buildSettingsItem(
                              icon: Icons.person,
                              title: 'Change Name',
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()))
                              },
                            ),
                            _buildSettingsItem(
                              icon: Icons.person,
                              title: 'Change Password',
                              onTap: () => print("hello world"),
                            ),
                            _buildSwitchItem(
                              icon: Icons.notifications,
                              title: 'Push Notifications',
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() => _notificationsEnabled = value);
                                _saveSetting('notificationsEnabled', value);
                              },
                            ),
                            _buildSwitchItem(
                              icon: Icons.email,
                              title: 'Email Notifications',
                              value: _emailNotifications,
                              onChanged: (value) {
                                setState(() => _emailNotifications = value);
                                _saveSetting('emailNotifications', value);
                              },
                            ),
                            _buildDropdownItem(
                              icon: Icons.high_quality,
                              title: 'Video Quality',
                              value: _downloadQuality,
                              items: ['Low', 'Medium', 'High'],
                              onChanged: (value) {
                                setState(() => _downloadQuality = value!);
                                _saveSetting('downloadQuality', value);
                              },
                            ),
                            _buildSwitchItem(
                              icon: Icons.play_circle,
                              title: 'Auto-play Videos',
                              value: _autoPlayVideos,
                              onChanged: (value) {
                                setState(() => _autoPlayVideos = value);
                                _saveSetting('autoPlayVideos', value);
                              },
                            ),
                            // Removed Enrollment History
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Support Section
                        _buildSectionCard(
                          title: 'Support',
                          children: [
                            _buildSettingsItem(
                              icon: Icons.help,
                              title: 'Help Center',
                              onTap: () => _showComingSoonDialogSupport(),
                            ),
                            _buildSettingsItem(
                              icon: Icons.contact_support,
                              title: 'Contact Support',
                              onTap: () => _showComingSoonDialogSupport(),
                            ),
                            _buildSettingsItem(
                              icon: Icons.privacy_tip,
                              title: 'Privacy Policy',
                              onTap: () => _showComingSoonDialogSupport(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // About Section
                        _buildSectionCard(
                          title: 'About',
                          children: [
                            _buildSettingsItem(
                              icon: Icons.info,
                              title: 'App Version',
                              subtitle: '2.1.0',
                              onTap: null,
                            ),
                            _buildSettingsItem(
                              icon: Icons.star,
                              title: 'Rate Us',
                              onTap: () => _showComingSoonDialog(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Logout Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: _showLogoutDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 6, 75),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
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

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 6, 75),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Section Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text(
          'This feature will be available in future updates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialogSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text(
          'This feature will be available in future updates. (SPECIAL: This function would lead to the VCS portal website)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GetStartedPage()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class SettingsPageTeachers extends StatefulWidget {
  final bool isClassTeacher;
  final String? className;

  const SettingsPageTeachers({
    super.key,
    this.isClassTeacher = false,
    this.className,
  });

  @override
  State<SettingsPageTeachers> createState() => _SettingsPageTeachersState();
}

class _SettingsPageTeachersState extends State<SettingsPageTeachers> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _autoGradeSubmissions = false;
  bool _allowLateSubmissions = true;
  String _defaultGradeScale = 'Percentage';
  String _attendanceMethod = 'Manual';
  int _defaultAssignmentDuration = 7; // in days

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
      _autoGradeSubmissions = prefs.getBool('autoGradeSubmissions') ?? false;
      _allowLateSubmissions = prefs.getBool('allowLateSubmissions') ?? true;
      _defaultGradeScale = prefs.getString('defaultGradeScale') ?? 'Percentage';
      _attendanceMethod = prefs.getString('attendanceMethod') ?? 'Manual';
      _defaultAssignmentDuration =
          prefs.getInt('defaultAssignmentDuration') ?? 7;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vc_drone_view.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // App Bar with Icon and Title
                Container(
                  height: 70,
                  color: const Color.fromARGB(255, 0, 6, 75),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Image.asset('assets/images/VC_icon.png', height: 40),
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
                          // Navigate to profile page if needed
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: const AssetImage(
                            'assets/images/profile_icon.png',
                          ),
                          radius: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Settings Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Account Section
                        _buildSectionCard(
                          title: 'Account',
                          children: [
                            _buildSettingsItem(
                              icon: Icons.person,
                              title: 'Profile Settings',
                              onTap: () => _showComingSoonDialog(),
                            ),
                            _buildSettingsItem(
                              icon: Icons.lock,
                              title: 'Change Password',
                              onTap: () => _showComingSoonDialog(),
                            ),
                            // Removed Teaching Subjects
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Classroom Management Section
                        _buildSectionCard(
                          title: 'Classroom Management',
                          children: [
                            _buildSwitchItem(
                              icon: Icons.auto_stories,
                              title: 'Auto-grade Submissions',
                              subtitle:
                                  'Automatically grade objective questions',
                              value: _autoGradeSubmissions,
                              onChanged: (value) {
                                setState(() => _autoGradeSubmissions = value);
                                _saveSetting('autoGradeSubmissions', value);
                              },
                            ),
                            _buildSwitchItem(
                              icon: Icons.schedule,
                              title: 'Allow Late Submissions',
                              subtitle: 'Students can submit after deadline',
                              value: _allowLateSubmissions,
                              onChanged: (value) {
                                setState(() => _allowLateSubmissions = value);
                                _saveSetting('allowLateSubmissions', value);
                              },
                            ),
                            _buildSliderItem(
                              icon: Icons.timer,
                              title: 'Default Assignment Duration',
                              subtitle: '$_defaultAssignmentDuration days',
                              value: _defaultAssignmentDuration.toDouble(),
                              min: 1,
                              max: 30,
                              divisions: 29,
                              onChanged: (value) {
                                setState(
                                  () => _defaultAssignmentDuration =
                                      value.round(),
                                );
                                _saveSetting(
                                  'defaultAssignmentDuration',
                                  value.round(),
                                );
                              },
                            ),
                            _buildDropdownItem(
                              icon: Icons.grading,
                              title: 'Default Grade Scale',
                              value: _defaultGradeScale,
                              items: ['Percentage', 'Letter Grade', 'Points'],
                              onChanged: (value) {
                                setState(() => _defaultGradeScale = value!);
                                _saveSetting('defaultGradeScale', value);
                              },
                            ),
                            _buildDropdownItem(
                              icon: Icons.how_to_reg,
                              title: 'Attendance Method',
                              value: _attendanceMethod,
                              items: ['Manual', 'QR Code', 'Biometric'],
                              onChanged: (value) {
                                setState(() => _attendanceMethod = value!);
                                _saveSetting('attendanceMethod', value);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Communication Section
                        _buildSectionCard(
                          title: 'Communication',
                          children: [
                            _buildSwitchItem(
                              icon: Icons.notifications,
                              title: 'Push Notifications',
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() => _notificationsEnabled = value);
                                _saveSetting('notificationsEnabled', value);
                              },
                            ),
                            _buildSwitchItem(
                              icon: Icons.email,
                              title: 'Email Notifications',
                              value: _emailNotifications,
                              onChanged: (value) {
                                setState(() => _emailNotifications = value);
                                _saveSetting('emailNotifications', value);
                              },
                            ),
                            // Removed Enable Discussion Forums
                            // Removed Notify on New Enrollment
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Support Section
                        _buildSectionCard(
                          title: 'Support',
                          children: [
                            _buildSettingsItem(
                              icon: Icons.help,
                              title: 'Help Center',
                              onTap: () => _showComingSoonDialog(),
                            ),
                            _buildSettingsItem(
                              icon: Icons.contact_support,
                              title: 'Contact Support',
                              onTap: () => _showComingSoonDialog(),
                            ),
                            _buildSettingsItem(
                              icon: Icons.privacy_tip,
                              title: 'Privacy Policy',
                              onTap: () => _showComingSoonDialog(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // About Section
                        _buildSectionCard(
                          title: 'About',
                          children: [
                            _buildSettingsItem(
                              icon: Icons.info,
                              title: 'App Version',
                              subtitle: '2.1.0',
                              onTap: null,
                            ),
                            _buildSettingsItem(
                              icon: Icons.star,
                              title: 'Rate Us',
                              onTap: () => _showComingSoonDialog(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Logout Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: _showLogoutDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
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

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Section Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade800),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: Colors.blue.shade800,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text(
          'This feature will be available in future updates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement logout logic
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
