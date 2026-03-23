import 'package:freezed_annotation/freezed_annotation.dart';

part 'correspondent_permissions_view.freezed.dart';
part 'correspondent_permissions_view.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class CorrespondentPermissionsView
    with _$CorrespondentPermissionsView {
  factory CorrespondentPermissionsView({List<int>? users, List<int>? groups}) =
      _CorrespondentPermissionsView;

  factory CorrespondentPermissionsView.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentPermissionsViewFromJson(json);
}
