import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/tasks/tasks_view.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'model/matrix_todo_list.dart';

class TasksPage extends StatefulWidget {
  final Room room;
  const TasksPage({required this.room, super.key});

  @override
  State<TasksPage> createState() => TasksController();
}

class TasksController extends State<TasksPage> {
  bool isLoading = false;
  DateTime? newTaskDateTime;
  String? newTaskDescription;

  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  List<MatrixTodo>? _tmpTodos;

  List<MatrixTodo> get todos => _tmpTodos ?? widget.room.matrixTodos ?? [];

  Stream get onUpdate => widget.room.client.onSync.stream.where(
        (syncUpdate) =>
            syncUpdate.rooms?.join?[widget.room.id]?.state
                ?.any((event) => event.type == MatrixTodoExtension.stateKey) ??
            false,
      );

  void setNewTaskDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: now.subtract(const Duration(days: 365 * 100)),
      lastDate: now.add(const Duration(days: 365 * 100)),
    );
    if (date == null) return;
    setState(() {
      newTaskDateTime = date;
    });
  }

  void setNewTaskDescription() async {
    final text = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.addDescription,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.addDescription,
          maxLength: 512,
          minLines: 4,
          maxLines: 8,
        ),
      ],
    );
    if (text == null || text.single.isEmpty) return;
    setState(() {
      newTaskDescription = text.single;
    });
  }

  void addTodo([_]) {
    if (textEditingController.text.isEmpty) return;
    updateTodos(
      update: (todos) => [
        ...todos,
        MatrixTodo(
          title: textEditingController.text,
          dueDate: newTaskDateTime,
          description: newTaskDescription,
        ),
      ],
      onSuccess: () {
        newTaskDateTime = null;
        newTaskDescription = null;
        textEditingController.clear();
        focusNode.requestFocus();
      },
    );
  }

  void toggleDone(int i) => updateTodos(
        update: (todos) {
          todos[i].done = !todos[i].done;
          return todos;
        },
      );

  void cleanUp() => updateTodos(
        update: (todos) => todos..removeWhere((t) => t.done),
      );

  void onReorder(int oldindex, int newindex) => updateTodos(
        update: (todos) {
          if (newindex > oldindex) {
            newindex -= 1;
          }
          final todo = todos.removeAt(oldindex);
          todos.insert(newindex, todo);

          return todos;
        },
        tmpTodo: true,
      );

  void updateTodos({
    required List<MatrixTodo> Function(List<MatrixTodo>) update,
    void Function()? onSuccess,
    bool tmpTodo = false,
  }) async {
    setState(() {
      isLoading = true;
    });
    try {
      final newTodos = update(todos);
      if (tmpTodo) {
        setState(() {
          _tmpTodos = newTodos;
        });
        onUpdate.first.then((_) {
          _tmpTodos = null;
        });
      }
      await widget.room.updateMatrixTodos(newTodos);
      onSuccess?.call();
    } on MatrixException catch (e) {
      if (e.error != MatrixError.M_LIMIT_EXCEEDED) rethrow;
      Logs().w('Rate limit! Try again in ${e.raw['retry_after_ms']}ms');
      await Future.delayed(
        Duration(milliseconds: e.raw['retry_after_ms'] as int),
      );
      updateTodos(update: update, onSuccess: onSuccess);
    } catch (e, s) {
      Logs().w('Unable to toggle done', e, s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 20),
          content: Row(
            children: [
              Icon(
                Icons.signal_wifi_connected_no_internet_4_outlined,
                color: Theme.of(context).colorScheme.background,
              ),
              const SizedBox(width: 16),
              Text(e.toLocalizedString(context)),
            ],
          ),
          action: e is TodoListChangedException
              ? null
              : SnackBarAction(
                  label: 'Try again',
                  onPressed: () {
                    updateTodos(update: update, onSuccess: onSuccess);
                  },
                ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void editTodo(int i, MatrixTodo todo) async {
    final texts = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.editTodo,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.newTodo,
          initialText: todo.title,
          maxLength: 64,
          validator: (text) {
            if (text == null) return L10n.of(context)!.pleaseAddATitle;
            return null;
          },
        ),
        DialogTextField(
          hintText: L10n.of(context)!.addDescription,
          maxLength: 512,
          minLines: 4,
          maxLines: 8,
          initialText: todo.description,
        ),
      ],
    );
    if (texts == null) return;
    updateTodos(
      update: (todos) {
        if (todos[i].toJson().toString() != todo.toJson().toString()) {
          throw TodoListChangedException();
        }
        todos[i].title = texts[0];
        todos[i].description = texts[1].isEmpty ? null : texts[1];
        return todos;
      },
    );
  }

  void editTodoDueDate(int i, MatrixTodo todo) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: todo.dueDate ?? DateTime.now(),
      firstDate: now.subtract(const Duration(days: 365 * 100)),
      lastDate: now.add(const Duration(days: 365 * 100)),
    );
    if (date == null) return;
    updateTodos(
      update: (todos) {
        if (todos[i].toJson().toString() != todo.toJson().toString()) {
          throw TodoListChangedException();
        }
        todos[i].dueDate = date;
        return todos;
      },
    );
  }

  @override
  Widget build(BuildContext context) => TasksView(this);
}

class TodoListChangedException implements Exception {}
