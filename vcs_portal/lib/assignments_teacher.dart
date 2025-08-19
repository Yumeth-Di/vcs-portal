import 'package:flutter/material.dart';
import 'api_service.dart';

class TeacherLinkPage extends StatefulWidget {
  const TeacherLinkPage({super.key});

  @override
  State<TeacherLinkPage> createState() => _TeacherLinkPageState();
}

class _TeacherLinkPageState extends State<TeacherLinkPage> {
  final _baseUrlCtrl = TextEditingController(text: 'http://192.168.1.6:5000');
  final TextEditingController _urlCtrl = TextEditingController();
  String? _selectedClass;
  List<String> _classes = [];
  bool _loadingClasses = true;
  bool _saving = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final api = ApiService(_baseUrlCtrl.text.trim());
    try {
      final classes = await api.fetchClasses();
      setState(() {
        _classes = classes;
        _selectedClass = classes.isNotEmpty ? classes.first : null;
      });
      if (_selectedClass != null) {
        await _loadCurrentLink();
      }
    } catch (e) {
      setState(() => _status = "Failed to load classes: $e");
    } finally {
      setState(() => _loadingClasses = false);
    }
  }

  Future<void> _loadCurrentLink() async {
    final api = ApiService(_baseUrlCtrl.text.trim());
    if (_selectedClass == null) return;
    setState(() => _status = null);
    try {
      final cl = await api.getLinkForClass(_selectedClass!);
      _urlCtrl.text = cl.url;
      setState(() => _status = cl.updatedAt == null
          ? "No link set yet"
          : "Last updated: ${cl.updatedAt}");
    } catch (e) {
      setState(() => _status = "Failed to load link: $e");
    }
  }

  Future<void> _save() async {
    final api = ApiService(_baseUrlCtrl.text.trim());
    final url = _urlCtrl.text.trim();
    if (_selectedClass == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select class and enter URL")));
      return;
    }
    setState(() => _saving = true);
    try {
      await api.saveLinkForClass(_selectedClass!, url);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Saved")));
      await _loadCurrentLink();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher • Class Link")),
      body: _loadingClasses
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _classes.isEmpty
                  ? const Center(
                      child: Text("No classes found in student table"))
                  : ListView(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedClass,
                          items: _classes
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) async {
                            setState(() => _selectedClass = v);
                            await _loadCurrentLink();
                          },
                          decoration: const InputDecoration(
                              labelText: "Class", border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _urlCtrl,
                          decoration: const InputDecoration(
                            labelText: "Class Link (URL)",
                            hintText: "https://example.com/my-class-page",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 8),
                        if (_status != null)
                          Text(_status!,
                              style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.save),
                          label: const Text("Save Link"),
                        ),
                      ],
                    ),
            ),
    );
  }
}
