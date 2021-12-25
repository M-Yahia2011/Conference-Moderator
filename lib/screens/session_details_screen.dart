import 'dart:io';
import 'dart:typed_data';

import 'package:conf_moderator/models/session.dart';
import 'package:conf_moderator/providers/conf_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class SessionDetailsScreen extends StatefulWidget {
  static const routeName = "/session_details";

  const SessionDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  bool _isloading = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  late TextEditingController _textEditingController;

  Future<void> addSpeaker(
      String sessionID, Map<String, dynamic> speakerInfo) async {
    try {
      setState(() {
        _isloading = true;
      });
      await Provider.of<ConferenceProvider>(context, listen: false)
          .addSpeaker(sessionID, speakerInfo);
      setState(() {
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> uploadFile(String speakerID) async {
    try {
      FilePickerResult? pickedFiles =
          await FilePicker.platform.pickFiles(allowMultiple: true);
      List<Map<String, dynamic>> files = [];
      if (pickedFiles != null) {
        for (PlatformFile file in pickedFiles.files) {
          files.add({"fileName": file.name, "file": file.bytes!});
        }
        setState(() {
          _isloading = true;
        });

        await Provider.of<ConferenceProvider>(context, listen: false)
            .uploadFile(files, speakerID);
        setState(() {
          _isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("The file has been uploaded!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No file was picked!")));
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Session session =
        ModalRoute.of(context)!.settings.arguments as Session;
    return Scaffold(
      appBar: AppBar(
        title: Text(session.sessionName),
      ),
      body: LoadingOverlay(
        isLoading: _isloading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
          child: Column(
            children: [
              Container(
                height: 60,
                width: 300,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      labelText: "Speaker's Name",
                      labelStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Text("From"),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          setState(() {
                            startTime = picked;
                          });
                        },
                        child: startTime != null
                            ? Text(startTime!.format(context))
                            : const Text(
                                "Time",
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("To"),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          setState(() {
                            endTime = picked;
                          });
                        },
                        child: endTime != null
                            ? Text(endTime!.format(context))
                            : const Text(
                                "Time",
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () async {
                        // Navigator.of(context).pushNamed(
                        //     AddSpeakerScreen.routeName,
                        //     arguments: "1");
                        if (_textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "You must enter the speaker's name!")));
                        } else if (startTime == null || endTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("You must pick the time!")));
                        } else {
                          Map<String, dynamic> speakerInfo = {
                            "speakerName": _textEditingController.text,
                            "startTime": startTime!.format(context),
                            "endTime": endTime!.format(context),
                            "filePath": ""
                          };
                          await addSpeaker(session.sessionID, speakerInfo);
                          _textEditingController.clear();
                        }
                      },
                      child: const Text("Add a new Speaker",
                          style: TextStyle(fontSize: 20)))),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: session.speakers.length,
                    itemBuilder: (context, idx) {
                      final speakers = session.speakers;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(speakers[idx].speakerName),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(speakers[idx].subjectName),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 200),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("From: ${speakers[idx].startTime}"),
                                    Text("To: ${speakers[idx].endTime}"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 40,
                                width: 200,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Open File",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.teal),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 200,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await uploadFile(
                                            speakers[idx].speakerID);
                                      },
                                      child: const Text("Upload File",
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 200,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      child: const Text("Remove File",
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
