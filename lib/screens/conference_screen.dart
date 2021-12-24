import 'package:conf_moderator/providers/conf_provider.dart';
import 'package:conf_moderator/screens/add_hall_screen.dart';
import 'package:conf_moderator/screens/hall_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class ConferenceScreen extends StatefulWidget {
  static const routeName = "/add_conf";

  const ConferenceScreen({Key? key}) : super(key: key);

  @override
  State<ConferenceScreen> createState() => _AddConferenceScreenState();
}

class _AddConferenceScreenState extends State<ConferenceScreen> {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  bool _isLoading = false;
  bool _isAdded = false;
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

  Future<void> addHall(Map<String, dynamic> hallInfo) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ConferenceProvider>(context, listen: false)
          .addHall(hallInfo);
      setState(() {
        _isLoading = false;
        _isAdded = true;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Start adding sessions!")));
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conference Manager"),
        centerTitle: true,

        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {
        //           // _isSearching = true;
        //         });
        //       },
        //       icon: const Icon(
        //         Icons.search_rounded,
        //         size: 30,
        //       )),
        // ],
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isLoading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 500,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                          // contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Hall Name",
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 40,
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("You must enter a hall name!")));
                        } else {
                          Map<String, dynamic> hallInfo = {
                            "hallName": _textEditingController.text,
                            "sessions": []
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
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: Consumer<ConferenceProvider>(
                      builder: (ctx, conferenceProvider, _) => GridView.builder(
                        controller: _scrollController,
                        itemCount: conferenceProvider.allHalls.length,
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
                                    HallDetailsScreen.routeName,
                                    arguments:
                                        conferenceProvider.allHalls[idx]);
                              },
                              child: Center(
                                child: Text(
                                  conferenceProvider.allHalls[idx].hallName,
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          );
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
