import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BoardNavigation extends GetView<BoardController> {
  const BoardNavigation({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
          ),
          child: Obx(
            () => Column(
              children: <Widget>[
                ListTile(
                  onTap: controller.selectBoard,
                  title: Center(
                    child: BrownText(AppLocalizations.of(context).boardLabel),
                  ),
                  selected: controller.currentRoute.value == BoardPage.route,
                  selectedTileColor: Theme.of(context).selectedRowColor,
                ),
                ListTile(
                  onTap: controller.selectSettings,
                  title: Center(
                    child:
                        BrownText(AppLocalizations.of(context).settingsLabel),
                  ),
                  selected: controller.currentRoute.value == SettingsPage.route,
                  selectedTileColor: Theme.of(context).selectedRowColor,
                ),
              ],
            ),
          ),
        ),
        if (child != null) Expanded(child: child),
      ],
    );
  }
}
