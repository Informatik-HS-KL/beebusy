import 'package:flutter/material.dart';

class BodyTitle extends StatelessWidget {
  const BodyTitle({
    @required this.title,
    this.trailing = '',
  });

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textScaleFactor: 3,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Text(
          trailing,
          textScaleFactor: 3,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

class BrownText extends StatelessWidget {
  const BrownText(this.text, {this.isBold = false});

  final String text;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: isBold ? FontWeight.bold : null,
      ),
    );
  }
}
