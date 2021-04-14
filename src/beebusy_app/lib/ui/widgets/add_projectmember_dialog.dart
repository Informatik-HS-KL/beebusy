import 'package:beebusy_app/controller/add_teammember_controller.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTeamMemberDialog extends GetView<AddTeammemberController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BrownText(
              AppLocalizations.of(context).addTeamMembersLabel,
              isBold: true,
            ),
            Flexible(
              child: TeamMemberListView(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyFlatButton(
                  buttonText: AppLocalizations.of(context).cancelButton,
                  onPressed: () => Get.back<void>(),
                ),
                const SizedBox(
                  width: 30,
                ),
                MyRaisedButton(
                  buttonText: AppLocalizations.of(context).addButton,
                  onPressed: () {
                    controller.submit();
                    Get.back<void>();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TeamMemberListView extends GetView<AddTeammemberController> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scrollbar(
        key: ValueKey<int>(controller.userList.length),
        controller: _scrollController,
        isAlwaysShown: true,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: controller.userList.length,
          itemBuilder: (BuildContext context, int index) {
            final User currentUser = controller.userList[index];
            return ListTile(
              title: Center(
                  child: BrownText(
                      '${currentUser.firstname} ${currentUser.lastname}')),
              selectedTileColor: Theme.of(context).selectedRowColor,
              selected: controller.isSelected(currentUser.userId),
              onTap: () {
                if (controller.isSelected(currentUser.userId)) {
                  controller.removeProjectMember(currentUser.userId);
                } else {
                  controller.addProjectMember(currentUser.userId);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
