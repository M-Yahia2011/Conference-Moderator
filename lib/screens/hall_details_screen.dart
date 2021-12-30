import 'package:flutter/material.dart';
import '/helpers/colors.dart';
import '/models/session.dart';
import '/models/hall.dart';
import '/providers/conf_provider.dart';
import '/screens/session_details_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class HallDetailsScreen extends StatefulWidget {
  static const routeName = "/hallDetailsScreen";

  const HallDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HallDetailsScreen> createState() => _HallDetailsScreenState();
}

class _HallDetailsScreenState extends State<HallDetailsScreen> {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  DateTime? _pickedDate;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> addSession(int hallID, Map<String, dynamic> sessionInfo) async {
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

  Future<void> deleteSession(Session session) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ConferenceProvider>(context, listen: false)
          .deleteSession(session);
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

  Future<bool> deleteAlert(BuildContext ctx) async {
    return await showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              'Attention',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ))
            ],
            content: const Text(
              "Are you sure you want to delete?",
              style: TextStyle(fontSize: 16),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Hall hall = ModalRoute.of(context)?.settings.arguments as Hall;
    return Scaffold(
      appBar: AppBar(
        title: Text(hall.name),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isLoading,
          color: Colors.transparent,
          child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 600,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textEditingController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Session Name",
                          labelStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          border: InputBorder.none),
                      onSubmitted: (_) async {
                        if (_pickedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: MyColors.colors[200],
                              content: const Text("You must pick a Date!")));
                        } else if (_textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: MyColors.colors[200],
                              content: const Text(
                                  "You must enter the session Name!")));
                        } else {
                          Map<String, dynamic> sessionInfo = {
                            "name": _textEditingController.text.trim(),
                            "hall_id": hall.id,
                            "date": intl.DateFormat.yMMMEd()
                                .format(_pickedDate!)
                                .toString()
                          };

                          await addSession(hall.id, sessionInfo);
                          _textEditingController.clear();
                        }
                      },
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
                          if (_pickedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: MyColors.colors[200],
                                content: const Text("You must pick a Date!")));
                          } else if (_textEditingController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: MyColors.colors[200],
                                content: const Text(
                                    "You must enter the session Name!")));
                          } else {
                            Map<String, dynamic> sessionInfo = {
                              "name": _textEditingController.text.trim(),
                              "hall_id": hall.id,
                              "date": intl.DateFormat.yMMMEd()
                                  .format(_pickedDate!)
                                  .toString()
                            };

                            await addSession(hall.id, sessionInfo);
                            _textEditingController.clear();
                          }
                        },
                        child: const Text(
                          "Add a new session",
                          style: TextStyle(fontSize: 25),
                        )),
                  ),
                  if (hall.sessions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Text(
                          "No sessions were added",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  if (hall.sessions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: hall.sessions.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1.5 / 2,
                        ),
                        itemBuilder: (context, idx) {
                          return Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Card(
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            hall.sessions[idx].name,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              hall.sessions[idx].date,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                        await deleteSession(hall.sessions[idx]);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ),
                            ],
                          );
                        },
                      ),
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
                .downloadHallFiles(hall.id);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: MyColors.colors[200],
                content: const Text("Erorr on downloading")));
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
