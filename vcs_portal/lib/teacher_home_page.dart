import 'package:flutter/material.dart';
import 'package:vcs_portal/teacher_ann_page.dart';
import 'package:vcs_portal/profile_page.dart';
import 'package:vcs_portal/settings_pages.dart';
import 'package:vcs_portal/teacher_progress_report.dart';
import 'package:vcs_portal/teacher_qa_screen.dart';
import 'package:vcs_portal/teacher_timetable_page.dart';
import 'package:vcs_portal/api_service.dart';
import 'package:vcs_portal/QuizListPage.dart';
import 'package:vcs_portal/assignments_teacher.dart';
import 'package:vcs_portal/student_table.dart';
import 'package:vcs_portal/chat.dart';
import 'chat_service.dart';
import 'package:vcs_portal/uploads_page.dart';

const double _iconSpacing = 20.0;
const double _imageSize = 50.0;
const double _buttonSizeMinHeight = 80.0;
const double _buttonSizeMinWidth = 140.0;
const double _buttonPadding = 10.0;
const double _iconFontSize = 8.0;
final Color _buttonColor = const Color.fromARGB(190, 255, 255, 255);
const Color _buttonTextColor = Colors.black;
const apiKey = "AIzaSyB1X5nOAzgQTzYIZc4c-JkwO_Li65fgpIY";

class TeacherHomePage extends StatefulWidget {
  final String? username;
  final String? password;
  final String? role;
  const TeacherHomePage({
    super.key,
    required this.username,
    required this.password,
    required this.role,
  });
  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int? _teacherId;
  bool _isLoading = true;
  final _baseUrlCtrl = TextEditingController(text: 'http://192.168.1.9:5000');

  @override
  void initState() {
    super.initState();
    _fetchTeacherId();
  }

  Future<void> _fetchTeacherId() async {
    final ApiService apiService = ApiService('http://192.168.1.9:5000');
    try {
      print('Fetching teacher ID for username: ${widget.username}');
      final teacherId = await apiService.getTeacherId(widget.username!);
      print('Received teacher ID: $teacherId');

      setState(() {
        _teacherId = teacherId;
        _isLoading = false;
      });

      if (teacherId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to get teacher ID. Please check your username and try again.')),
        );
      }
    } catch (e) {
      print('Error fetching teacher ID: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  String getFirstName({required String fullName}) {
    // Split the string by space
    List<String> parts = fullName.trim().split(' ');
    // Return the first part
    return parts.isNotEmpty ? parts[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/vc_drone_view.png',
              ), // Path to your image
              fit: BoxFit.cover, // Adjust how the image fits the container
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 70.0,
                decoration: BoxDecoration(
                  color: Color.fromARGB(225, 0, 73, 137),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withValues(), // Shadow color with opacity
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 20.0),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/VC_icon.png',
                        height: 45.0,
                        width: 45.0,
                      ),
                    ),
                    Text(
                      'VCS Portal',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // Set text color to white for visibility
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle logout action
                        print('Profile button pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                        //Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/profile_icon.png',
                                height: 50.0,
                                width: 50.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
              ),
              Center(
                child: Container(
                  //color: _buttonColor,    //use this for debugging
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            //TextBooks Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => StudentTablePage()),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/VC_icon.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '   Students ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: _iconSpacing),
                          ElevatedButton(
                            //Calendar Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TeacherTimetableScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/timetable.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '     Timetable ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _iconSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              //Past Papers Button
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              print('Past Papers button pressed');
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/VC_icon.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '      Past\n     Papers ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: _iconSpacing),
                          ElevatedButton(
                            //Quizes Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => QuizListPage()),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/VC_icon.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '     Quizes  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _iconSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            //E-library Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              print('E-library button pressed');
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/VC_icon.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '     E-library  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: _iconSpacing),
                          ElevatedButton(
                            //Announcements Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TeacherAnnPage()),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/VC_icon.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '    Announc-\n     ements  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _iconSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            //Ai Bot Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChatApp(
                                        geminiService: GeminiService(apiKey))),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/aibot.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '       AI bot ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: _iconSpacing),
                          ElevatedButton(
                            //Progress Report Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TeacherAddReportPage()),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/progressreport.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '    Progress\n    report ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _iconSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            //Questions Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_teacherId != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TeacherQAScreen(
                                              teacherId: _teacherId!),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Teacher information not available. Please try again later.')),
                                      );
                                    }
                                  },
                            child: _isLoading
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Loading...',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: _iconFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/qa.png',
                                        height: _imageSize,
                                        width: _imageSize,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        '     Questions ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: _iconFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(width: _iconSpacing),
                          ElevatedButton(
                            //Assignments Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TeacherLinkPage()),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/assignments.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '     Assignments ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _iconSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            //Uploads Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UploadPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/assignments.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '     Upload ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: _iconSpacing),
                          ElevatedButton(
                            //Assignments Button
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(_buttonSizeMinWidth, _buttonSizeMinHeight),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // This makes the corners sharp, resulting in a square or rectangle
                                ),
                              ),
                              // Additional styling like background color, padding, etc., can be added here
                              backgroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                _buttonColor,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(_buttonPadding),
                              ), // Adjust padding as needed
                            ),
                            onPressed: () {
                              print('Settings button pressed');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPageStudents(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/settings.png',
                                  height: _imageSize,
                                  width: _imageSize,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '     Settings ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: _iconFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
