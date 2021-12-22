import 'package:flutter/material.dart';

class HallDetailsScreen extends StatelessWidget {
  static const routeName = "/hallDetailsScreen";



  @override
  Widget build(BuildContext context) {
      final int hallID = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hall ${hallID.toString()}"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 200, vertical: 50),
        child: ListView.builder(itemBuilder: (context, idx) {
          return Card(
            child: Column(
              children: [
                Text("Dr. Assem"),
                Text("From: 13:00 PM"),
                Text("To: 15:00 PM"),
                Text("Open File"),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Upload File"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Remove File"),
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
