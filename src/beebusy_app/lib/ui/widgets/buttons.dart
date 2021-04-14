import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {
  const MyRaisedButton({@required this.buttonText, @required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      buttonColor: Theme.of(context).accentColor,
      child: RaisedButton(
        child: BrownText(buttonText),
        onPressed: onPressed,
      ),
    );
  }
}

class MyFlatButton extends StatelessWidget {
  const MyFlatButton({@required this.buttonText, @required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      child: FlatButton(
        child: BrownText(buttonText),
        onPressed: onPressed,
        hoverColor: Theme.of(context).hoverColor,
      ),
    );
  }
}
