import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherAddReportPage extends StatefulWidget {
  const TeacherAddReportPage({Key? key}) : super(key: key);

  @override
  State<TeacherAddReportPage> createState() => _TeacherAddReportPageState();
}

class _TeacherAddReportPageState extends State<TeacherAddReportPage> {
  bool loadingStudents = true;
  bool submitting = false;
  List students = [];
  int? selectedStudentId;

  final _termController = TextEditingController();
  final _remarksController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Map<String, TextEditingController>> subjectControllers = [];

  final backendBase = "http://192.168.1.6:5000"; // Change for your setup

  @override
  void initState() {
    super.initState();
    fetchStudents();
    addSubjectRow(); // Start with one row
  }

  Future<void> fetchStudents() async {
    try {
      final resp = await http.get(Uri.parse("$backendBase/student"));
      if (resp.statusCode == 200) {
        setState(() {
          students = jsonDecode(resp.body);
          loadingStudents = false;
          if (students.isNotEmpty) selectedStudentId = students[0]['id'];
        });
      } else {
        throw Exception("Failed to get students");
      }
    } catch (e) {
      print("Error fetching students: $e");
      setState(() => loadingStudents = false);
    }
  }

  void addSubjectRow() {
    setState(() {
      subjectControllers.add({
        'subject': TextEditingController(),
        'grade': TextEditingController(),
      });
    });
  }

  void removeSubjectRow(int index) {
    setState(() {
      subjectControllers[index]['subject']?.dispose();
      subjectControllers[index]['grade']?.dispose();
      subjectControllers.removeAt(index);
    });
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> submitReport() async {
    if (selectedStudentId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Select a student")));
      return;
    }

    List<Map<String, String>> subjects = [];
    for (var row in subjectControllers) {
      final s = row['subject']!.text.trim();
      final g = row['grade']!.text.trim();
      if (s.isNotEmpty) {
        subjects.add({"subject": s, "grade": g});
      }
    }
    if (subjects.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Add at least one subject")));
      return;
    }

    final payload = {
      "student_id": selectedStudentId,
      "term": _termController.text.trim(),
      "remarks": _remarksController.text.trim(),
      "date": selectedDate.toIso8601String().substring(0, 10),
      "subjects": subjects,
    };

    setState(() => submitting = true);
    try {
      final resp = await http.post(
        Uri.parse("$backendBase/progress_reports"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      if (resp.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Report added successfully")));
        _termController.clear();
        _remarksController.clear();
        subjectControllers.forEach((ctrl) {
          ctrl['subject']!.clear();
          ctrl['grade']!.clear();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${resp.body}")));
      }
    } catch (e) {
      print("Error submitting report: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submission failed")));
    } finally {
      setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Progress Report",
          selectionColor: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(225, 0, 6, 73),
      ),
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
        child: loadingStudents
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButton<int>(
                        value: selectedStudentId,
                        isExpanded: true,
                        hint: Text("Select student"),
                        items: students.map<DropdownMenuItem<int>>((s) {
                          return DropdownMenuItem<int>(
                            value: s['id'],
                            child: Text(s['name']),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => selectedStudentId = val),
                      ),
                      SizedBox(height: 12),
                      TextField(
                          controller: _termController,
                          decoration: InputDecoration(labelText: "Term")),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                              "Date: ${selectedDate.toIso8601String().substring(0, 10)}"),
                          SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: pickDate, child: Text("Pick Date")),
                        ],
                      ),
                      SizedBox(height: 12),
                      TextField(
                          controller: _remarksController,
                          decoration: InputDecoration(labelText: "Remarks"),
                          maxLines: 3),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subjects",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ElevatedButton.icon(
                            onPressed: addSubjectRow,
                            icon: Icon(Icons.add),
                            label: Text("Add"),
                          ),
                        ],
                      ),
                      for (var i = 0; i < subjectControllers.length; i++)
                        Row(
                          children: [
                            Expanded(
                                child: TextField(
                                    controller: subjectControllers[i]
                                        ['subject'],
                                    decoration:
                                        InputDecoration(labelText: "Subject"))),
                            SizedBox(width: 8),
                            Expanded(
                                child: TextField(
                                    controller: subjectControllers[i]['grade'],
                                    decoration:
                                        InputDecoration(labelText: "Grade"))),
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => removeSubjectRow(i)),
                          ],
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: submitting ? null : submitReport,
                        child: submitting
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
