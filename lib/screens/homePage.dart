import 'package:flutter/material.dart';
import '/models/speaker_suggestion.dart';
import '/models/session.dart';
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
  late TextEditingController _textEditingControllerSearch;
  Future<void> fetchAllHalls() async {
    try {
      await Provider.of<ConferenceProvider>(context, listen: false)
          .getAllHalls();
      await Provider.of<ConferenceProvider>(context, listen: false)
          .getSuggestions();
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Check the server!")));
      rethrow;
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

  Future<List<SpeakerSuggestion>> getSearchSuggestions(String query) async {
    try {
      String queryLower = query.toLowerCase();
      List<SpeakerSuggestion> suggestions =
          Provider.of<ConferenceProvider>(context, listen: false)
              .searchSuggestions;

      return suggestions
          .where((suggestion) =>
              suggestion.speaker.name.toLowerCase().contains(queryLower))
          .toList();
    } catch (e) {
      throw "Query problem";
    }
  }

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
                          child: Image.asset("assets/logo.png"),
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
                          child: TypeAheadField<SpeakerSuggestion>(
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
                            onSuggestionSelected: (suggestion) {
                              final Session? session =
                                  Provider.of<ConferenceProvider>(context,
                                          listen: false)
                                      .getSessionbyID(
                                          suggestion.speaker.sessionId);
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
                            itemBuilder: (context, suggestedItem) {
                            
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          suggestedItem.speaker.name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        const Spacer(),
                                        suggestedItem.speaker.file.isNotEmpty
                                            ? const Icon(
                                                Icons.done,
                                                color: Colors.green,
                                                size: 28,
                                              )
                                            : const Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                                size: 28,
                                              ),
                                      ],
                                    ),
                                    Text(
                                      suggestedItem.speaker.subject,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      suggestedItem.sessionName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      suggestedItem.hallName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              );
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
