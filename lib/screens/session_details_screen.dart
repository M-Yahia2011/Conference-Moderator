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
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  late TextEditingController _textEditingControllerName;
  late TextEditingController _textEditingControllerSubject;
  bool _isloading = false;
  bool isUploaded = false;

  Future<void> addSpeaker(
      int sessionID, Map<String, dynamic> speakerInfo) async {
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
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingControllerName = TextEditingController();
    _textEditingControllerSubject = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerSubject.dispose();
    super.dispose();
  }

  Future<void> uploadFile(int speakerID) async {
    try {
      FilePickerResult? pickedFile =
          await FilePicker.platform.pickFiles(allowMultiple: false);

      if (pickedFile != null) {
        setState(() {
          _isloading = true;
        });

        isUploaded =
            await Provider.of<ConferenceProvider>(context, listen: false)
                .uploadFile(pickedFile.files.first, speakerID);
        setState(() {
          _isloading = false;
        });
        if (isUploaded == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("The file has been uploaded!")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No file was picked!")));
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Session session =
        ModalRoute.of(context)!.settings.arguments as Session;

    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isloading,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SingleChildScrollView(
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
                      controller: _textEditingControllerName,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Speaker's Name",
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 600,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textEditingControllerSubject,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Subject",
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
                                  context: context,
                                  initialTime: TimeOfDay.now());
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
                                  context: context,
                                  initialTime: TimeOfDay.now());
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
                            if (_textEditingControllerName.text.isEmpty ||
                                _textEditingControllerSubject.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "You must enter the speaker's name and subject!")));
                            } else if (startTime == null || endTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("You must pick the time!")));
                            } else {
                              Map<String, dynamic> speakerInfo = {
                                "name": _textEditingControllerName.text,
                                "subject": _textEditingControllerSubject.text,
                                "start_time": startTime!.format(context),
                                "end_time": endTime!.format(context),
                                "file": "",
                                "session_id": session.id
                              };
                              await addSpeaker(session.id, speakerInfo);

                              _textEditingControllerName.clear();
                              _textEditingControllerSubject.clear();
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
                  ScrollConfiguration(
                    // height: MediaQuery.of(context).size.height * 0.7,
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: session.speakers.length,
                        itemBuilder: (context, idx) {
                          final speakers = session.speakers;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(speakers[idx].name),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(speakers[idx].subject),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 400),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                            "From: ${speakers[idx].startTime}"),
                                        Text("To: ${speakers[idx].endTime}"),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  if (speakers[idx].file.isEmpty)
                                    SizedBox(
                                      height: 40,
                                      width: 500,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await uploadFile(speakers[idx].id);
                                          setState(() {
                                            speakers[idx].file =
                                                "there is a file";
                                          });
                                        },
                                        child: const Text("Upload File",
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                    ),
                                  const SizedBox(height: 15),
                                  if (speakers[idx].file.isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 200,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                await Provider.of<
                                                            ConferenceProvider>(
                                                        context,
                                                        listen: false)
                                                    .downloadFile(
                                                        speakers[idx].id);
                                              } catch (e) {
                                                rethrow;
                                              }
                                            },
                                            child: const Text(
                                              "Download File",
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 200,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                await Provider.of<
                                                            ConferenceProvider>(
                                                        context,
                                                        listen: false)
                                                    .deleteFile(speakers[idx]);
                                                setState(() {
                                                  speakers[idx].file = "";
                                                });
                                              } catch (e) {
                                                rethrow;
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red),
                                            child: const Text("Remove File",
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                        ),
                                      ],
                                    ),
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
        ),
      ),
    );
  }
}
