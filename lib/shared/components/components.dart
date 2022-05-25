import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast({
  required String text,
  required ToastState state,
}) => Fluttertoast.showToast(
    msg:text ,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastState{SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastState state){
  late Color color;
  switch(state){
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
      case ToastState.ERROR:
      color = Colors.red;
      break;
      case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
