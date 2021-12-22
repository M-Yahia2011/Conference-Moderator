import 'package:conf_moderator/models/session.dart';
import 'package:flutter/material.dart';

class SessionDetailsScreen extends StatelessWidget {
  static const routeName = "/session_details";

  const SessionDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Session session =
        ModalRoute.of(context)!.settings.arguments as Session;
    return Scaffold(
      appBar: AppBar(
        title: Text("Session: ${session.sessionName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
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
                      Text("From: ${speakers[idx].startTime}"),
                      Text("To: ${speakers[idx].endTime}"),
                      const Text(
                        "Open File",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Upload File"),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Remove File"),
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
    );
  }
}
