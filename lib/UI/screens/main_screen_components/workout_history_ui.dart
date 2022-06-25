import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:flutter/material.dart';

import 'history_detail.dart';

class HistoryWidget extends StatefulWidget {
  final List<HistoricWorkout> history;
  // Function updateState;
  const HistoryWidget({Key? key, required this.history}) : super(key: key);
  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  bool _deleteMode = false;
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
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.history[i].name),
                    ],
                  ),
                ),
                subtitle: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        ClockConverter()
                            .iso8601ToFormatted(widget.history[i].date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    const Spacer(),
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
                trailing: _deleteMode
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Are you sure you want to delete this workout?'),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: <Widget>[
                                    MaterialButton(
                                      child: const Text('Yes'),
                                      onPressed: () async {
                                        Navigator.pop(context, 'Yes');
                                        DatabaseManager().deleteHistoricWorkout(
                                            widget.history[i].id);
                                        widget.history.removeAt(i);
                                        setState(() => Null);
                                      },
                                    ),
                                    MaterialButton(
                                      child: const Text('Cancel'),
                                      onPressed: () async {
                                        Navigator.pop(context, 'Cancel');
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        ),
                      )
                    : null,
                visualDensity: VisualDensity.comfortable,
                onLongPress: () {
                  setState(() {
                    _deleteMode = true;
                  });
                },
                onTap: () {
                  if (_deleteMode) {
                    _deleteMode = false;
                    setState(() {});
                  } else {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return HistoryDetailScreen(
                          thisWorkout: widget.history[i],
                        );
                      },
                    ));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
