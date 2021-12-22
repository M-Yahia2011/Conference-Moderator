import 'dart:io';

import 'package:conf_moderator/models/hall.dart';
import 'package:conf_moderator/models/session.dart';
import 'package:conf_moderator/models/speaker.dart';
import 'package:flutter/widgets.dart';

class ConferenceProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Hall> _halls = [
    Hall(hallID: "1", hallName: "Hall 101", sessions: [
      Session(
          sessionID: "1",
          sessionName: "anything",
          sessionDate: "11/11/2011",
          speakers: [
            Speaker(
              speakerID: "100",
              speakerName: "Dr. Jack",
              startTime: "13:00 PM",
              endTime: "15:00 PM",
              filePath: "some path",
            )
          ])
    ]),
    Hall(hallID: "10", hallName: "Hall 505", sessions: [
      Session(
          sessionID: "11321",
          sessionName: "anything 2123232",
          sessionDate: "15/11/2011",
          speakers: [
            Speaker(
              speakerID: "13256",
              speakerName: "Dr. Emerson",
              startTime: "13:00 PM",
              endTime: "15:00 PM",
              filePath: "some path",
            )
          ])
    ]),
    Hall(hallID: "78", hallName: "Hall 801", sessions: [
      Session(
          sessionID: "65",
          sessionName: "anything 56435454",
          sessionDate: "22/11/2022",
          speakers: [
            Speaker(
              speakerID: "236483",
              speakerName: "Dr. Sam",
              startTime: "13:00 PM",
              endTime: "15:00 PM",
              filePath: "some path",
            )
          ])
    ]),
  ];
  String mainEndPoint = "";

  Future<void> getHalls() async {}
  List<Hall> get halls {
    return [..._halls];
  }

  Hall getHallbyID(String id) {
    return halls.firstWhere((hall) => hall.hallID == id);
  }

  List<Session> getSessions(String hallID) {
    final Hall hall = getHallbyID(hallID);
    return hall.sessions;
  }
  // List<Speaker> getSpeakers(String sessionID){
  //   final
  // }
  Future<void> addHall(Map hallInfo) async {}

  Future<void> addSession(String hallID) async {}

  Future<void> addSpeaker(String sessionID) async {}

  Future<void> uploadFile(File file) async {}
}
