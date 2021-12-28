// class Speaker {
//   String speakerID;
//   String speakerName;
//   String subjectName;
//   String startTime;
//   String endTime;
//   List<String> filePath;
//   Speaker(
//       {required this.speakerID,
//       required this.speakerName,
//       required this.subjectName,
//       required this.startTime,
//       required this.endTime,
//       required this.filePath});
// }


import 'dart:convert';

class Speaker {
    Speaker({
        required this.id,
        required this.name,
        required this.subject,
        required this.startTime,
        required this.endTime,
        required this.file,
        required this.sessionId,
        required this.path,
    });

    int id;
    String name;
    String subject;
    String startTime;
    String endTime;
    int sessionId;
    String file;
    String path;

    factory Speaker.fromRawJson(String str) => Speaker.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Speaker.fromJson(Map<String, dynamic> json) => Speaker(
        id: json["id"],
        name: json["name"],
        subject: json["subject"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        file: json["file"] ?? "",
        sessionId: json["session_id"],
        path: json["path"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subject": subject,
        "start_time": startTime,
        "end_time": endTime,
        "file": file,
        "session_id": sessionId,
        "path": path,
    };
}
