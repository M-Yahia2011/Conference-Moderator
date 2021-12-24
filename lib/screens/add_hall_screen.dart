import 'package:conf_moderator/providers/conf_provider.dart';
import 'package:conf_moderator/screens/add_session_screen.dart';
import 'package:conf_moderator/screens/session_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class AddHallScreen extends StatefulWidget {
  const AddHallScreen({Key? key}) : super(key: key);
  static const routeName = "/add_hall";
  @override
  State<AddHallScreen> createState() => _AddHallScreenState();
}

class _AddHallScreenState extends State<AddHallScreen> {
  late TextEditingController _textEditingController;
  bool _isLoading = false;
  bool _isAdded = false;
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
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a hall"),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        // opacity: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 10),
          child: Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      labelText: "Hall Name",
                      labelStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 300,
                    height: 40,
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                        onPressed: _isAdded == true
                            ? () {
                                Navigator.of(context)
                                    .pushNamed(AddSessionScreen.routeName);
                              }
                            : null,
                        child: const Text(
                          "Add a Session",
                          style: TextStyle(fontSize: 25),
                        )),
                  ),
                  Container(
                    width: 300,
                    height: 40,
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> hallInfo = {
                          "hallName": _textEditingController.text,
                          "sessions": []
                        };

                        await addHall(hallInfo);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 1.5 / 2,
                      ),
                      itemCount: 10,
                      itemBuilder: (ctx, idx) {
                        return SizedBox(
                          height: 200,
                          width: 200,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SessionDetailsScreen.routeName,
                                    arguments: idx.toString());
                              },
                              child: Center(child: Text("session $idx")),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
