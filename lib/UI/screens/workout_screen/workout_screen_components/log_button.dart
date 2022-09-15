import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogButtonWidget extends StatefulWidget {
  const LogButtonWidget({
    Key? key,
    required bool initStatus,
    required Function() callBack,
  })  : _initStatus = initStatus,
        _callBack = callBack,
        super(key: key);
  final Function() _callBack;
  final bool _initStatus;

  @override
  _LogButtonState createState() =>
      _LogButtonState();
}

class _LogButtonState extends State<LogButtonWidget> {
  late bool _pressed;

  @override
  void initState(){
    _pressed = widget._initStatus;
    super.initState();
  }

  void buttonPress(){

    widget._callBack();
    setState(() {
      if(!_pressed) {
      _pressed = true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return _pressed ? IconButton(onPressed: (){}, icon: const Icon(Icons.check)) :
    IconButton(onPressed: (){}, icon: const Icon(Icons.circle));
  }

}