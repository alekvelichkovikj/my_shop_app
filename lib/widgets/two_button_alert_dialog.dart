import 'package:flutter/material.dart';

class TwoButtonAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String firstButtonText;
  final String secondButtonText;
  final Function firstButtonOnTap;
  final Function secondButtonOnTap;

  const TwoButtonAlertDialog({
    Key key,
    @required this.content,
    @required this.firstButtonOnTap,
    @required this.firstButtonText,
    @required this.secondButtonOnTap,
    @required this.secondButtonText,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget firstButton = TextButton(
      child: Text(firstButtonText),
      onPressed: firstButtonOnTap,
    );

    Widget secondButton = TextButton(
      child: Text(secondButtonText),
      onPressed: secondButtonOnTap,
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        firstButton,
        secondButton,
      ],
    );

    return Container(
      child: alert,
    );
  }
}
