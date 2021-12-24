import '/providers/conf_provider.dart';
import 'package:conf_moderator/screens/add_speaker_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class AddSessionScreen extends StatefulWidget {
  static const routeName = "/add_session";
  
  const AddSessionScreen({Key? key}) : super(key: key);

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  DateTime? pickedDate;
  @override
  Widget build(BuildContext context) {
    
    // Provider.of<ConferenceProvider>(context, listen: false)
    //     .getSessionbyID("1", widget.sessionID);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a session"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050));
                  setState(() {
                    pickedDate = picked;
                  });
                },
                child: Text(
                    pickedDate != null
                        ? intl.DateFormat.yMMMEd().format(pickedDate!)
                        : "Pick a Date",
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                width: 500,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          AddSpeakerScreen.routeName,
                          arguments: "1");
                    },
                    child: const Text("Add a Speaker",
                        style: TextStyle(fontSize: 20)))),
            Expanded(
              child: ListView.builder(
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
                          onTap: () {},
                          child: Center(child: Text("Speaker $idx")),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
