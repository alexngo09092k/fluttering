import 'package:fluttering/fluttering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttering/widgets/alert.dart';

Future<T?> showPopup<T>(BuildContext context, Widget popup, {bool barrierDismissible = true}) {
  return showCupertinoModalPopup<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) => popup,
  );
}

Future<T?> showAlert<T>(
  BuildContext context, {
  required List<AwesomeAlertButton> buttons,
  required Widget content,
  required String title,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (BuildContext context) => AwesomeAlert(
      buttons: buttons,
      content: content,
      title: title,
    ),
  );
}

enum SnackBarType {
  info,
  error,
  success,
}

void showSnackBar(BuildContext context, {required SnackBarType type, required String message}) {
  switch (type) {
    case SnackBarType.error:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
      break;
    case SnackBarType.success:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
      break;
    case SnackBarType.info:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
      break;
    default:
  }
}

Future<T?> showActionSheet<T>(
  BuildContext context, {
  String? title,
  String? message,
  List<Widget>? actions,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (BuildContext context) => CupertinoTheme(
      data: CupertinoThemeData(
        brightness: ManagerProvider.of<ThemeProvider>().brightness,
        scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        primaryColor: Theme.of(context).primaryColor,
        barBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textTheme: CupertinoTextThemeData(
          primaryColor: Theme.of(context).primaryColor,
          textStyle: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      child: CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        message: message != null ? Text(message) : null,
        actions: actions,
      ),
    ),
  );
}
