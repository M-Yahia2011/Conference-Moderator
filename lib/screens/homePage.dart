import 'package:conf_moderator/models/hall.dart';
import 'package:flutter/material.dart';
import '/models/session.dart';
import '/models/speaker.dart';
import '/screens/screens.dart';
import '/providers/conf_provider.dart';
import 'package:flutter_typeahead2/flutter_typeahead2.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/homepage";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future? _future;
  bool _isLoading = false;
  late TextEditingController _textEditingControllerSearch;
  Future<void> fetchAllHalls() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ConferenceProvider>(context, listen: false)
          .getAllHalls();
      await Provider.of<ConferenceProvider>(context, listen: false)
          .getAllSpeakers();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _future = fetchAllHalls();
    _textEditingControllerSearch = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerSearch.dispose();
    super.dispose();
  }

  Future<List<Speaker>> getSearchSuggestions(String query) async {
    try {
      String queryLower = query.toLowerCase();
      List<Speaker> speakers =
          Provider.of<ConferenceProvider>(context, listen: false).allSpeakers;

      return speakers
          .where((speaker) => speaker.name.toLowerCase().contains(queryLower))
          .toList();
    } catch (e) {
      throw "Query problem";
    }
  }

  // Future<List<Hall>> getSearchSuggestions(String query) {
  //   String queryLower = query.toLowerCase();
  //   List<Hall> suggestedHalls = [];

  //   List<Hall> halls =
  //       Provider.of<ConferenceProvider>(context, listen: false).allHalls;
  //   for (var hall in halls) {
  //     for (var session in hall.sessions) {
  //       for (var speaker in session.speakers) {
  //         if (speaker.name.toLowerCase().contains(queryLower)) {
  //           suggestedHalls.add(hall);
  //         }
  //       }
  //     }
  //   }
  //   return suggestedHalls;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: _future,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(0, 180, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Image.asset("logo.png"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50,
                          width: 400,
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          // margin: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15)),
                          child: TypeAheadField<Speaker>(
                            textFieldConfiguration: TextFieldConfiguration(
                              // focusNode: _focusNode,
                              // autofocus: true,
                              controller: _textEditingControllerSearch,
                              decoration: InputDecoration(
                                  icon: const Icon(Icons.search),
                                  // contentPadding: EdgeInsets.symmetric(
                                  //     horizontal: 15),
                                  labelText: "Search by speaker's name!",
                                  labelStyle:
                                      TextStyle(color: Colors.grey[600]),
                                  border: InputBorder.none),
                            ),
                            onSuggestionSelected: (spreaker) {
                              final Session? session =
                                  Provider.of<ConferenceProvider>(context,
                                          listen: false)
                                      .getSessionbyID(spreaker.sessionId);
                              Navigator.of(context).pushNamed(
                                  SessionDetailsScreen.routeName,
                                  arguments: session);
                            },
                            suggestionsCallback: (query) async =>
                                getSearchSuggestions(query),
                            noItemsFoundBuilder: (ctx) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "This speaker Doesn't exist",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            itemBuilder: (context, suggestedSpeaker) {
                              return ListTile(
                                
                                  title: Text(
                                    "${suggestedSpeaker.name} - ${suggestedSpeaker.subject}",
                                    style: const TextStyle(
                                      fontSize:20,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  trailing: Column(
                                    children: [
                                      const Text("File status",style: TextStyle(fontSize: 10),),
                                      suggestedSpeaker.file.isNotEmpty
                                          ? const Icon(
                                              Icons.done,
                                              color: Colors.green,
                                              size: 24,
                                            )
                                          : const Text("Waiting",style: TextStyle(fontSize: 10)),
                                    ],
                                  ));
                            },
                            debounceDuration: const Duration(milliseconds: 500),
                            suggestionsBoxDecoration:
                                const SuggestionsBoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ConferenceScreen.routeName);
                            },
                            child: const Text(
                              "Enter Conference Halls",
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              })),
    );
  }
}
/*
TypeAheadField<Item>(
                      
                          onSuggestionSelected: (item) {
                            _isSearching = false;
                            Navigator.of(context).pushNamed(
                                ItemDetailsScreen.routeName,
                                arguments: item);
                          },
                          suggestionsCallback: (query) async =>
                              getSearchSuggestions(query),
                          noItemsFoundBuilder: (ctx) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "No item was found",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          itemBuilder: (context, suggestedSpeaker) {
                            return ListTile(
                              leading: Image.asset(suggestedSpeaker.image),
                              title: Text(suggestedSpeaker.name),
                              // subtitle: Text('subtitle'),
                            );
                          },
                          debounceDuration: Duration(milliseconds: 500),
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                          ),
                        )

*/