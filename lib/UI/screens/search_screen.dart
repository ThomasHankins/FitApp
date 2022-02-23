import 'dart:convert' show json;

import 'package:fit_app/workout-tracker/FileManager.dart';
import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseSearch extends StatefulWidget {
  final List<Exercise> currentExercises;
  final Function() notifyParent;

  ExerciseSearch({required this.currentExercises, required this.notifyParent});

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

class _ExerciseSearchState extends State<ExerciseSearch> {
  bool loaded = false;
  static List<SearchEntry> searchList = [];
  Future<void> loadData() async {
    if (searchList.isEmpty) {
      int i = 0;
      var jsonData = json.decode(await FileManager().readFile('exercises'));
      for (Map<String, dynamic> jsonExercise in jsonData) {
        searchList.add(SearchEntry(
            position: i,
            entry: ExerciseDescription(
                jsonExercise["name"].toString(),
                jsonExercise["description"].toString(),
                jsonExercise["muscle group"].toString())));
        i++;
      }
    }
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
      appBar: AppBar(
        title: const Text(
            "Choose Exercises to Add"), //TODO: will replace with search later
        //TODO: finish customizing app bar
      ),
      floatingActionButton: loaded
          ? FloatingActionButton.extended(
              label: const Text("Add"),
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  for (SearchEntry item in searchList) {
                    if (item.selected) {
                      widget.currentExercises.add(
                        Exercise(
                          item.name,
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
                        title: Text(searchList[i].name),
                        selected: searchList[i].selected,
                        onTap: () {
                          setState(() {
                            searchList[i].selected = !searchList[i].selected;
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
          : CircularProgressIndicator(),
    );
  }
}
