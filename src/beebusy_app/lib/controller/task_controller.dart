import 'package:async/async.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/service/task_service.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find();

  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoadingTasks = false.obs;
  CancelableOperation<void> loadTasksOperation;

  void refreshTasks(Project project) {
    isLoadingTasks.value = true;
    loadTasksOperation = CancelableOperation<List<Task>>.fromFuture(
      _taskService.getAllProjectTasks(project.projectId)
        ..whenComplete(() => isLoadingTasks.value = false),
    ).then<void>((List<Task> fetchedTasks) {
      tasks.clear();
      tasks.addAll(fetchedTasks);
    });
  }

  void updateStatus(Task task, Status status) {
    _taskService.updateTask(taskId: task.taskId, status: status);
    tasks.removeWhere((Task element) => element.taskId == task.taskId);
    tasks.add(task.rebuild((TaskBuilder b) => b..status = status));
  }

  void deleteTask(int taskId) {
    _taskService.deleteTask(taskId);
    tasks.removeWhere((Task element) => element.taskId == taskId);
  }
}
