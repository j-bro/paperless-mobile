import 'package:freezed_annotation/freezed_annotation.dart';

part 'actor.freezed.dart';
part 'actor.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class Actor with _$Actor {
  factory Actor({required int id, required String username}) = _Actor;

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
}
