import 'dart:io';

import 'package:conf_moderator/models/hall.dart';
import 'package:flutter/widgets.dart';

class ConferenceProvider with ChangeNotifier {
  List<Hall> halls = [];
  String mainEndPoint = "";

  Future<void> getHalls() async {
    
  }

  Hall getHallbyID(String id) {
    return halls.firstWhere((hall) => hall.hallID == id);
  }

  Future<void> uploadFile(File file) async{


  }

}
