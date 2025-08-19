import 'package:flutter/material.dart';
import 'package:vcs_portal/profile_page.dart';

class AssignmentAnswerPage extends StatefulWidget {
  const AssignmentAnswerPage({super.key});

  @override
  State<AssignmentAnswerPage> createState() => _AssignmentAnswerPageState();
}

class _AssignmentAnswerPageState extends State<AssignmentAnswerPage> {
  // MCQ data
  List<Map<String, dynamic>> mcqQuestions = List.generate(
      40,
      (index) => {
            'question': 'MCQ Question ${index + 1}?',
            'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          });

// Store selected answers for all 40 MCQs
  List<int?> selectedAnswers = List.generate(40, (index) => null);

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
                // Top bar
                Container(
                  height: 70,
                  color: const Color.fromARGB(255, 0, 6, 75),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile_icon.png'),
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 6, 73),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/quizes.png',
                          height: 40, width: 40),
                      const SizedBox(width: 10),
                      const Text(
                        'Quiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // MCQ list
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Multiple Choice Questions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(40, (index) {
                          return _buildMCQAnswer(index);
                        }),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 6, 73),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Quiz submitted successfully!"),
                              ),
                            );
                          },
                          child: const Text(
                            "Submit Answers",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
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

  Widget _buildMCQAnswer(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Q${index + 1}. ${mcqQuestions[index]['question']}"),
          ...List.generate(4, (optIndex) {
            return RadioListTile<int>(
              value: optIndex,
              groupValue: selectedAnswers[index],
              title: Text(mcqQuestions[index]['options'][optIndex]),
              onChanged: (value) {
                setState(() {
                  selectedAnswers[index] = value;
                });
              },
            );
          }),
        ],
      ),
    );
  }
}
