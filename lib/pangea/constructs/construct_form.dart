import 'package:fluffychat/pangea/constructs/construct_identifier.dart';

class ConstructForm {
  /// Form of the construct
  final String form;

  /// The constructIdenfifier
  final ConstructIdentifier cId;

  ConstructForm({
    required this.form,
    required this.cId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConstructForm && other.form == form && other.cId == cId;
  }

  @override
  int get hashCode => form.hashCode ^ cId.hashCode;

  factory ConstructForm.fromJson(Map<String, dynamic> json) {
    return ConstructForm(
      form: json['form'],
      cId: ConstructIdentifier.fromJson(json['cId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form': form,
      'cId': cId.toJson(),
    };
  }
}
