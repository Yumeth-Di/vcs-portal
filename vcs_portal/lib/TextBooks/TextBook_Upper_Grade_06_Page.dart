import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SixTextBookPage(),
    );
  }
}

class SixTextBookPage extends StatelessWidget {
  final List<String> subjects = [
    "Mathematics I",
    "Mathematics II",
    "Geography",
    "Science",
    "Civics",
    "Sinhala",
    "Health",
    "ICT",
    "ICT WorkBook",
    "Chinese",
    "Buddhism",
    "Catholic",
    "Music",
    "English",
    "Art",
    "Tamil",
    "Dancing",
    "History",
    "G.K",
  ];

  // Map each subject to a unique link
  final Map<String, String> subjectLinks = {
    "Mathematics I": "http://www.edupub.gov.lk/Administrator/English/6/maths%20G-6%20P-I%20E/maths%20G-6%20E%20P-I.pdf",
    "Mathematics II": "http://www.edupub.gov.lk/Administrator/English/6/maths%20G-6%20P-II%20E/maths%20G-6%20P-II%20E.pdf",
    "Geography": "http://www.edupub.gov.lk/Administrator/English/6/geo%20G-6%20E/geo%20G-6%20E.pdf",
    "Science": "http://www.edupub.gov.lk/Administrator/English/6/science%20G-6%20%20E/science%20G-6%20E.pdf",
    "Civics": "http://www.edupub.gov.lk/Administrator/English/6/civicG-6%20E/CIVIC%20education%20G-6%20final%202019.pdf",
    "Sinhala": "http://www.edupub.gov.lk/Administrator/Sinhala/6/sinhala%20lan%20g-6/sinhala%20lan%20G-6.pdf",
    "Health": "http://www.edupub.gov.lk/Administrator/English/6/health%20G-6%20E/health%20G-6%20E.pdf",
    "ICT": "http://www.edupub.gov.lk/Administrator/English/6/ICT%20G-6%20E%20PB/ICT%20G-6%20E%20PB.pdf",
    "ICT WorkBook": "http://www.edupub.gov.lk/Administrator/English/6/ICT%20WB%20E%20G-6/ICT%20WB%20G-6%20E.pdf",
    "Chinese": "https://docs.google.com/document/d/1ueJmP2qa0u2KYpLwVtV6z-mz8eMOCeTfzPBgYTLiM_A/edit?tab=t.0",
    "Buddhism": "https://docs.google.com/document/d/1yqh2Lp_p_9CWaTQfw0XzeMCHdMd39S6z0u6-nVX-ic4/edit?tab=t.0",
    "Catholic": "http://www.edupub.gov.lk/Administrator/English/6/Catholicism%20G-6%20E/cato%20G-6-min.pdf",
    "Music": "https://docs.google.com/document/d/15as6nzrjNBfDGt_wilevPBf0ESjsq27HmPBBx6wc4uA/edit?tab=t.0",
    "English": "http://www.edupub.gov.lk/Administrator/English/6/english%20PB%20G-6/english%20PB%20G-6.pdf",
    "Art": "https://docs.google.com/document/d/1THrSLtmywV6DGizrlUQx_u-bLGyXJ3IY0Up4dTxnn6M/edit?tab=t.0",
    "Tamil": "http://www.edupub.gov.lk/Administrator/Tamil/6/tamil%20G-6/Tamil%20lang%20&%20lit%20G6%20(T).pdf",
    "Dancing": "https://docs.google.com/document/d/1ofmXrwVYW_qH7JOQzAte1zCvfOtJzr5Zo2UpfvEVE9Q/edit?tab=t.0",
    "History": "http://www.edupub.gov.lk/Administrator/English/6/history%20G-6%20E/History%20G6%20(E).pdf",
    "G.K": "https://docs.google.com/document/d/1IT-rcrLTRSP7nRbrleCmJzyhSsn86fp3uOj_rxqLFYk/edit?tab=t.0",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vc_drone_view.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top bar
                Container(
                  color: const Color.fromARGB(255, 0, 6, 73),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/VC_icon.png'),
                            radius: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "VCS Portal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/images/profile_icon.png',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ),

                // Buttons row
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 6, 73),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Image.asset(
                          'assets/images/textbooks.png',
                          height: 35,
                          width: 35,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 6, 73),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: const Text(
                          "Upper Section",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 6, 73),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: const Text(
                          "Gr.06",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable subjects
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: subjects.map((subject) {
                            return _subjectButton(subject);
                          }).toList(),
                        ),
                      ),
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

  Widget _subjectButton(String subject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () async {
          final url = subjectLinks[subject];
          if (url != null && await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              subject,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
