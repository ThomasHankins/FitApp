import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const DismissibleWidget({
    required this.item,
    required this.child,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dismissible(
        onDismissed: onDismissed,
        direction: DismissDirection.endToStart,
        background: swipeActionRight(),
        key: ObjectKey(item),
        child: child,
      );
  Widget swipeActionRight() => Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      );
}
