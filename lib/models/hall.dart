import 'package:conf_moderator/models/session.dart';

class Hall {
  String hallID;
  String hallName;
  List<Session> sessions;
  Hall({required this.hallID, required this.hallName, required this.sessions});
}
