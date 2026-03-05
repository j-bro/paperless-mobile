import 'package:freezed_annotation/freezed_annotation.dart';

part 'asn_query_parameter.freezed.dart';
part 'asn_query_parameter.g.dart';

@freezed
sealed class AsnQueryParameter with _$AsnQueryParameter {
  factory AsnQueryParameter.empty() = EmptyAsnQueryParameter;
  factory AsnQueryParameter.notEmpty() = NotEmptyAsnQueryParameter;
  factory AsnQueryParameter.equals({required int value}) =
      EqualsAsnQueryParameter;
  factory AsnQueryParameter.greaterThan({required int value}) =
      GreaterThanAsnQueryParameter;
  factory AsnQueryParameter.lessThan({required int value}) =
      LessThanAsnQueryParameter;

  factory AsnQueryParameter.fromJson(Map<String, dynamic> json) =>
      _$AsnQueryParameterFromJson(json);
}

extension AsnQueryParameterMethods on AsnQueryParameter {
  Map<String, String> toQueryParameter() {
    return when(
      empty: () => {'asn__isnull': '1'},
      notEmpty: () => {'asn__isnull': '0'},
      equals: (value) => {'asn': value.toString()},
      greaterThan: (value) => {'asn__gt': value.toString()},
      lessThan: (value) => {'asn__lt': value.toString()},
    );
  }
}
