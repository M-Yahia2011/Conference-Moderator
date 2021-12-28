import 'package:conf_moderator/models/speaker.dart';

class SpeakerSuggestion {
  Speaker speaker;
  String sessionName;
  String hallName;
  SpeakerSuggestion(
      {required this.speaker,
      required this.sessionName,
      required this.hallName});
}
