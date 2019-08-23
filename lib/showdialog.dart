import 'package:flutter/material.dart';

class ShowDialog extends StatefulWidget {
  final String title;
  final String body;
  ShowDialog(this.title,this.body);
  @override
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: new Text(widget.title),
          content: new Text(widget.body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
      )
      );
  }
}
