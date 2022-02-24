import 'dart:convert' show json;

import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:flutter/material.dart';

class ExerciseSearch extends StatefulWidget {
  final List<Exercise> currentExercises;
  final Function() notifyParent;

  const ExerciseSearch(
      {Key? key, required this.currentExercises, required this.notifyParent})
      : super(key: key);

  @override
  _ExerciseSearchState createState() => _ExerciseSearchState();
}

class SearchEntry {
  int position;
  bool visible = true;
  bool selected = false;
  ExerciseDescription entry;
  SearchEntry({required this.position, required this.entry});

  String get name {
    return entry.name;
  }
}

class SearchList {
  static List<SearchEntry> _list = [];

  SearchList();

  int get length {
    return _list.where((element) => element.visible == true).length;
  }

  List<SearchEntry> get list {
    List<SearchEntry> returnList = [];
    for (SearchEntry element
        in _list.where((element) => element.visible == true)) {
      returnList.add(element);
    }
    return returnList;
  }

  void loadSearchList() async {
    if (_list.isEmpty) {
      int i = 0;
      var jsonData = json.decode(await FileManager().readFile('exercises'));
      for (Map<String, dynamic> jsonExercise in jsonData) {
        _list.add(SearchEntry(
            position: i,
            entry: ExerciseDescription(
                jsonExercise["name"].toString(),
                jsonExercise["description"].toString(),
                jsonExercise["muscle group"].toString())));
        i++;
      }
    }
    _resetSearchList();
  }

  void _resetSearchList() {
    for (SearchEntry entry in _list) {
      entry.visible = false;
      entry.selected = false;
    }
  }

  void search(string) {
    string = string.toLowerCase();
    for (SearchEntry entry in _list) {
      if (entry.name.toLowerCase().contains(string)) {
        entry.visible = true;
      } else {
        entry.visible = false;
      }
    }
  }
}

class _ExerciseSearchState extends State<ExerciseSearch> {
  bool search = true;
  bool filters = false;
  bool loaded = false;
  SearchList searchList = SearchList();

  Future<void> loadData() async {
    searchList.loadSearchList();
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: search
          ? AppBar(
              title: TextFormField(
                //TODO add x to clear search
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white10, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: "search...",
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    letterSpacing: .5,
                  ),
                ),
                keyboardType: TextInputType.text,
                onEditingComplete: () {
                  setState(() {
                    search = false;
                  });
                },
                onChanged: (changes) {
                  setState(() {
                    searchList.search(changes);
                  });
                },
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: () async {
                  setState(() {
                    search = false;
                  });
                },
              ),
            )
          : AppBar(
              title: Row(children: [
                const Text("Choose Exercises to Add"),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: () async {
                    setState(() {
                      search = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                  ),
                  onPressed: () async {
                    setState(() {
                      filters = true; //TODO enable filter functionality
                    });
                  },
                ),
              ]),
            ),
      floatingActionButton: loaded
          ? FloatingActionButton.extended(
              label: const Text("Add"),
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  for (SearchEntry entry in searchList.list) {
                    if (entry.selected) {
                      widget.currentExercises.add(
                        Exercise(
                          entry.name,
                          [], //TODO change to last time's effort
                        ),
                      );
                    }
                  }
                  widget.notifyParent();
                  Navigator.pop(context);
                });
              },
            )
          : null,
      body: loaded
          ? Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: searchList.length,
                  itemExtent: 50,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: .2),
                      child: ListTile(
                        textColor: Colors.white,
                        title: Text(searchList.list[i].name),
                        selected: searchList.list[i].selected,
                        onTap: () {
                          setState(() {
                            searchList.list[i].selected =
                                !searchList.list[i].selected;
                          });
                        },
                        onLongPress: () {
                          //TODO Open Description Page
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
