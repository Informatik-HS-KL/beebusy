import 'dart:math';

import 'package:beebusy_app/controller/register_controller.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/logo_box.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends GetView<RegisterController> {
  static const String route = '/register';

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _surNameEditingController =
      TextEditingController();
  final TextEditingController _mailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LogoBox(),
              MyTextFormField(
                maxLength: 70,
                minLines: 1,
                maxLines: 3,
                controller: _firstNameEditingController,
                labelText: AppLocalizations.of(context).firstnameLabel,
                icon: Icons.account_circle,
                validator: (String value) => value == null || value.isBlank
                    ? AppLocalizations.of(context).emptyError
                    : null,
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyTextFormField(
                maxLength: 70,
                minLines: 1,
                maxLines: 3,
                controller: _surNameEditingController,
                labelText: AppLocalizations.of(context).lastnameLabel,
                icon: Icons.account_circle,
                validator: (String value) => value == null || value.isBlank
                    ? AppLocalizations.of(context).emptyError
                    : null,
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyTextFormField(
                minLines: 1,
                maxLines: 3,
                controller: _mailEditingController,
                labelText: AppLocalizations.of(context).emailLabel,
                icon: Icons.email,
                validator: (String value) => !value.isEmail
                    ? AppLocalizations.of(context).invalidEmailError(
                        '${value.substring(0, min(12, value.length))}${value.length > 10 ? '...' : ''}')
                    : null,
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyRaisedButton(
                buttonText: AppLocalizations.of(context).submitButton,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    controller.onRegister(
                      firstname: _firstNameEditingController.text,
                      lastname: _surNameEditingController.text,
                      email: _mailEditingController.text,
                      context: context,
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyFlatButton(
                buttonText: AppLocalizations.of(context).backButton,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
