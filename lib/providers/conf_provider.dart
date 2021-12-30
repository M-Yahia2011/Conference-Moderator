// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';

import '/models/speaker_suggestion.dart';
import '/models/hall.dart';
import '/models/session.dart';
import '/models/speaker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

class ConferenceProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Hall> _halls = [];
  List<SpeakerSuggestion> _speakersSuggesions = [];

  final Dio _dio = Dio();
  String _mainEndPoint = "";
  String _hallsEndpoint = "";
  String _sessionEndpoint = "";
  String _speakerEndpoint = "";
  String _getsuggestionsEndpoint = "";
  bool isStoredEndpointChecked = false;
  void setIP(String ipInput, String portInput) async {
    String ip = ipInput.trim();
    String port = portInput.trim();

    _mainEndPoint = "http://" + ip + ":" + port;
    updateEndpoints();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("mainEndpoint", _mainEndPoint);
  }

  void updateEndpoints() {
    _hallsEndpoint = "$_mainEndPoint/halls/";
    _sessionEndpoint = "$_mainEndPoint/sessions/";
    _speakerEndpoint = "$_mainEndPoint/speakers/";
    _getsuggestionsEndpoint = "$_mainEndPoint/speakers-search/";
  }

  bool isEndpointSetted() {
    if (_mainEndPoint.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkStoredMainpoint() async {
    final preferences = await SharedPreferences.getInstance();
    final String? stored = preferences.get("mainEndpoint") as String?;
    if (stored == null) {
      return false;
    }
    if (stored.isEmpty) {
      return false;
    } else {
      _mainEndPoint = stored;
      updateEndpoints();
      notifyListeners();
      return true;
    }
  }

  Future<void> deleteSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("mainEndpoint", "");
    _mainEndPoint = "";
    updateEndpoints();
    notifyListeners();
  }

  List<Hall> get allHalls {
    return [..._halls];
  }

  List<SpeakerSuggestion> get searchSuggestions {
    return [..._speakersSuggesions];
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

  ///
  // Future<WebSocketChannel> initiateChannel() async {
  //   final channel =
  //       WebSocketChannel.connect(Uri.parse("wss://echo.websocket.org"));
  //   // _halls = channel.stream.first
  //   // notifyListeners();
  //   return channel;
  // }

  ///
  ///
  // Future<void> test() async {

  //   final channel =
  //       WebSocketChannel.connect(Uri.parse("http://localhost:8000/halls-websocket/"));

  //   print(channel.stream.first);
  // }

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
      rethrow;
    }
  }

  Future<void> getSuggestions() async {
    try {
      final response = await _dio.get(
        _getsuggestionsEndpoint,
      );

      if (response.statusCode! >= 200) {
        List<SpeakerSuggestion> fetchedSpeakers = [];
        for (var suggestion in response.data) {
          Speaker speaker = Speaker.fromJson(suggestion[0]);
          String sessionName = suggestion[1]["session_name"];
          String hallName = suggestion[2]["hall_name"];

          fetchedSpeakers.add(SpeakerSuggestion(
              speaker: speaker, sessionName: sessionName, hallName: hallName));
        }
        _speakersSuggesions = fetchedSpeakers;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Session? getSessionbyID(int sessionID) {
    for (var hall in _halls) {
      for (var session in hall.sessions) {
        if (session.id == sessionID) {
          return session;
        }
      }
    }
  }

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
        var newSession = Session.fromJson(response.data);
        var hall = getHallbyID(hallID);
        hall.sessions.add(newSession);
        notifyListeners();
      }
    } catch (e) {
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
        notifyListeners();
        await getSuggestions();
      }
    } catch (e) {
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
        await getSuggestions();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> downloadFile(int speakerID) async {
    try {
      String url = "$_mainEndPoint/speaker/downlod-file/?spaker_id=$speakerID";
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = url;
      anchorElement.click();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadHallFiles(int hallID) async {
    try {
      String url = "$_mainEndPoint/hall/downlod-folder/?hall_id=$hallID";
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = url;
      anchorElement.click();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadSessionFiles(int sessionID) async {
    try {
      String url =
          "$_mainEndPoint/session/downlod-folder/?session_id=$sessionID";
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = url;
      anchorElement.click();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile(Speaker speaker) async {
    try {
      await _dio.delete(
          "$_mainEndPoint/speaker/delete-file?speaker_id=${speaker.id}");
      final Speaker localSpeaker =
          getLocalSpeakerbyID(speaker.id, speaker.sessionId);
      localSpeaker.file = "";
      await getSuggestions();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteHall(int hallID) async {
    try {
      Response response = await _dio.delete("$_hallsEndpoint$hallID");
      if (response.statusCode! >= 200) {
        _halls.removeWhere((hall) => hall.id == hallID);
        notifyListeners();
        await getSuggestions();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSession(Session session) async {
    try {
      Response response = await _dio.delete("$_sessionEndpoint${session.id}");
      if (response.statusCode! >= 200) {
        final int hallIdx = getHallIdx(session.hallId);
        _halls[hallIdx].sessions.removeWhere((sess) => sess.id == session.id);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSpeaker(Speaker speaker) async {
    try {
      Response response = await _dio.delete("$_speakerEndpoint${speaker.id}");
      if (response.statusCode! >= 200) {
        final session = getSessionbyID(speaker.sessionId);
        session!.speakers
            .removeWhere((currentSpeaker) => currentSpeaker.id == speaker.id);
        notifyListeners();
        await getSuggestions();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllHalls() async {
    _halls.clear();
    notifyListeners();
  }
}
