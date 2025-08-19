import 'package:flutter/material.dart';
import 'api_service.dart';

class TeacherAnnPage extends StatefulWidget {
  const TeacherAnnPage({super.key});

  @override
  State<TeacherAnnPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherAnnPage> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? selectedClass;
  int? selectedTeacherId;
  List<String> classes = [];
  List<Map<String, dynamic>> teachers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final fetchedClasses = await Api_Service.getClass();
      final fetchedTeachers = await Api_Service.getTeachers();
      setState(() {
        classes = [...fetchedClasses, "All"];
        teachers = fetchedTeachers;
        if (classes.isNotEmpty) selectedClass = classes.first;
        if (teachers.isNotEmpty)
          selectedTeacherId = teachers.first["teacher_id"];
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  void _submit() async {
    if (_titleController.text.isEmpty ||
        _messageController.text.isEmpty ||
        selectedClass == null ||
        selectedTeacherId == null) return;

    await Api_Service.createAnnouncement(
      title: _titleController.text,
      message: _messageController.text,
      className: selectedClass!,
      teacherId: selectedTeacherId!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Announcement posted")),
    );
    _titleController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: "Message"),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            classes.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
                    value: selectedClass,
                    items: classes
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedClass = val),
                  ),
            teachers.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<int>(
                    value: selectedTeacherId,
                    items: teachers
                        .map((t) => DropdownMenuItem<int>(
                            value: t["teacher_id"],
                            child: Text(t["teacher_name"])))
                        .toList(),
                    onChanged: (val) => setState(() => selectedTeacherId = val),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text("Publish"))
          ],
        ),
      ),
    );
  }
}
