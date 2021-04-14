import 'package:beebusy_app/controller/profile_controller.dart';
import 'package:beebusy_app/ui/widgets/alert_dialog.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  static const String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showActions: true,
      body: Form(
        key: controller.formKey,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                minRadius: 100,
                child: Text(
                  controller.currentUser.nameInitials ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 44,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              if (controller.isEditing.value)
                FlatButton(
                  onPressed: () => controller.savePressed(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.save,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      BrownText(AppLocalizations.of(context).saveLabel),
                    ],
                  ),
                )
              else
                FlatButton(
                  onPressed: controller.editPressed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      BrownText(AppLocalizations.of(context).editProfile),
                    ],
                  ),
                ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!controller.isEditing.value)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BrownText(
                            AppLocalizations.of(context).firstnameLabel,
                            isBold: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BrownText(
                            AppLocalizations.of(context).lastnameLabel,
                            isBold: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BrownText(
                            AppLocalizations.of(context).emailLabel,
                            isBold: true,
                          ),
                        ),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (controller.isEditing.value)
                        SizedBox(
                          width: 300,
                          child: MyTextFormField(
                            controller: controller.firstNameEditingController,
                            labelText:
                                AppLocalizations.of(context).firstnameLabel,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              BrownText(controller.currentUser.firstname ?? ''),
                        ),
                      if (controller.isEditing.value)
                        SizedBox(
                          width: 300,
                          child: MyTextFormField(
                            controller: controller.surNameEditingController,
                            labelText:
                                AppLocalizations.of(context).lastnameLabel,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              BrownText(controller.currentUser.lastname ?? ''),
                        ),
                      if (controller.isEditing.value)
                        SizedBox(
                          width: 300,
                          child: MyTextFormField(
                            controller: controller.mailEditingController,
                            labelText: AppLocalizations.of(context).emailLabel,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BrownText(controller.currentUser.email ?? ''),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              if (!controller.isEditing.value)
                ButtonTheme(
                  minWidth: 200,
                  buttonColor: Colors.red,
                  child: RaisedButton(
                    child: Text(
                      AppLocalizations.of(context).deleteUserButton,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => MyAlertDialog(
                        title: AppLocalizations.of(context).deleteUserButton,
                        content:
                            AppLocalizations.of(context).deleteUserQuestion,
                        onConfirm: controller.deleteUserPressed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
