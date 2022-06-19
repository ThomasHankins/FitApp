import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:flutter/material.dart';

import 'history_detail.dart';

class HistoryWidget extends StatelessWidget {
  final Function setState;
  List<HistoricWorkout> history;
  HistoryWidget({Key? key, required this.setState, required this.history})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: history.length,
            itemBuilder: (context, i) {
              i = history.length - i - 1; //flip indicies
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(history[i].name),
                    IconButton(
                      //TODO format so that button is hidden unless long press
                      onPressed: () {
                        DatabaseManager().deleteHistoricWorkout(
                            history[i].id); //TODO add a delete confirmation
                        history.removeAt(i);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        ClockConverter().iso8601ToFormatted(history[i].date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.timelapse_outlined,
                      size: 12,
                      color: Colors.white38,
                    ),
                    Text(
                      ClockConverter().secondsToFormatted(history[i].length),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return HistoryDetailScreen(
                        thisWorkout: history[i],
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
