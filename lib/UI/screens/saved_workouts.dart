import 'package:fit_app/UI/screens/workout_builder.dart';
import 'package:fit_app/UI/screens/workout_screen.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/file_manager.dart';

class SavedWorkoutsScreen extends StatefulWidget {
  final List<FutureWorkout> plans;

  const SavedWorkoutsScreen({Key? key, required this.plans}) : super(key: key);
  @override
  _SavedWorkoutsScreenState createState() => _SavedWorkoutsScreenState();
}

class _SavedWorkoutsScreenState extends State<SavedWorkoutsScreen> {
  bool loaded = false;
  late List<FutureWorkout> plans;

  @override
  void initState() {
    plans = widget.plans;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: plans.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Row(
                  children: [
                    Text(plans[i].name),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return WorkoutBuilderScreen(
                              thisWorkout: plans[i],
                            );
                          },
                        ));
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        DatabaseManager().deleteSavedWorkout(plans[i].id);
                        plans.removeAt(i);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return WorkoutScreen(
                        thisWorkout: LiveWorkout.convertFromSaved(plans[i]),
                      );
                    },
                  ));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
