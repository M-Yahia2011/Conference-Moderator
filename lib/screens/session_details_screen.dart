import 'package:flutter/material.dart';

class SessionDetailsScreen extends StatelessWidget {
  static const routeName = "/session_details";

  const SessionDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String sessionID =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Session ${sessionID.toString()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
        child: ListView.builder(itemBuilder: (context, idx) {
          return Card(
            child: Column(
              children: [
                const Text("Dr. Assem"),
                const Text("From: 13:00 PM"),
                const Text("To: 15:00 PM"),
                const Text("Open File"),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Upload File"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Remove File"),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
