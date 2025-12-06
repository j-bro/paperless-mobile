import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'id_query_parameter.g.dart';

sealed class IdQueryParameter {
  const IdQueryParameter();

  Map<String, String> toQueryParameter(String field);
  bool matches(int? id);

  bool get isUnset => this is UnsetIdQueryParameter;
  bool get isSet => this is SetIdQueryParameter;
  bool get isOnlyNotAssigned => this is NotAssignedIdQueryParameter;
  bool get isOnlyAssigned => this is AnyAssignedIdQueryParameter;

  factory IdQueryParameter.fromJson(Map<String, dynamic> json) {
    final type = json['__type'] as String?;
    switch (type) {
      case 'UnsetIdQueryParameter':
        return const UnsetIdQueryParameter();
      case 'NotAssignedIdQueryParameter':
        return const NotAssignedIdQueryParameter();
      case 'AnyAssignedIdQueryParameter':
        return const AnyAssignedIdQueryParameter();
      case 'SetIdQueryParameter':
        return SetIdQueryParameter.fromJson(json);
      default:
        throw Exception('Unknown IdQueryParameter type: $type');
    }
  }

  Map<String, dynamic> toJson();
}

class UnsetIdQueryParameter extends IdQueryParameter with EquatableMixin {
  const UnsetIdQueryParameter();
  @override
  Map<String, String> toQueryParameter(String field) => {};

  @override
  bool matches(int? id) => true;

  @override
  Map<String, dynamic> toJson() => {"__type": 'UnsetIdQueryParameter'};

  @override
  List<Object?> get props => [];
}

class NotAssignedIdQueryParameter extends IdQueryParameter with EquatableMixin {
  const NotAssignedIdQueryParameter();

  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__isnull': '1'};
  }

  @override
  List<Object?> get props => [];

  @override
  bool matches(int? id) => id == null;

  @override
  Map<String, dynamic> toJson() => {"__type": 'NotAssignedIdQueryParameter'};
}

class AnyAssignedIdQueryParameter extends IdQueryParameter with EquatableMixin {
  const AnyAssignedIdQueryParameter();
  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__isnull': '0'};
  }

  @override
  List<Object?> get props => [];

  @override
  bool matches(int? id) => id != null;

  @override
  Map<String, dynamic> toJson() => {"__type": 'AnyAssignedIdQueryParameter'};
}

@JsonSerializable(ignoreUnannotated: true)
class SetIdQueryParameter extends IdQueryParameter with EquatableMixin {
  @JsonKey(includeToJson: true, includeFromJson: false)
  final __type = 'SetIdQueryParameter';

  @JsonKey()
  final int id;

  const SetIdQueryParameter({required this.id});

  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__id': '$id'};
  }

  @override
  bool matches(int? id) => id == this.id;

  @override
  List<Object?> get props => [id];

  @override
  Map<String, dynamic> toJson() => _$SetIdQueryParameterToJson(this);
  factory SetIdQueryParameter.fromJson(Map<String, dynamic> json) {
    return _$SetIdQueryParameterFromJson(json);
  }
}
