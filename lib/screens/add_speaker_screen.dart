import 'package:flutter/material.dart';

class AddSpeakerScreen extends StatefulWidget {
  static const routeName = "/add_speaker";

  const AddSpeakerScreen({Key? key}) : super(key: key);

  @override
  State<AddSpeakerScreen> createState() => _AddSpeakerScreenState();
}

class _AddSpeakerScreenState extends State<AddSpeakerScreen> {
  TimeOfDay? endTime;
  TimeOfDay? startTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Speaker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    labelText: "Speaker's Name",
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Text("From"),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        setState(() {
                          startTime = picked;
                        });
                      },
                      child: startTime != null
                          ? Text(startTime!.format(context))
                          : const Text(
                              "Time",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("To"),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        setState(() {
                          endTime = picked;
                        });
                      },
                      child: endTime != null
                          ? Text(endTime!.format(context))
                          : const Text(
                              "Time",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Upload the File"),
                  icon: const Icon(Icons.upload_file),
                )),
          ],
        ),
      ),
    );
  }
}
