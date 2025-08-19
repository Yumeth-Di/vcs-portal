import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimetableApp extends StatelessWidget {
  const TimetableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VCS Timetable',
      theme: ThemeData(
        colorSchemeSeed: Color.fromARGB(225, 0, 6, 73),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const TeacherTimetableScreen(),
    );
  }
}

class TeacherTimetableScreen extends StatefulWidget {
  const TeacherTimetableScreen({super.key});

  @override
  State<TeacherTimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TeacherTimetableScreen> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
  final List<String> timeSlots = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00'
  ];

  final List<String> subjects = [
    'English',
    'Maths',
    'Science',
    'ICT',
    'History',
    'Geography',
    'Art',
    'Music',
    'PE',
    'Language',
    'Lunch'
  ];

  Map<String, Map<String, String>> timetableData = {};
  List<String> classes = ['Class 10A', 'Class 10B', 'Class 10C'];
  String selectedClass = 'Class 10A';
  bool isLoading = true;
  bool hasError = false;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.6:5000/api/classes'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          classes = data.cast<String>();
          if (classes.isNotEmpty) {
            selectedClass = classes.first;
            _fetchTimetable();
          }
        });
      } else {
        throw Exception('Failed to load classes');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchTimetable() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.6:5000/api/timetable?class=${Uri.encodeComponent(selectedClass)}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          timetableData = data.map((key, value) {
            final innerMap = (value as Map<String, dynamic>).map(
              (k, v) => MapEntry(k, v.toString()),
            );
            return MapEntry(key, innerMap);
          });
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load timetable');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _updateSubject(
      String day, String timeSlot, String newSubject) async {
    setState(() {
      isUpdating = true;
    });

    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.6:5000/api/timetable/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'class': selectedClass,
          'day': day,
          'time_slot': timeSlot,
          'subject': newSubject,
        }),
      );

      if (response.statusCode == 200) {
        // Update local data
        setState(() {
          timetableData[day]![timeSlot] = newSubject;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject updated successfully')),
        );
      } else {
        throw Exception('Failed to update subject');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  void _showSubjectDialog(String day, String timeSlot, String currentSubject) {
    String selectedSubject =
        currentSubject.isNotEmpty ? currentSubject : subjects.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Change Subject'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Day: $day'),
                  Text('Time: $timeSlot'),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSubject,
                    decoration: const InputDecoration(
                      labelText: 'Select Subject',
                      border: OutlineInputBorder(),
                    ),
                    items: subjects.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSubject = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _updateSubject(day, timeSlot, selectedSubject);
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/vc_drone_view.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.50),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button, logo and title
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 8),
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/VC_icon.png',
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.school,
                                size: 40, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    const Expanded(
                      child: Text(
                        'Teacher Timetable',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Class selector
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<String>(
                      value: selectedClass.isNotEmpty ? selectedClass : null,
                      decoration: const InputDecoration(
                        labelText: 'Select Class',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      items: classes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedClass = newValue!;
                          _fetchTimetable();
                        });
                      },
                    ),
                  ),
                ),
              ),

              // Timetable
              if (isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else if (hasError)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text('Failed to load timetable'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchTimetable,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Scrollable table area
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    // Table header
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // Time header
                                          Container(
                                            width: 100,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: const Text(
                                              'Time',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          // Day headers
                                          ...days.map((day) => Container(
                                                width: 120,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  day,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),

                                    // Table rows
                                    ...timeSlots.map((timeSlot) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Time cell
                                            Container(
                                              width: 100,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                              ),
                                              child: Text(
                                                timeSlot,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            // Day cells
                                            ...days.map((day) {
                                              final subject = timetableData[day]
                                                      ?[timeSlot] ??
                                                  '';
                                              return Container(
                                                width: 120,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _showSubjectDialog(
                                                        day, timeSlot, subject);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: _getSubjectColor(
                                                          subject),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.05),
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          subject,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        if (subject
                                                            .isNotEmpty) ...[
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            'Row item',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors.grey
                                                                  .shade700,
                                                            ),
                                                          ),
                                                        ],
                                                        // Edit indicator
                                                        if (subject.isNotEmpty)
                                                          const Icon(
                                                            Icons.edit,
                                                            size: 12,
                                                            color: Colors.grey,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      );
                                    }).toList(),
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

              // Footer with row count and scroll indicator
              if (!isLoading && !hasError)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.table_rows, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              '${timeSlots.length} rows',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.swipe, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Tap subject to edit',
                              style: TextStyle(
                                color: Colors.grey.shade600,
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

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'english':
        return Colors.blue.shade100;
      case 'english':
        return Colors.pink.shade100;
      case 'maths':
        return Colors.green.shade100;
      case 'science':
        return Colors.purple.shade100;
      case 'ict':
        return Colors.orange.shade100;
      case 'history':
        return Colors.red.shade100;
      case 'geography':
        return Colors.amber.shade100;
      case 'art':
        return Colors.pink.shade100;
      case 'music':
        return Colors.indigo.shade100;
      case 'pe':
        return Colors.teal.shade100;
      case 'language':
        return Colors.cyan.shade100;
      case 'lunch':
        return Colors.grey.shade200;
      default:
        return Colors.grey.shade100;
    }
  }
}
