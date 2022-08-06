import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;
  final Key? key;

  const DismissibleWidget({
    required this.item,
    required this.child,
    required this.onDismissed,
    required this.key,
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      );
}
