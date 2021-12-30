import 'package:conf_moderator/helpers/colors.dart';
import 'package:conf_moderator/models/session.dart';
import 'package:conf_moderator/models/speaker.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: MyColors.colors[100],
              content: const Text("The file has been successfully uploaded!")));
        }
      } else {
        isUploaded = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.colors[200],
            content: const Text("No file was picked!")));
      }
    } catch (e) {
      setState(() {
        isUploaded = false;
        _isloading = false;
      });
      rethrow;
    }
  }

  Future<void> deleteSpeaker(Speaker speaker) async {
    try {
      setState(() {
        _isloading = true;
      });
      await Provider.of<ConferenceProvider>(context, listen: false)
          .deleteSpeaker(speaker);
      setState(() {
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.colors[200],
          content: const Text("Error: The speaker Couldn't be removed")));
      rethrow;
    }
  }

  Future<void> deleteFile(Speaker speaker) async {
    try {
      await Provider.of<ConferenceProvider>(context, listen: false)
          .deleteFile(speaker);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.colors[200],
          content: const Text("Error: The file Couldn't be removed")));
      rethrow;
    }
  }

  Future<bool> deleteAlert(BuildContext ctx) async {
    return await showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Attention'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 15),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 15),
                  ))
            ],
            content: const Text("Are you sure you want to delete?"),
          );
        });
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
          child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 400,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textEditingControllerName,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Speaker's Name",
                          labelStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 600,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textEditingControllerSubject,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Subject",
                          labelStyle: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                          border: InputBorder.none),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "From:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                                    "Select",
                                    style: TextStyle(fontSize: 20),
                                  ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "To:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                                    "Select",
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
                            if (_textEditingControllerName.text.isEmpty ||
                                _textEditingControllerSubject.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: MyColors.colors[200],
                                  content: const Text(
                                      "You must enter the speaker's name and subject!")));
                            } else if (startTime == null || endTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: MyColors.colors[200],
                                      content: const Text(
                                          "You must pick the time!")));
                            } else {
                              Map<String, dynamic> speakerInfo = {
                                "name": _textEditingControllerName.text.trim(),
                                "subject": _textEditingControllerSubject.text.trim(),
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
                  if (session.speakers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text(
                        "No Speakers were added",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  if (session.speakers.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: session.speakers.length,
                          itemBuilder: (context, idx) {
                            final speakers = session.speakers;
                            return Stack(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          speakers[idx].name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                              Text(
                                                  "To: ${speakers[idx].endTime}"),
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
                                                await uploadFile(
                                                    speakers[idx].id);
                                                if (isUploaded == true) {
                                                  setState(() {
                                                    speakers[idx].file =
                                                        "there is a file";
                                                  });
                                                } else {
                                                  setState(() {
                                                    speakers[idx].file = "";
                                                  });
                                                }
                                              },
                                              child: const Text("Upload File",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ),
                                          ),
                                        const SizedBox(height: 15),
                                        if (speakers[idx].file.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
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
                                                                speakers[idx]
                                                                    .id);
                                                      } catch (e) {
                                                        rethrow;
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Download File",
                                                      style: TextStyle(
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
                                                        bool deleteAction =
                                                            await deleteAlert(
                                                                context);
                                                        if (deleteAction ==
                                                            true) {
                                                          deleteFile(
                                                              speakers[idx]);
                                                          setState(() {
                                                            speakers[idx].file =
                                                                "";
                                                          });
                                                        }
                                                      } catch (e) {
                                                        rethrow;
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
                                                    child: const Text(
                                                        "Remove File",
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 20,
                                  top: 20,
                                  child: IconButton(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onPressed: () async {
                                        bool deleteAction =
                                            await deleteAlert(context);
                                        if (deleteAction == true) {
                                          await deleteSpeaker(speakers[idx]);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ),
                              ],
                            );
                          }),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await Provider.of<ConferenceProvider>(context, listen: false)
                .downloadSessionFiles(session.id);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: MyColors.colors[200],
                content: const Text("Erorr while downloading!")));
            rethrow;
          }
        },
        child: const Icon(
          Icons.download,
          color: Colors.white,
        ),
      ),
    );
  }
}
