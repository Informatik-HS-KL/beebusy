import 'package:beebusy_app/controller/login_controller.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/logo_box.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends GetView<LoginController> {
  static const String route = '/login';

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _editingController =
      TextEditingController(text: 'david@test.de');

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
                minLines: 1,
                maxLines: 3,
                controller: _editingController,
                labelText: AppLocalizations.of(context).emailLabel,
                icon: Icons.email,
                validator: (String value) => value == null || value.isBlank
                    ? AppLocalizations.of(context).emptyError
                    : null,
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyRaisedButton(
                buttonText: AppLocalizations.of(context).loginButton,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    controller.onLogin(_editingController.text, context);
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyFlatButton(
                buttonText: AppLocalizations.of(context).registerButton,
                onPressed: controller.onRegister,
              )
            ],
          ),
        ),
      ),
    );
  }
}
