import '/helpers/colors.dart';
import '/models/hall.dart';
import '/providers/conf_provider.dart';
import '/screens/hall_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class ConferenceScreen extends StatefulWidget {
  static const routeName = "/Conference_halls";

  const ConferenceScreen({Key? key}) : super(key: key);

  @override
  State<ConferenceScreen> createState() => _AddConferenceScreenState();
}

class _AddConferenceScreenState extends State<ConferenceScreen> {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  bool _isLoading = false;

  Future<void> addHall(Map<String, dynamic> hallInfo) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ConferenceProvider>(context, listen: false)
          .addHall(hallInfo);
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
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conference Manager"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await Provider.of<ConferenceProvider>(context, listen: false)
                    .deleteSharedPreferences();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.exit_to_app_rounded))
        ],
      ),
      backgroundColor: Colors.grey[100],
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
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textEditingController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Hall Name",
                          labelStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          border: InputBorder.none),
                      onSubmitted: (_) async {
                        if (_textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: MyColors.colors[200],
                              content:
                                  const Text("You must enter the hall name!")));
                        } else {
                          Map<String, dynamic> hallInfo = {
                            "name": _textEditingController.text.trim(),
                          };

                          await addHall(hallInfo);
                          _textEditingController.clear();
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 40,
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: MyColors.colors[200],
                              content:
                                  const Text("You must enter the hall name!")));
                        } else {
                          Map<String, dynamic> hallInfo = {
                            "name": _textEditingController.text.trim(),
                          };

                          await addHall(hallInfo);
                          _textEditingController.clear();
                        }
                      },
                      child: const Text(
                        "Add a new Hall",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Consumer<ConferenceProvider>(
                    builder: (ctx, conferenceProvider, _) => Container(
                      margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
                      child: conferenceProvider.allHalls.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(50),
                                child: Text(
                                  "No halls were added",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            )
                          : GridView.builder(
                              controller: _scrollController,
                              itemCount: conferenceProvider.allHalls.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 1000
                                        ? 7
                                        : 4,
                                childAspectRatio: 1.5 / 2,
                              ),
                              itemBuilder: (context, idx) {
                                return HallCard(
                                    hall: conferenceProvider.allHalls[idx]);
                              },
                            ),
                    ),
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

class HallCard extends StatelessWidget {
  final Hall hall;
  const HallCard({
    Key? key,
    required this.hall,
  }) : super(key: key);

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
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(HallDetailsScreen.routeName, arguments: hall);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: FittedBox(
                  child: Text(
                    hall.name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
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
                bool deleteAction = await deleteAlert(context);
                if (deleteAction == true) {
                  await Provider.of<ConferenceProvider>(context, listen: false)
                      .deleteHall(hall.id);
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ),
      ],
    );
  }
}
