import 'package:flutter/material.dart';
import 'package:vcs_portal/api_service.dart';
import 'package:vcs_portal/profile_page.dart';
import 'package:vcs_portal/settings_pages.dart';
import 'package:vcs_portal/student_progress_report.dart';
import 'package:vcs_portal/student_qa_screen.dart';
import 'package:vcs_portal/timetable_page.dart';
import 'package:vcs_portal/Past_papers/Past paper page one.dart';
import 'package:vcs_portal/TextBooks/TextBook Home Page.dart';
import 'package:vcs_portal/uploads_page.dart';
import 'package:vcs_portal/student_ann_page.dart';
import 'package:vcs_portal/QuizSelectPage.dart';
import 'package:vcs_portal/chat.dart';
import 'chat_service.dart';
import 'package:vcs_portal/assignments_student.dart';

const double _iconSpacing = 25.0;
const double _imageSize = 50.0;
const double _buttonSizeMinHeight = 80.0;
const double _buttonSizeMinWidth = 140.0;
const double _buttonPadding = 10.0;
const double _iconFontSize = 8.0;
final Color _buttonColor = const Color.fromARGB(190, 255, 255, 255);
const Color _buttonTextColor = Colors.black;
const apiKey = "AIzaSyB1X5nOAzgQTzYIZc4c-JkwO_Li65fgpIY";

class StudentHomePage extends StatefulWidget {
  final String? username;
  final String? password;
  final String? role;
  final int userId;

  const StudentHomePage({
    super.key,
    required this.username,
    required this.password,
    required this.role,
    required this.userId,
  });

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int? studentId;
  bool loadingClass = false;
  bool isLoadingStudentId = true;
  final _baseUrlCtrl = TextEditingController(text: 'http://192.168.1.6:5000');

  @override
  void initState() {
    super.initState();
    fetchStuId();
  }

  void fetchStuId() async {
    setState(() {
      studentId = widget.userId;
      bool isLoading = false;
    });
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
                  color: Color.fromARGB(225, 0, 6, 73),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 20.0),
                    Container(
                      child: Image.asset(
                        'assets/images/VC_icon.png',
                        height: 45.0,
                        width: 45.0,
                      ),
                    ),
                    Text(
                      'VCS Portal',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
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
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              //TextBooks Button
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all<Size>(
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                      builder: (_) => TextBookPage()),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/textbooks.png',
                                    height: _imageSize,
                                    width: _imageSize,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '   Textbooks ',
                                    style: TextStyle(
                                      color: _buttonTextColor,
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
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                      builder: (_) => TimetableScreen()),
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
                                      color: _buttonTextColor,
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
                                minimumSize: WidgetStateProperty.all<Size>(
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    ),
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
                                      builder: (_) => PastPaperPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/pastpapers.png',
                                    height: _imageSize,
                                    width: _imageSize,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '      Past\n     Papers ',
                                    style: TextStyle(
                                      color: _buttonTextColor,
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
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                      builder: (_) => QuizSelectPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/quizes.png',
                                    height: _imageSize,
                                    width: _imageSize,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '     Quizes  ',
                                    style: TextStyle(
                                      color: _buttonTextColor,
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
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                          geminiService:
                                              GeminiService(apiKey))),
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
                                      color: _buttonTextColor,
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
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                    builder: (_) => StudentReportsPage(
                                        studentId: studentId!),
                                  ),
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
                                      color: _buttonTextColor,
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
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                if (studentId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StudentQAScreen(
                                          studentId: studentId!),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Student information not available. Please try again later.')),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/questions.png',
                                    height: _imageSize,
                                    width: _imageSize,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '     Q&A ',
                                    style: TextStyle(
                                      color: _buttonTextColor,
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
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StudentAnnPage(studentId: studentId!),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/announcement.png',
                                    height: _imageSize,
                                    width: _imageSize,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '    Announc-\n     ements  ',
                                    style: TextStyle(
                                      color: _buttonTextColor,
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
                                minimumSize: WidgetStateProperty.all<Size>(
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                      color: _buttonTextColor,
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
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                      builder: (_) => StudentLinkPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/qa.png',
                                    height: _imageSize,
                                    width: _imageSize,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '     Assign-\n     ments ',
                                    style: TextStyle(
                                      color: _buttonTextColor,
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
                            SizedBox(width: _iconSpacing),
                            ElevatedButton(
                              //Assignments Button
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all<Size>(
                                  Size(_buttonSizeMinWidth,
                                      _buttonSizeMinHeight),
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
                                        builder: (_) =>
                                            SettingsPageStudents()));
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
                                    '    Settings ',
                                    style: TextStyle(
                                      color: _buttonTextColor,
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
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
