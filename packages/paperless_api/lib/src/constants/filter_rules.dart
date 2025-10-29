import 'package:paperless_api/generated/lib/src/model/rule_type_enum.dart';

const RuleTypeEnum titleRule = RuleTypeEnum.number0;
const RuleTypeEnum asnRule = RuleTypeEnum.number2;
const RuleTypeEnum correspondentRule = RuleTypeEnum.number3;
const RuleTypeEnum documentTypeRule = RuleTypeEnum.number4;
const RuleTypeEnum includeTagsRule = RuleTypeEnum.number6;
const RuleTypeEnum hasAnyTag =
    RuleTypeEnum.number7; // true = any tag, false = not assigned
const RuleTypeEnum createdBeforeRule = RuleTypeEnum.number8;
const RuleTypeEnum createdAfterRule = RuleTypeEnum.number9;
const RuleTypeEnum addedBeforeRule = RuleTypeEnum.number13;
const RuleTypeEnum addedAfterRule = RuleTypeEnum.number14;
const RuleTypeEnum modifiedBeforeRule = RuleTypeEnum.number15;
const RuleTypeEnum modifiedAfterRule = RuleTypeEnum.number16;
const RuleTypeEnum excludeTagsRule = RuleTypeEnum.number17;
const RuleTypeEnum titleAndContentRule = RuleTypeEnum.number19;
const RuleTypeEnum extendedRule = RuleTypeEnum.number20;
const RuleTypeEnum storagePathRule = RuleTypeEnum.number25;
// Currently unsupported rules
const RuleTypeEnum _content = RuleTypeEnum.number1;
const RuleTypeEnum _isInInbox = RuleTypeEnum.number5;
const RuleTypeEnum _createdYearIs = RuleTypeEnum.number10;
const RuleTypeEnum _createdMonthIs = RuleTypeEnum.number11;
const RuleTypeEnum _createdDayIs = RuleTypeEnum.number12;
const RuleTypeEnum _doesNotHaveAsn = RuleTypeEnum.number18;
const RuleTypeEnum _moreLikeThis = RuleTypeEnum.number21;
const RuleTypeEnum _hasTagsIn = RuleTypeEnum.number22;
const RuleTypeEnum _asnGreaterThan = RuleTypeEnum.number23;
const RuleTypeEnum _asnLessThan = RuleTypeEnum.number24;

const String lastNDateRangeQueryRegex =
    r"(?<field>created|added|modified):\[-?(?<n>\d+) (?<unit>day|week|month|year) to now\]";
