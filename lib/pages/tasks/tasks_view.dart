import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/tasks/tasks.dart';

class TasksView extends StatelessWidget {
  final TasksController controller;
  const TasksView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    return StreamBuilder<Object>(
      stream: controller.widget.room.onUpdate.stream,
      builder: (context, snapshot) {
        final list = controller.todos;
        return Scaffold(
          appBar: AppBar(
            title: Text(L10n.of(context)!.todoLists),
            actions: [
              AnimatedCrossFade(
                duration: FluffyThemes.animationDuration,
                firstChild: const SizedBox(
                  width: 32,
                  height: 32,
                ),
                secondChild: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  ),
                ),
                crossFadeState: controller.isLoading
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
              if (list.any((todo) => todo.done))
                IconButton(
                  icon: const Icon(Icons.cleaning_services_outlined),
                  onPressed: controller.cleanUp,
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Opacity(
                  opacity: controller.isLoading ? 0.66 : 1,
                  child: list.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 80,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 256,
                              child: Text(
                                L10n.of(context)!.noTodosYet,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 256,
                              child: Text(
                                L10n.of(context)!.todosUnencrypted,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        )
                      : ReorderableListView.builder(
                          onReorder: controller.onReorder,
                          itemCount: list.length,
                          buildDefaultDragHandles: false,
                          itemBuilder: (context, i) {
                            final todo = list[i];
                            final description = todo.description;
                            final dueDate = todo.dueDate;
                            return ListTile(
                              key: Key(todo.toJson().toString()),
                              leading: Icon(
                                todo.done
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                              ),
                              title: Text(
                                todo.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  decoration: todo.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: description == null && dueDate == null
                                  ? null
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (description != null)
                                          Text(
                                            description,
                                            maxLines: 2,
                                          ),
                                        if (dueDate != null)
                                          SizedBox(
                                            height: 24,
                                            child: OutlinedButton.icon(
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.calendar_month,
                                                size: 16,
                                              ),
                                              label: Text(
                                                DateFormat.yMMMd(tag)
                                                    .format(dueDate),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  controller.editTodoDueDate(
                                                i,
                                                todo,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                              onTap: controller.isLoading
                                  ? null
                                  : () => controller.toggleDone(i),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 16,
                                    ),
                                    onPressed: () =>
                                        controller.editTodo(i, todo),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outlined,
                                      size: 16,
                                    ),
                                    onPressed: () => controller.deleteTodo(i),
                                  ),
                                  ReorderableDragStartListener(
                                    index: i,
                                    child:
                                        const Icon(Icons.drag_handle_outlined),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  focusNode: controller.focusNode,
                  readOnly: controller.isLoading,
                  controller: controller.textEditingController,
                  onSubmitted: controller.addTodo,
                  maxLength: 64,
                  decoration: InputDecoration(
                    counterStyle: const TextStyle(height: double.minPositive),
                    counterText: '',
                    hintText: L10n.of(context)!.newTodo,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            controller.newTaskDateTime == null
                                ? Icons.calendar_month_outlined
                                : Icons.calendar_month,
                            color: controller.newTaskDateTime == null
                                ? null
                                : Theme.of(context).primaryColor,
                          ),
                          onPressed: controller.setNewTaskDateTime,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.text_fields,
                            color: controller.newTaskDescription == null
                                ? null
                                : Theme.of(context).primaryColor,
                          ),
                          onPressed: controller.setNewTaskDescription,
                        ),
                      ],
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_outlined),
                      onPressed:
                          controller.isLoading ? null : controller.addTodo,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
