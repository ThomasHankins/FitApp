import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:flutter/material.dart';

import 'history_detail.dart';

class HistoryWidget extends StatefulWidget {
  List<HistoricWorkout> history;
  // Function updateState;
  HistoryWidget({Key? key, required this.history}) : super(key: key);
  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  // final Function updateState;

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
            itemCount: widget.history.length,
            itemBuilder: (context, i) {
              i = widget.history.length - i - 1; //flip indicies
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.history[i].name),
                    Text(widget.history[i].id.toString()),
                    IconButton(
                      //TODO format so that button is hidden unless long press
                      onPressed: () {
                        DatabaseManager().deleteHistoricWorkout(widget
                            .history[i].id); //TODO add a delete confirmation
                        widget.history.removeAt(i);
                        setState(() => Null);
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
                        ClockConverter()
                            .iso8601ToFormatted(widget.history[i].date),
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
                      ClockConverter()
                          .secondsToFormatted(widget.history[i].length),
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
                        thisWorkout: widget.history[i],
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
