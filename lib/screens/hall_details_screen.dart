import 'package:conf_moderator/models/hall.dart';
import 'package:conf_moderator/providers/conf_provider.dart';
import 'package:conf_moderator/screens/session_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import 'add_session_screen.dart';

class HallDetailsScreen extends StatefulWidget {
  static const routeName = "/hallDetailsScreen";

  const HallDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HallDetailsScreen> createState() => _HallDetailsScreenState();
}

class _HallDetailsScreenState extends State<HallDetailsScreen> {
  late TextEditingController _textEditingController;
  DateTime? _pickedDate;
  bool _isLoading = false;
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

  Future<void> addSession(
      String hallID, Map<String, dynamic> sessionInfo) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ConferenceProvider>(context, listen: false)
          .addSession(hallID, sessionInfo);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Hall hall = ModalRoute.of(context)?.settings.arguments as Hall;
    return Scaffold(
      appBar: AppBar(
        title: Text(hall.hallName),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        labelText: "Session Name",
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050));
                      setState(() {
                        _pickedDate = picked;
                      });
                    },
                    child: Text(
                        _pickedDate != null
                            ? intl.DateFormat.yMMMEd().format(_pickedDate!)
                            : "Pick a Date",
                        style: const TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  width: 400,
                  height: 40,
                  margin: const EdgeInsets.all(15),
                  child: ElevatedButton(
                      onPressed: () async {
                        // Navigator.of(context)
                        //     .pushNamed(AddSessionScreen.routeName);
                        if (_pickedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("You must pick a Date!")));
                        } else if (_textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "You must enter the session Name!")));
                        } else {
                          Map<String, dynamic> sessionInfo = {
                            "sessionName": _textEditingController.text,
                            "speakers": [],
                            "sessionDate": intl.DateFormat.yMMMEd()
                                .format(_pickedDate!)
                                .toString()
                          };

                          await addSession(hall.hallID, sessionInfo);
                          _textEditingController.clear();
                        }
                      },
                      child: const Text(
                        "Add a new session",
                        style: TextStyle(fontSize: 25),
                      )),
                ),
                Expanded(
                  child: GridView.builder(
                    // controller: _scrollController,
                    itemCount: hall.sessions.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.5 / 2,
                    ),
                    itemBuilder: (context, idx) {
                      return Card(
                        margin: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                SessionDetailsScreen.routeName,
                                arguments: hall.sessions[idx]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  hall.sessions[idx].sessionName,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                              
                              FittedBox(
                                child: Text(
                                  hall.sessions[idx].sessionDate,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
