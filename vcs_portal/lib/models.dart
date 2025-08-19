class Announcement {
  final int id;
  final String title;
  final String message;
  final String className;
  final String teacherName;
  final DateTime createdAt;
  bool isNew;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.className,
    required this.teacherName,
    required this.createdAt,
    required this.isNew,
  });

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
        id: j['id'],
        title: j['title'],
        message: j['message'],
        className: j['class_name'],
        teacherName: j['teacher_name'] ?? "Unknown",
        createdAt: DateTime.parse(j['created_at']),
        isNew: j['is_new'] == 1,
      );
}

class AssignmentModel {
  final int id;
  final String title;
  final String link;
  final String className;
  final String subject;
  final String? createdAt;
  AssignmentModel(
      {required this.id,
      required this.title,
      required this.link,
      required this.className,
      required this.subject,
      this.createdAt});
  factory AssignmentModel.fromJson(Map<String, dynamic> j) => AssignmentModel(
        id: j['id'],
        title: j['title'],
        link: j['link'],
        className: j['class_name'],
        subject: j['subject'],
        createdAt: j['created_at'],
      );
}

class StatsModel {
  final int assignmentId;
  final int totalStudents;
  final int submitted;
  StatsModel(
      {required this.assignmentId,
      required this.totalStudents,
      required this.submitted});
  factory StatsModel.fromJson(Map<String, dynamic> j) => StatsModel(
      assignmentId: j['assignment_id'],
      totalStudents: j['total_students'],
      submitted: j['submitted']);
}
