import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

class StudentAnnPage extends StatefulWidget {
  final int studentId;
  const StudentAnnPage({super.key, required this.studentId});

  @override
  State<StudentAnnPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentAnnPage> {
  late Future<List<Announcement>> _future;

  @override
  void initState() {
    super.initState();
    _future = Api_Service.getStudentAnnouncements(widget.studentId);
  }

  void _openAnnouncement(Announcement a) async {
    if (a.isNew) {
      await Api_Service.markViewed(a.id, widget.studentId);
      setState(() => a.isNew = false);
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(a.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("By: ${a.teacherName}"),
            const SizedBox(height: 8),
            Text(a.message),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Announcements")),
      body: FutureBuilder<List<Announcement>>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          final anns = snap.data!;
          if (anns.isEmpty)
            return const Center(child: Text("No announcements"));

          return ListView.builder(
            itemCount: anns.length,
            itemBuilder: (ctx, i) {
              final a = anns[i];
              return ListTile(
                title: Text(a.title),
                subtitle: Text("From ${a.teacherName} • ${a.className}"),
                trailing: a.isNew
                    ? const Icon(Icons.fiber_new, color: Colors.red)
                    : const Icon(Icons.check_circle, color: Colors.green),
                onTap: () => _openAnnouncement(a),
              );
            },
          );
        },
      ),
    );
  }
}
