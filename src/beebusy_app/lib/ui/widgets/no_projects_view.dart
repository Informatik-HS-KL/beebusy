import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/ui/widgets/add_project_dialog.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const Spacer(flex: 5),
          Container(
            child: Icon(
              Icons.android_sharp,
              color: Theme.of(context).hintColor,
              size: 200,
            ),
          ),
          const Spacer(flex: 2),
          BrownText(AppLocalizations.of(context).noProjectsMessage),
          MyRaisedButton(
            buttonText: AppLocalizations.of(context).createProjectTitle,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) => GetBuilder<CreateProjectController>(
                init: CreateProjectController(),
                builder: (_) => AddProjectDialog(),
              ),
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
