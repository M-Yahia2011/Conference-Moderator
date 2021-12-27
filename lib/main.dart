import 'package:conf_moderator/helpers/app_theme.dart';
import 'package:conf_moderator/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './/providers/conf_provider.dart';
import './screens/screens.dart';

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
        theme: AppTheme.theme,
        // ThemeData(
        //     primarySwatch: Colors.red,
        //     textTheme: const TextTheme(
        //       bodyText2: TextStyle(fontSize: 25),
        //       bodyText1: TextStyle(fontSize: 30),
        //     )),
        home: const HomePage(),
        routes: {
          HomePage.routeName: (ctx)=> const HomePage(),
          ConferenceScreen.routeName: (ctx) => const ConferenceScreen(),
          HallDetailsScreen.routeName: (ctx) => const HallDetailsScreen(),
          SessionDetailsScreen.routeName: (ctx) => const SessionDetailsScreen(),
        },
      ),
    );
  }
}
