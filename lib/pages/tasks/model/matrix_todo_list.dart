import 'package:matrix/matrix.dart';

extension MatrixTodoExtension on Room {
  static const String stateKey = 'im.fluffychat.matrix_todos';
  static const String contentKey = 'todos';

  List<MatrixTodo>? get matrixTodos => getState(stateKey)
      ?.content
      .tryGetList(contentKey)
      ?.map((json) => MatrixTodo.fromJson(json))
      .toList();

  Future<void> updateMatrixTodos(List<MatrixTodo> matrixTodos) =>
      client.setRoomStateWithKey(
        id,
        stateKey,
        '',
        {contentKey: matrixTodos.map((todo) => todo.toJson()).toList()},
      );
}

class MatrixTodo {
  String title;
  String? description;
  DateTime? dueDate;
  bool done;
  List<MatrixTodo>? subTasks;

  MatrixTodo({
    required this.title,
    this.description,
    this.dueDate,
    this.done = false,
    this.subTasks,
  });

  factory MatrixTodo.fromJson(Map<String, Object?> json) => MatrixTodo(
        title: json['title'] as String,
        description: json['description'] as String?,
        dueDate: json['due_date'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['due_date'] as int),
        done: json['done'] as bool,
        subTasks: json['sub_tasks'] == null
            ? null
            : (json['sub_tasks'] as List)
                .map((json) => MatrixTodo.fromJson(json))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        if (dueDate != null) 'due_date': dueDate?.millisecondsSinceEpoch,
        'done': done,
        if (subTasks != null)
          'sub_tasks': subTasks?.map((t) => t.toJson()).toList(),
      };
}
