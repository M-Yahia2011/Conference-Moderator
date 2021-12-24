import 'dart:io';

import 'package:conf_moderator/models/hall.dart';
import 'package:conf_moderator/models/session.dart';
import 'package:conf_moderator/models/speaker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class ConferenceProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Hall> _halls = [
    /*
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
  */
  ];
  Dio _dio = Dio();
  String _mainEndPoint = "";

  // Future<void> getHalls() async {}

  List<Hall> get allHalls {
    return [..._halls];
  }

  Hall getHallbyID(String id) {
    return _halls.firstWhere((hall) => hall.hallID == id);
  }

  List<Session> getSessions(String hallID) {
    final Hall hall = getHallbyID(hallID);
    return hall.sessions;
  }

  // all of this logic should be done on server-side
  // here you'll need just the sessionID for that endpoint
  Session getSessionbyID(String hallID, String sessionID) {
    // final dio = Dio();
    final sessions = getSessions(hallID);
    return sessions.firstWhere((session) => session.sessionID == sessionID);
  }

  List<Speaker> getSpeakers(String sessionID) {
    final session = getSessionbyID("1", sessionID);
    return session.speakers;
  }

  Future<void> addHall(Map<String, dynamic> hallInfo) async {
    try {
      // Response response = await _dio.post(_mainEndPoint, data: hallInfo);
      // if(response.statusCode! > 200){

      // Hall newHall = Hall.fromMap(response.data);
      // _halls.add(newHall);
      // }
      var hall = Hall(hallID: "50", hallName: hallInfo["hallName"], sessions: [
        Session(
            sessionID: "65",
            sessionName: "session Name",
            sessionDate: "22/1/2022",
            speakers: [
              Speaker(
                speakerID: "236483",
                speakerName: "Dr. Sam",
                startTime: "13:00 PM",
                endTime: "15:00 PM",
                filePath: "some path",
              )
            ])
      ]);
      _halls.add(hall);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addSession(String hallID, Map<String, dynamic> session) async {
    Hall hall = getHallbyID(hallID);
    hall.sessions.add(Session(
        sessionID: "105",
        sessionName: session["sessionName"],
        sessionDate: session["sessionDate"],
        speakers: []));
  }

  Future<void> addSpeaker(
      String sessionID, Map<String, String> speakerInfo) async {
    // after reciving the speakerid update the speakerInfo map then create the object and add it
    final session = getSessionbyID("1", sessionID);
    session.speakers.add(Speaker(
        speakerID: "1",
        speakerName: "Jack",
        startTime: "12:00 PM",
        endTime: "14:00 PM",
        filePath: ""));
  }

  // this will be used as a seperate functionality
  // it will run when the guest hand over the flash drive
  Future<void> uploadFile(File file, String speakerID) async {}
  Future<void> deleteHall(String hallID)async{}
  Future<void> deleteSession(String sessionID)async{}
  Future<void> deleteSpeaker(String speakerID)async{}
  Future<void> deleteAllHalls() async {
    _halls.clear();
    notifyListeners();
  }
}
