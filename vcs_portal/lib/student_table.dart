import 'package:flutter/material.dart';
import 'api_service.dart';

class StudentTablePage extends StatefulWidget {
  const StudentTablePage({super.key});

  @override
  _StudentTablePageState createState() => _StudentTablePageState();
}

class _StudentTablePageState extends State<StudentTablePage> {
  late Future<List<dynamic>> students;

  @override
  void initState() {
    super.initState();
    students = Api_Service.students();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(225, 0, 6, 73),
        centerTitle: true,
        title: const Text(
          "Student List",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // 🔹 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/vc_drone_view.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Foreground content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Table container with rounded corners
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: students,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No students found"));
                      } else {
                        final studentList = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Color.fromARGB(225, 0, 6, 73)),
                                    headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    columns: const [
                                      DataColumn(label: Text("ID")),
                                      DataColumn(label: Text("Name")),
                                      DataColumn(label: Text("Class")),
                                    ],
                                    rows: List.generate(studentList.length,
                                        (index) {
                                      final student = studentList[index];
                                      final isEven = index % 2 == 0;
                                      return DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) => isEven
                                              ? Colors.white
                                              : Colors.grey.shade200,
                                        ),
                                        cells: [
                                          DataCell(Text(student["id_student"]
                                              .toString())),
                                          DataCell(
                                              Text(student["student_name"])),
                                          DataCell(Text(student["class"])),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NextPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text("Go to Next Page"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true, // ✅ centers the title
        title: const Text(
          "Next Page",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child:
            Text("Welcome to the Next Page!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
