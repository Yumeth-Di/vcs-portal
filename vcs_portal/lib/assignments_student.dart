import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';

class StudentLinkPage extends StatefulWidget {
  const StudentLinkPage({super.key});

  @override
  State<StudentLinkPage> createState() => _StudentLinkPageState();
}

class _StudentLinkPageState extends State<StudentLinkPage> {
  final _baseUrlCtrl = TextEditingController(text: 'http://192.168.1.6:5000');
  final TextEditingController _urlCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  String? _studentClass;
  String? _url;
  String? _status;
  bool _loading = false;

  Future<void> _lookup() async {
    final api = ApiService(_baseUrlCtrl.text.trim());
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter your name")));
      return;
    }
    setState(() {
      _loading = true;
      _status = null;
      _url = null;
      _studentClass = null;
    });
    try {
      final className = await api.getClassByStudentName(name);
      final cl = await api.getLinkForClass(className);
      setState(() {
        _studentClass = className;
        _url = cl.url.isEmpty ? null : cl.url;
        _status = cl.url.isEmpty
            ? "No link set for $className yet."
            : "Loaded link for $className";
      });
    } catch (e) {
      setState(() => _status = "Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _open() async {
    if (_url == null || _url!.isEmpty) return;
    final uri = Uri.tryParse(_url!);
    if (uri == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid URL")));
      return;
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Could not open link")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student • Class Link")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: "Your Name (as in DB)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loading ? null : _lookup,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.search),
              label: const Text("Find My Class Link"),
            ),
            const SizedBox(height: 16),
            if (_studentClass != null)
              ListTile(
                leading: const Icon(Icons.class_),
                title: Text("Class: $_studentClass"),
                subtitle: Text(_url == null || _url!.isEmpty
                    ? "No link available"
                    : _url!),
              ),
            if (_status != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_status!,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 16),
            if (_url != null && _url!.isNotEmpty)
              FilledButton.icon(
                onPressed: _open,
                icon: const Icon(Icons.open_in_new),
                label: const Text("Open Link"),
              ),
          ],
        ),
      ),
    );
  }
}
