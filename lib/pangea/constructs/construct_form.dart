import 'package:fluffychat/pangea/constructs/construct_identifier.dart';

class ConstructForm {
  String form;
  ConstructIdentifier cId;

  ConstructForm(
    this.form,
    this.cId,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConstructForm && other.form == form && other.cId == cId;
  }

  @override
  int get hashCode => form.hashCode ^ cId.hashCode;
}
