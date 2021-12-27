import 'package:conf_moderator/models/session.dart';

// class Hall {
//   String hallID;
//   String hallName;
//   List<Session> sessions;
//   Hall({required this.hallID, required this.hallName, required this.sessions});
// }

import 'dart:convert';

class Hall {
  Hall(
      {required this.id,
      required this.name,
      required this.sessions,
      required this.path});

  int id;
  String name;
  List<Session> sessions;
  String path;

  factory Hall.fromRawJson(String str) => Hall.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      id: json["id"],
      name: json["name"],
      sessions:
          List<Session>.from(json["sessions"].map((x) => Session.fromJson(x))),
      path: json["path"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sessions": List<Session>.from(sessions.map((x) => x)),
        "path": path
      };
}
