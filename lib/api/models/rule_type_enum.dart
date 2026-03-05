//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum RuleTypeEnum {
  @JsonValue(0)
  titleContains('0'),

  @JsonValue(1)
  contentContains('1'),

  @JsonValue(2)
  asnIs('2'),

  @JsonValue(3)
  correspondentIs('3'),

  @JsonValue(4)
  documentTypeIs('4'),

  @JsonValue(5)
  isInInbox('5'),

  @JsonValue(6)
  hasTag('6'),

  @JsonValue(7)
  hasAnyTag('7'),

  @JsonValue(8)
  createdBefore('8'),

  @JsonValue(9)
  createdAfter('9'),

  @JsonValue(10)
  createdYearIs('10'),

  @JsonValue(11)
  createdMonthIs('11'),

  @JsonValue(12)
  createdDayIs('12'),

  @JsonValue(13)
  addedBefore('13'),

  @JsonValue(14)
  addedAfter('14'),

  @JsonValue(15)
  modifiedBefore('15'),

  @JsonValue(16)
  modifiedAfter('16'),

  @JsonValue(17)
  doesNotHaveTag('17'),

  @JsonValue(18)
  doesNotHaveAsn('18'),

  @JsonValue(19)
  titleOrContentContains('19'),

  @JsonValue(20)
  fulltextQuery('20'),

  @JsonValue(21)
  moreLikeThis('21'),

  @JsonValue(22)
  hasTagsIn('22'),

  @JsonValue(23)
  asnGreaterThan('23'),

  @JsonValue(24)
  asnLessThan('24'),

  @JsonValue(25)
  storagePathIs('25'),

  @JsonValue(26)
  hasCorrespondentIn('26'),

  @JsonValue(27)
  doesNotHaveCorrespondentIn('27'),

  @JsonValue(28)
  hasDocumentTypeIn('28'),

  @JsonValue(29)
  doesNotHaveDocumentTypeIn('29'),

  @JsonValue(30)
  hasStoragePathIn('30'),

  @JsonValue(31)
  doesNotHaveStoragePathIn('31'),

  @JsonValue(32)
  ownerIs('32'),

  @JsonValue(33)
  hasOwnerIn('33'),

  @JsonValue(34)
  doesNotHaveOwner('34'),

  @JsonValue(35)
  doesNotHaveOwnerIn('35'),

  @JsonValue(36)
  hasCustomFieldValue('36'),

  @JsonValue(37)
  isSharedByMe('37'),

  @JsonValue(38)
  hasCustomFields('38'),

  @JsonValue(39)
  hasCustomFieldIn('39'),

  @JsonValue(40)
  doesNotHaveCustomFieldIn('40'),

  @JsonValue(41)
  doesNotHaveCustomField('41'),

  @JsonValue(42)
  customFieldsQuery('42'),

  @JsonValue(43)
  createdTo('43'),

  @JsonValue(44)
  createdFrom('44'),

  @JsonValue(45)
  addedTo('45'),

  @JsonValue(46)
  addedFrom('46'),

  @JsonValue(47)
  mimeTypeIs('47');

  const RuleTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
