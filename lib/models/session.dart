import 'package:conf_moderator/models/speaker.dart';

// class Session {
//   String sessionID;
//   String sessionName;
//   List<Speaker> speakers;
//   String sessionDate;
//   Session({required this.sessionID, required this.sessionName, required this.sessionDate, required this.speakers});
// }
import 'dart:convert';

class Session {
  Session({
    required this.id,
    required this.name,
    required this.date,
    required this.hallId,
    required this.speakers,
    required this.path
  });

  int id;
  String name;
  String date; //
  int hallId;
  List<Speaker> speakers;
  String path;

  factory Session.fromRawJson(String str) => Session.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        name: json["name"],
        date: json["date"],
        hallId: json["hall_id"],
        id: json["id"],
        path:json["path"],
        speakers: List<Speaker>.from(
            json["speakers"].map((x) => Speaker.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "hall_id": hallId,
        "id": id,
        "speakers": List<Speaker>.from(speakers.map((x) => x)),
        "path": path,
      };
}
