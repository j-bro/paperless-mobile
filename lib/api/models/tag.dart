// //
// // AUTO-GENERATED FILE, DO NOT MODIFY!
// //

// // ignore_for_file: unused_element
// import 'package:paperless_mobile/api/models/matching_algorithm.dart';
// import 'package:copy_with_extension/copy_with_extension.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:equatable/src/equatable_utils.dart';

// part 'tag.g.dart';

// @CopyWith()
// @JsonSerializable(
//   checked: true,
//   createToJson: true,
//   disallowUnrecognizedKeys: false,
//   explicitToJson: true,
// )
// class Tag {
//   /// Returns a new [Tag] instance.
//   Tag({
//     required this.id,

//     required this.slug,

//     required this.name,

//     this.color,

//     required this.textColor,

//     this.match,

//     this.matchingAlgorithm,

//     this.isInsensitive,

//     this.isInboxTag,

//     required this.documentCount,

//     this.owner,

//     required this.userCanChange,
//   });

//   @JsonKey(name: r'id', required: true, includeIfNull: false)
//   final int id;

//   @JsonKey(name: r'slug', required: true, includeIfNull: false)
//   final String slug;

//   @JsonKey(name: r'name', required: true, includeIfNull: false)
//   final String name;

//   @JsonKey(name: r'color', required: false, includeIfNull: false)
//   final String? color;

//   @JsonKey(name: r'text_color', required: true, includeIfNull: false)
//   final String textColor;

//   @JsonKey(name: r'match', required: false, includeIfNull: false)
//   final String? match;

//   // minimum: 0.0
//   // maximum: 2.147483647E9
//   @JsonKey(name: r'matching_algorithm', required: false, includeIfNull: false)
//   final MatchingAlgorithm? matchingAlgorithm;

//   @JsonKey(name: r'is_insensitive', required: false, includeIfNull: false)
//   final bool? isInsensitive;

//   /// Marks this tag as an inbox tag: All newly consumed documents will be tagged with inbox tags.
//   @JsonKey(name: r'is_inbox_tag', required: false, includeIfNull: false)
//   final bool? isInboxTag;

//   @JsonKey(name: r'document_count', required: true, includeIfNull: false)
//   final int documentCount;

//   @JsonKey(name: r'owner', required: false, includeIfNull: false)
//   final int? owner;

//   @JsonKey(name: r'user_can_change', required: true, includeIfNull: false)
//   final bool userCanChange;

//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         other is Tag &&
//             runtimeType == other.runtimeType &&
//             equals(
//               [
//                 id,
//                 slug,
//                 name,
//                 color,
//                 textColor,
//                 match,
//                 matchingAlgorithm,
//                 isInsensitive,
//                 isInboxTag,
//                 documentCount,
//                 owner,
//                 userCanChange,
//               ],
//               [
//                 other.id,
//                 other.slug,
//                 other.name,
//                 other.color,
//                 other.textColor,
//                 other.match,
//                 other.matchingAlgorithm,
//                 other.isInsensitive,
//                 other.isInboxTag,
//                 other.documentCount,
//                 other.owner,
//                 other.userCanChange,
//               ],
//             );
//   }

//   @override
//   int get hashCode =>
//       runtimeType.hashCode ^
//       mapPropsToHashCode([
//         id,
//         slug,
//         name,
//         color,
//         textColor,
//         match,
//         matchingAlgorithm,
//         isInsensitive,
//         isInboxTag,
//         documentCount,
//         owner,
//         userCanChange,
//       ]);

//   factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

//   Map<String, dynamic> toJson() => _$TagToJson(this);

//   @override
//   String toString() {
//     return toJson().toString();
//   }
// }
