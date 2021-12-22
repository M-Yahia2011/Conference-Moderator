import 'package:flutter/material.dart';

class HallDetailsScreen extends StatelessWidget {
  static const routeName = "/hallDetailsScreen";

  const HallDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String hallID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hall $hallID"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
        child: ListView.builder(itemBuilder: (context, idx) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text("Dr. Assem"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("From: 13:00 PM"),
                      const Text("To: 15:00 PM"),
                    ],
                  ),
                  const Text("Open File"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Upload File"),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 40,
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
