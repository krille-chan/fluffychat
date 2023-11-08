import '../enum/direction.dart';
import '../enum/edit_type.dart';

class TextChangeModel {
  EditType? editType;
  EditDirection? editDirection;
  String? text;

  toJson() =>
      {'editType': editType, 'editDirection': editDirection, 'text': text};
}
