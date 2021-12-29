import '/helpers/app_theme.dart';
import '/screens/homePage.dart';
import '/screens/set_IP_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/conf_provider.dart';
import './screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Future<void> checkEndpoint(BuildContext context) async {
    await Provider.of<ConferenceProvider>(context, listen: false)
        .checkStoredMainpoint();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConferenceProvider(),
      child: MaterialApp(
        title: 'Conference Moderator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: Consumer<ConferenceProvider>(
          builder: (context, provider, child) {
            checkEndpoint(context);
            if (provider.isEndpointSetted() == true) {
              return const HomePage();
            } else {
              return const SetIPScreen();
            }
          },
        ),
        // const HomePage(),
        routes: {
          SetIPScreen.routeName: (ctx) => const SetIPScreen(),
          HomePage.routeName: (ctx) => const HomePage(),
          ConferenceScreen.routeName: (ctx) => const ConferenceScreen(),
          HallDetailsScreen.routeName: (ctx) => const HallDetailsScreen(),
          SessionDetailsScreen.routeName: (ctx) => const SessionDetailsScreen(),
        },
      ),
    );
  }
}
