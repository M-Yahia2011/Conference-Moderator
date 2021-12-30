import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import '/helpers/app_theme.dart';
import '/providers/conf_provider.dart';
import './screens/screens.dart';

void main() {
  setPathUrlStrategy();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
   
  Future<void> checkEndpoint(BuildContext context) async {
    await Provider.of<ConferenceProvider>(context, listen: false)
        .checkStoredMainpoint();
    print("checked");
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
            /// this part to prevent calling checkpoint
            if (provider.isStoredEndpointChecked == false) {
              checkEndpoint(context);
              provider.isStoredEndpointChecked = true;
            }
            ///
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
