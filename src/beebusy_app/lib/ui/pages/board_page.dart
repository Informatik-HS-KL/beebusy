import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_task_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/ui/widgets/add_task_dialog.dart';
import 'package:beebusy_app/ui/widgets/board_navigation.dart';
import 'package:beebusy_app/ui/widgets/no_projects_view.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/task_card.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BoardPage extends GetView<BoardController> {
  static const String route = '/board';

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showActions: true,
      body: Obx(
        () {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.isLoadingUserProjects.value
                ? Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        accentColor: Theme.of(context).colorScheme.onBackground,
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : controller.activeUserProjects.isEmpty
                    ? NoProjectsView()
                    : BoardNavigation(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Obx(
                                () => Container(
                                  width: Get.width,
                                  child: BodyTitle(
                                    title:
                                        controller.selectedProject.value?.name,
                                    trailing:
                                        ' - ${AppLocalizations.of(context).boardLabel}',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Board(),
                              ),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }
}

class Board extends GetView<BoardController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          DragTargetBoardColumn(
            status: Status.todo,
            columnTitle: AppLocalizations.of(context).todoColumnTitle,
            showCreateCardIconButton: true,
          ),
          DragTargetBoardColumn(
            status: Status.inProgress,
            columnTitle: AppLocalizations.of(context).inProgressColumnTitle,
          ),
          DragTargetBoardColumn(
            status: Status.review,
            columnTitle: AppLocalizations.of(context).reviewColumnTitle,
          ),
          DragTargetBoardColumn(
            status: Status.done,
            columnTitle: AppLocalizations.of(context).doneColumnTitle,
          ),
        ],
      ),
    );
  }
}

class DragTargetBoardColumn extends GetView<TaskController> {
  const DragTargetBoardColumn({
    @required this.status,
    @required this.columnTitle,
    this.showCreateCardIconButton = false,
  });

  final Status status;
  final String columnTitle;
  final bool showCreateCardIconButton;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Task>(
      onWillAccept: (Task data) => data.status != status,
      onAccept: (Task data) {
        controller.updateStatus(data, status);
      },
      builder: (
        BuildContext context,
        List<Task> candidateData,
        List<dynamic> rejectedData,
      ) {
        return Container(
          width: (MediaQuery.of(context).size.width - 200) / 4 - 25,
          color: Theme.of(context).hoverColor,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BoardColumn(
                status: status,
                columnTitle: columnTitle,
                showCreateCardIconButton: showCreateCardIconButton,
              ),
              if (candidateData.isNotEmpty)
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
            ],
          ),
        );
      },
    );
  }
}

class BoardColumn extends GetView<BoardController> {
  const BoardColumn({
    @required this.status,
    @required this.columnTitle,
    this.showCreateCardIconButton = false,
  });

  final Status status;
  final String columnTitle;
  final bool showCreateCardIconButton;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BrownText(columnTitle, isBold: true),
              if (showCreateCardIconButton)
                SizedBox(
                  height: 14,
                  child: IconButton(
                    padding: const EdgeInsets.all(0.0),
                    icon: const Icon(Icons.add),
                    iconSize: 14,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (BuildContext context) =>
                          GetBuilder<CreateTaskController>(
                        init: CreateTaskController(),
                        builder: (_) => AddTaskDialog(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => Scrollbar(
              key: ValueKey<int>(controller.tasks.length),
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                controller: _scrollController,
                children: controller.tasks
                    .where((Task task) => task.status == status)
                    .map((Task task) => DraggableTaskCard(task: task))
                    .toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
