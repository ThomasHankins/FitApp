import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:flutter/material.dart';

class ExerciseSearch extends StatefulWidget {
  final AdjustableWorkout currentWorkout;
  final Function() notifyParent;

  const ExerciseSearch(
      {Key? key, required this.currentWorkout, required this.notifyParent})
      : super(key: key);

  @override
  _ExerciseSearchState createState() => _ExerciseSearchState();
}

class SearchEntry {
  int position;
  bool visible = true;
  bool selected = false;
  ExerciseDescription desc;
  SearchEntry({required this.position, required this.desc});

  String get name {
    return desc.name;
  }
}

class SearchList {
  static List<SearchEntry> _list = [];

  SearchList();

  int get length {
    return _list.where((element) => element.visible).length;
  }

  List<SearchEntry> get list {
    List<SearchEntry> returnList = [];
    for (SearchEntry element in _list.where((element) => element.visible)) {
      returnList.add(element);
    }
    return returnList;
  }

  void loadSearchList() async {
    if (_list.isEmpty) {
      int i = 0;
      List<ExerciseDescription> dbList =
          await DatabaseManager().getExerciseDescriptionList();
      for (ExerciseDescription desc in dbList) {
        _list.add(SearchEntry(position: i, desc: desc));
        i++;
      }
    }
    _resetSearchList();
  }

  void _resetSearchList() {
    for (SearchEntry entry in _list) {
      entry.visible = true;
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
    print("loaded state with search list of length ${searchList.length}");
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
                      widget.currentWorkout.addExercise(
                        entry.desc,
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
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: searchList.length,
              itemExtent: 50,
              itemBuilder: (context, i) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: .2),
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
                      //TODO Open Description Page (when made)
                    },
                  ),
                );
              },
            )
          : const CircularProgressIndicator(),
    );
  }
}
