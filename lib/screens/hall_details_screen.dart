import 'package:conf_moderator/models/hall.dart';
import 'package:conf_moderator/providers/conf_provider.dart';
import 'package:conf_moderator/screens/session_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HallDetailsScreen extends StatelessWidget {
  static const routeName = "/hallDetailsScreen";

  const HallDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String hallID = ModalRoute.of(context)!.settings.arguments as String;
    final Hall hall = Provider.of<ConferenceProvider>(context, listen: false)
        .getHallbyID(hallID);
    return Scaffold(
      appBar: AppBar(
        title: Text(hall.hallName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
        child:
            Consumer<ConferenceProvider>(builder: (ctx, conferenceProvider, _) {
          final sessions = conferenceProvider.getSessions(hallID);
          return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, idx) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(SessionDetailsScreen.routeName, arguments: sessions[idx]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Session: ${sessions[idx].sessionName}"),
                          Text("Date: ${sessions[idx].sessionDate}"),
                         
                        ],
                      ),
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }
}
