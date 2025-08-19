import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentReportsPage extends StatefulWidget {
  final int studentId;
  const StudentReportsPage({required this.studentId, Key? key})
      : super(key: key);

  @override
  State<StudentReportsPage> createState() => _StudentReportsPageState();
}

class _StudentReportsPageState extends State<StudentReportsPage> {
  List reports = [];
  bool loading = true;
  final backendBase = "http://192.168.1.6:5000";

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final resp = await http
          .get(Uri.parse("$backendBase/progress_reports/${widget.studentId}"));
      if (resp.statusCode == 200) {
        setState(() {
          reports = jsonDecode(resp.body);
          loading = false;
        });
      } else {
        throw Exception("Failed to load reports");
      }
    } catch (e) {
      print("Error fetching reports: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Progress Reports",
          selectionColor: const Color.fromARGB(255, 255, 255, 255),
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
        child: loading
            ? Center(child: CircularProgressIndicator())
            : reports.isEmpty
                ? Center(child: Text("No reports found."))
                : ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final r = reports[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text("Term: ${r['term']}"),
                          subtitle: Text("Date: ${r['date']}"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportDetailsPage(report: r),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final Map report;
  const ReportDetailsPage({required this.report, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Term: ${report['term']}")),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Date: ${report['date']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Remarks:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(report['remarks'] ?? "No remarks."),
            SizedBox(height: 16),
            Text("Subjects & Grades:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Subject",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Grade",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ]),
                for (var subj in report['subjects'])
                  TableRow(children: [
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(subj['subject'])),
                    Padding(
                        padding: EdgeInsets.all(8), child: Text(subj['grade'])),
                  ]),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
