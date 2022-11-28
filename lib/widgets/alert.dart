import 'package:fluttering/fluttering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwesomeAlert extends StatelessWidget {
  const AwesomeAlert({super.key, required this.buttons, required this.content, required this.title});
  final String title;
  final Widget content;
  final List<AwesomeAlertButton> buttons;

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: ManagerProvider.of<ThemeProvider>().brightness,
        primaryColor: Theme.of(context).primaryColor,
      ),
      child: CupertinoAlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: content,
        actions: List.generate(
          buttons.length,
          (index) => CupertinoDialogAction(
            isDestructiveAction: buttons[index].isDestructiveAction,
            onPressed: () => buttons[index].action(context),
            child: Text(
              buttons[index].name,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: buttons[index].color,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class AwesomeAlertButton {
  final String name;
  final Function(BuildContext) action;
  final Color color;
  final bool isDestructiveAction;

  AwesomeAlertButton({
    required this.name,
    required this.action,
    required this.color,
    this.isDestructiveAction = false,
  });
}
