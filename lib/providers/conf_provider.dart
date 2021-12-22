import 'package:conf_moderator/models/hall.dart';
import 'package:flutter/widgets.dart';

class ConferenceProvider with ChangeNotifier {
  List halls = [];
  String mainEndPoint = "";

  Future<List> getHalls() async {
    return Future.value();
  }
  
}
