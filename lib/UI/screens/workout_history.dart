
import 'package:flutter/material.dart';
import 'dart:convert' show json;
import 'package:fit_app/workout-tracker/HistoryManager.dart';
import 'package:fit_app/workout-tracker/workout.dart';
import 'workout_history_detail.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  static String id = 'workout_history_screen';

  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<dynamic> history = [];

  @override
  void initState() {
    //should have debugging on call so we know if file got opened
    loadHistory();
    super.initState();

  }

  void loadHistory() async {
    history =  json.decode(await HistoryManager().readHistory());
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: history.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(history[i]["name"]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailScreen(
                            thisWorkout: Workout.fromJSON(history[i]),
                          ),
                        )
                        //move to workout detail
                        );
                    }
                    );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
