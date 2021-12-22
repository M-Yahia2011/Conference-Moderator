import 'package:conf_moderator/providers/conf_provider.dart';
import 'package:conf_moderator/screens/add_hall_screen.dart';
import 'package:conf_moderator/screens/add_session_screen.dart';
import 'package:conf_moderator/screens/hall_details_screen.dart';
import 'package:conf_moderator/screens/session_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/add_speaker_screen.dart';
import 'screens/conference_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConferenceProvider(),
      child: MaterialApp(
        title: 'Conference Moderator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.teal,
            textTheme: const TextTheme(
              bodyText2: TextStyle(fontSize: 25),
              bodyText1: TextStyle(fontSize: 30),
            )),
        home: const ConferenceScreen(),
        routes: {
          ConferenceScreen.routeName: (ctx) => const ConferenceScreen(),
          HallDetailsScreen.routeName: (ctx) => const HallDetailsScreen(),
          SessionDetailsScreen.routeName: (ctx) => const SessionDetailsScreen(),
          AddHallScreen.routeName: (ctx) => const AddHallScreen(),
          AddSessionScreen.routeName: (ctx) => const AddSessionScreen(),
          AddSpeakerScreen.routeName: (ctx) => const AddSpeakerScreen(),
        },
      ),
    );
  }
}
