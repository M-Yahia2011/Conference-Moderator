import 'dart:html';

class Speaker {
  String speakerID;
  String speakerName;
  String subjectName;
  String startTime;
  String endTime;
  String filePath;
  Speaker(
      {required this.speakerID,
      required this.speakerName,
      required this.subjectName,
      required this.startTime,
      required this.endTime,
      required this.filePath});
}
