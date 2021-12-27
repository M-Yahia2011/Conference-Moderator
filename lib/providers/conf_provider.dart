import 'dart:html' as html;
import '/models/hall.dart';
import '/models/session.dart';
import '/models/speaker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';


class ConferenceProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Hall> _halls = [];
  List<Speaker> _speakers = [];
  final Dio _dio = Dio();
  static const String _mainEndPoint = "http://127.0.0.1:8000";
  final String _hallsEndpoint = "$_mainEndPoint/halls/";
  final String _sessionEndpoint = "$_mainEndPoint/sessions/";
  final String _speakerEndpoint = "$_mainEndPoint/speakers/";

  // Future<void> getHalls() async {}

  List<Hall> get allHalls {
    return [..._halls];
  }

  List<Speaker> get allSpeakers {
    return [..._speakers];
  }

  Hall getHallbyID(int id) {
    return _halls.firstWhere((hall) => hall.id == id);
  }

  List<Session> getSessions(int hallID) {
    final Hall hall = getHallbyID(hallID);
    return hall.sessions;
  }

  Future<Speaker?> getSpeakerById(int id) async {
    try {
      Response response = await _dio.get("$_speakerEndpoint$id");
      final Speaker speaker = Speaker.fromJson(response.data);
      return speaker;
    } catch (e) {
      return null;
    }
  }

  Future<void> getAllHalls() async {
    try {
      final response = await _dio.get(
        _hallsEndpoint,
      );

      if (response.statusCode! >= 200) {
        List<Hall> fetchedHalls = [];
        for (var hall in response.data) {
          Hall newHall = Hall.fromJson(hall as Map<String, dynamic>);

          fetchedHalls.add(newHall);
        }
        _halls = fetchedHalls;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }
  Future<void> getSuggestions() async {
    try {
      final response = await _dio.get(
        _speakerEndpoint,
      );

      if (response.statusCode! >= 200) {
        List<Speaker> fetchedSpeakers = [];
        for (var speaker in response.data) {
          Speaker newSpeaker =
              Speaker.fromJson(speaker as Map<String, dynamic>);

          fetchedSpeakers.add(newSpeaker);
        }
        _speakers = fetchedSpeakers;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }
  Future<void> getAllSpeakers() async {
    try {
      final response = await _dio.get(
        _speakerEndpoint,
      );

      if (response.statusCode! >= 200) {
        List<Speaker> fetchedSpeakers = [];
        for (var speaker in response.data) {
          Speaker newSpeaker =
              Speaker.fromJson(speaker as Map<String, dynamic>);

          fetchedSpeakers.add(newSpeaker);
        }
        _speakers = fetchedSpeakers;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  // all of this get logic should be done on server-side
  // here you'll need just the sessionID for that endpoint

  Session? getSessionbyID(int sessionID) {
    for (var hall in _halls) {
      for (var session in hall.sessions) {
        if (session.id == sessionID) {
          return session;
        }
      }
    }
  }

  void removeSessionLocally(int sessionID) {}

  int getHallIdx(int hallID) {
    int i = 0;
    for (i; i < _halls.length; i++) {
      if (hallID == _halls[i].id) {
        return i;
      }
    }
    return -1;
  }

  Speaker getLocalSpeakerbyID(int speakerID, int sessionID) {
    Session? session = getSessionbyID(sessionID);
    return session!.speakers.firstWhere((speaker) => speakerID == speaker.id);
  }

  Future<void> addHall(Map<String, dynamic> hallInfo) async {
    try {
      Response response = await _dio.post(_hallsEndpoint,
          data: hallInfo, options: Options(contentType: "application/json"));
      if (response.statusCode! >= 200) {
        var newHall = Hall.fromJson(response.data);
        _halls.add(newHall);
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addSession(int hallID, Map<String, dynamic> sessionInfo) async {
    try {
      Response response = await _dio.post(_sessionEndpoint,
          data: sessionInfo, options: Options(contentType: "application/json"));
      if (response.statusCode! >= 200) {
        print(response.data);
        var newSession = Session.fromJson(response.data);
        var hall = getHallbyID(hallID);
        hall.sessions.add(newSession);
        notifyListeners();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addSpeaker(
      int sessionID, Map<String, dynamic> speakerInfo) async {
    try {
      Response response = await _dio.post(_speakerEndpoint,
          data: speakerInfo, options: Options(contentType: "application/json"));
      if (response.statusCode! >= 200) {
        var newSpeaker = Speaker.fromJson(response.data);

        var session = getSessionbyID(sessionID);
        session!.speakers.add(newSpeaker);
        _speakers.add(newSpeaker);
        notifyListeners();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // this will be used as a seperate functionality
  // it will run when the guest hand over the flash drive
  Future<bool> uploadFile(PlatformFile file, int speakerID) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(file.bytes as List<int>,
            filename: file.name)
      });
      String uploadEndpoint = "/speaker/upload-file/?speaker_id=$speakerID";
      Response response =
          await _dio.post("$_mainEndPoint$uploadEndpoint", data: formData);
      if (response.statusCode! >= 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);

      return false;
    }
  }

  Future<void> downloadFile(int speakerID) async {
    try {
      String url =
          "http://127.0.0.1:8000/speaker/downlod-file/?spaker_id=$speakerID";
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = url;
      anchorElement.click();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFile(Speaker speaker) async {
    try {
      await _dio.delete(
          "http://127.0.0.1:8000/speaker/delete-file?speaker_id=${speaker.id}");
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteHall(int hallID) async {
    try {
      Response response = await _dio.delete("$_hallsEndpoint$hallID");
      if (response.statusCode! >= 200) {
        _halls.removeWhere((hall) => hall.id == hallID);
        await getAllSpeakers();
        notifyListeners();
        print("deleted");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteSession(int sessionID) async {
    try {
      Response response = await _dio.delete("$_sessionEndpoint$sessionID");
      if (response.statusCode! >= 200) {
        // removeSessionLocally(sessionID);
        int i = 0;
        for (var hall in _halls) {
          for (i; i < hall.sessions.length; i++) {
            if (hall.sessions[i].id == sessionID) {
              hall.sessions.remove(hall.sessions[i]);
              await getAllSpeakers();
              break;
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteSpeaker(int speakerID) async {
    getAllSpeakers();
  }

  Future<void> deleteAllHalls() async {
    _halls.clear();
    notifyListeners();
  }
}
