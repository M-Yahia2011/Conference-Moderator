import 'package:conf_moderator/helpers/colors.dart';

import '/providers/conf_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetIPScreen extends StatefulWidget {
  const SetIPScreen({Key? key}) : super(key: key);
  static const String routeName = "/set_IP";

  @override
  State<SetIPScreen> createState() => _SetIpScreenState();
}

class _SetIpScreenState extends State<SetIPScreen> {
  late TextEditingController _textEditingControllerIP;
  late TextEditingController _textEditingControllerPort;
  @override
  void initState() {
    super.initState();
    _textEditingControllerIP = TextEditingController();
    _textEditingControllerPort = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerIP.dispose();
    _textEditingControllerPort.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set the IP"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Enter The IP and the Port number for the Server"),
            SizedBox(
              width: 500,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      width: 200,
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        controller: _textEditingControllerIP,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            labelText: "Set the IP ex. 192.168.1.1",
                            labelStyle:
                                TextStyle(fontSize: 14, color: Colors.black),
                            border: InputBorder.none),
                        onSubmitted: (_) {
                          if (_textEditingControllerIP.text.isEmpty ||
                              _textEditingControllerPort.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: MyColors.colors[200],
                                content: const Text(
                                    "You must enter the IP and the Port number!")));
                          } else {
                            Provider.of<ConferenceProvider>(context,
                                    listen: false)
                                .setIP(_textEditingControllerIP.text,
                                    _textEditingControllerPort.text);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 60,
                    width: 150,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textEditingControllerPort,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Port",
                          labelStyle:
                              TextStyle(fontSize: 14, color: Colors.black),
                          border: InputBorder.none),
                      onSubmitted: (_) {
                        if (_textEditingControllerIP.text.isEmpty ||
                            _textEditingControllerPort.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: MyColors.colors[200],
                              content: const Text(
                                  "You must enter the IP and the Port number!")));
                        } else {
                          Provider.of<ConferenceProvider>(context,
                                  listen: false)
                              .setIP(_textEditingControllerIP.text,
                                  _textEditingControllerPort.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  if (_textEditingControllerIP.text.isEmpty ||
                      _textEditingControllerPort.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: MyColors.colors[200],
                        content:
                            const Text("You must enter the IP and the Port!")));
                  } else {
                    Provider.of<ConferenceProvider>(context, listen: false)
                        .setIP(_textEditingControllerIP.text,
                            _textEditingControllerPort.text);
                  }

                  _textEditingControllerIP.clear();
                  _textEditingControllerPort.clear();
                },
                child: const Text(
                  "GO",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
