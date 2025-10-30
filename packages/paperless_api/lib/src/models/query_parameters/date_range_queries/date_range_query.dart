import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/src/constants.dart';
import 'package:paperless_api/src/converters/local_date_time_json_converter.dart';

import 'date_range_query_field.dart';
import 'date_range_unit.dart';

part 'date_range_query.g.dart';

sealed class DateRangeQuery with EquatableMixin {
  const DateRangeQuery();

  Map<String, String> toQueryParameter(DateRangeQueryField field);
}

class UnsetDateRangeQuery extends DateRangeQuery {
  const UnsetDateRangeQuery();

  @override
  Map<String, String> toQueryParameter(DateRangeQueryField field) => const {};

  @override
  List<Object?> get props => [];
}

@CopyWith()
@JsonSerializable()
class RelativeDateRangeQuery extends DateRangeQuery {
  final int offset;
  final DateRangeUnit unit;

  const RelativeDateRangeQuery([
    this.offset = 1,
    this.unit = DateRangeUnit.day,
  ]);

  @override
  List<Object?> get props => [offset, unit];

  @override
  Map<String, String> toQueryParameter(DateRangeQueryField field) {
    return {'query': '${field.name}:[-$offset ${unit.name} to now]'};
  }

  /// Returns the datetime when subtracting the offset given the unit from now.
  DateTime get dateTime {
    switch (unit) {
      case DateRangeUnit.day:
        return Jiffy.now().subtract(days: offset).dateTime;
      case DateRangeUnit.week:
        return Jiffy.now().subtract(weeks: offset).dateTime;
      case DateRangeUnit.month:
        return Jiffy.now().subtract(months: offset).dateTime;
      case DateRangeUnit.year:
        return Jiffy.now().subtract(years: offset).dateTime;
    }
  }
}

@CopyWith()
@JsonSerializable()
class AbsoluteDateRangeQuery extends DateRangeQuery {
  @LocalDateTimeJsonConverter()
  final DateTime? after;

  @LocalDateTimeJsonConverter()
  final DateTime? before;

  const AbsoluteDateRangeQuery({this.after, this.before});

  @override
  List<Object?> get props => [after, before];

  @override
  Map<String, String> toQueryParameter(DateRangeQueryField field) {
    final Map<String, String> params = {};

    // Add/subtract one day in the following because paperless uses gt/lt not gte/lte
    if (after != null) {
      params.putIfAbsent(
        '${field.name}__date__gt',
        () => apiDateFormat.format(after!.subtract(const Duration(days: 1))),
      );
    }

    if (before != null) {
      params.putIfAbsent(
        '${field.name}__date__lt',
        () => apiDateFormat.format(before!.add(const Duration(days: 1))),
      );
    }
    return params;
  }
}
