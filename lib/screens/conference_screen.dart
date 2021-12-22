import 'package:conf_moderator/screens/add_hall_screen.dart';
import 'package:flutter/material.dart';

class ConferenceScreen extends StatefulWidget {
  static const routeName = "/add_conf";

  const ConferenceScreen({Key? key}) : super(key: key);

  @override
  State<ConferenceScreen> createState() => _AddConferenceScreenState();
}

class _AddConferenceScreenState extends State<ConferenceScreen> {
  final _formKey = GlobalKey<FormState>();
  late ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conference"),
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
                  child: TextFormField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        labelText: "Conference Name",
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 500,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddHallScreen.routeName);
                      },
                      child: const Text(
                        "Add a Hall",
                        style: TextStyle(fontSize: 25),
                      )),
                ),
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: 10,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.5 / 2,
                    ),
                    itemBuilder: (context, idx) {
                      return Card(
                        margin: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              "Hall NO. $idx",
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
