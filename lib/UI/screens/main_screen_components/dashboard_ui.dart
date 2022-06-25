import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import 'dashboard_components/component_tile.dart';
import 'dashboard_components/workout_calendar_widget.dart';

class DashboardWidget extends StatefulWidget {
  final List<HistoricWorkout>
      history; //will probably need more than this eventually

  const DashboardWidget({Key? key, required this.history}) : super(key: key);
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ComponentTile(
            widget: widget,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Your Daily Dashboard",
                style: Theme.of(context)
                    .textTheme
                    .headline2, //maybe make headline 1
              ),
            )),
        ComponentTile(
          widget: widget,
          child: CalendarWidget(
            history: widget.history,
          ),
        ),
      ],
    );
  }
}
