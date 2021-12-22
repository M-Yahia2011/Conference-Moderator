import 'package:conf_moderator/models/speaker.dart';

class Session {
  String sessionID;
  String sessionName;
  List<Speaker> speakers;
  String sessionDate;
  Session({required this.sessionID, required this.sessionName, required this.sessionDate, required this.speakers});
}
