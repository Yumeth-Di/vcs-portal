import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _driveLink;
  String? _fileName;

  bool _isValidDriveLink(String link) {
    return link.startsWith("https://drive.google.com/");
  }

  String _extractFileName(String link) {
    try {
      final uri = Uri.parse(link);
      if (uri.queryParameters.containsKey('id')) {
        return "Drive File (${uri.queryParameters['id']})";
      }
      final segments = uri.pathSegments;
      return segments.isNotEmpty ? segments.last : "Google Drive File";
    } catch (e) {
      return "Google Drive File";
    }
  }

  Future<void> _openLinkInputDialog() async {
    final TextEditingController controller = TextEditingController();
    String? errorText;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Enter Google Drive link"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "https://drive.google.com/...",
                errorText: errorText,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final link = controller.text.trim();
                  if (!_isValidDriveLink(link)) {
                    setState(() {
                      errorText = "Please enter a valid Google Drive link.";
                    });
                  } else {
                    setState(() {
                      _driveLink = link;
                      _fileName = _extractFileName(link);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
      },
    );
    setState(() {}); // Refresh UI
  }

  Future<void> _openInBrowser() async {
    if (_driveLink != null) {
      final Uri driveUri = Uri.parse(_driveLink!);
      if (await canLaunchUrl(driveUri)) {
        await launchUrl(driveUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open link.")),
        );
      }
    }
  }

  Future<void> _sendViaGmail() async {
    if (_driveLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter a Google Drive link first.")),
      );
      return;
    }

    final gmailUrl = "mailto:?subject=My%20Drive%20File&body=$_driveLink";
    final Uri emailUri = Uri.parse(gmailUrl);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Gmail.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Upload Page",
            selectionColor: Colors.white,
          ),
          backgroundColor: Color.fromARGB(225, 0, 6, 73),
          centerTitle: true,
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _openLinkInputDialog,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Upload from Google Drive"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 15),
                if (_fileName != null)
                  GestureDetector(
                    onTap: _openInBrowser,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file,
                            color: Colors.blue),
                        title: Text(_fileName!),
                        subtitle: const Text("Google Drive"),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _driveLink = null;
                              _fileName = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _sendViaGmail,
                  icon: const Icon(Icons.email),
                  label: const Text("Send via Gmail"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
