import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({this.title, this.content, this.onConfirm});

  final String title;
  final String content;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: BrownText(title),
      ),
      content: BrownText(content),
      actions: <Widget>[
        MyFlatButton(
          buttonText: AppLocalizations.of(context).cancelButton,
          onPressed: () => Get.back<void>(),
        ),
        MyRaisedButton(
          buttonText: AppLocalizations.of(context).continueButton,
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
