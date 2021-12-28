import 'package:conf_moderator/helpers/app_theme.dart';
import 'package:conf_moderator/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './/providers/conf_provider.dart';
import './screens/screens.dart';
/*
Developed by Mohamed Yahia at 28/12/2021
m.yahia.eid2011@gmail.com 
*/
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
