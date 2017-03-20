<cfscript>

/**
* Builds and returns a string containing three select form controls (month, day, and year) based on a name and value.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected See documentation for [doc:selectTag].
* @order See documentation for [doc:dateSelect].
* @separator See documentation for [doc:dateSelect].
* @startYear See documentation for [doc:dateSelect].
* @endYear See documentation for [doc:dateSelect].
* @monthDisplay See documentation for [doc:dateSelect].
* @monthNames See documentation for [doc:dateSelect].
* @monthAbbreviations See documentation for [doc:dateSelect].
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:dateSelect].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
* @combine See documentation for [doc:dateSelect].
*/
public string function dateSelectTags(
	required string name,
	string selected="",
	string order,
	string separator,
	numeric startYear,
	numeric endYear,
	string monthDisplay,
	string monthNames,
	string monthAbbreviations,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	boolean combine,
	date $now=Now()
) {
	$args(name="dateSelectTags", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = arguments.selected;
	StructDelete(arguments, "name");
	StructDelete(arguments, "selected");
	arguments.$functionName = "dateSelectTag";
	return $dateOrTimeSelect(argumentCollection=arguments);
}

/**
* Builds and returns a string containing three select form controls for hour, minute, and second based on name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected See documentation for [doc:selectTag].
* @order See documentation for [doc:timeSelect].
* @separator See documentation for [doc:timeSelect].
* @minuteStep See documentation for [doc:timeSelect].
* @secondStep See documentation for [doc:timeSelect].
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:dateSelect].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
* @combine See documentation for [doc:dateSelect].
* @twelveHour See documentation for [doc:timeSelect].
*/
public string function timeSelectTags(
	required string name,
	string selected="",
	string order,
	string separator,
	numeric minuteStep,
	numeric secondStep,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	boolean combine,
	boolean twelveHour
) {
	$args(name="timeSelectTags", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = arguments.selected;
	StructDelete(arguments, "name");
	StructDelete(arguments, "selected");
	arguments.$functionName = "timeSelectTag";
	return $dateOrTimeSelect(argumentCollection=arguments);
}

/**
* Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection) based on a name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected See documentation for [doc:selectTag].
* @dateOrder See documentation for [doc:dateTimeSelect].
* @dateSeparator See documentation for [doc:dateTimeSelect].
* @startYear See documentation for [doc:dateSelect].
* @endYear See documentation for [doc:dateSelect].
* @monthDisplay See documentation for [doc:dateSelect].
* @monthNames See documentation for [doc:dateSelect].
* @monthAbbreviations See documentation for [doc:dateSelect].
* @timeOrder See documentation for [doc:dateTimeSelect].
* @timeSeparator See documentation for [doc:dateTimeSelect].
* @minuteStep See documentation for [doc:timeSelect].
* @secondStep See documentation for [doc:timeSelect].
* @separator See documentation for [doc:dateTimeSelect].
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:dateSelect].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
* @combine See documentation for [doc:dateSelect].
* @twelveHour See documentation for [doc:timeSelect].
*/
public string function dateTimeSelectTags(
	required string name,
	string selected="",
	string dateOrder,
	string dateSeparator,
	numeric startYear,
	numeric endYear,
	string monthDisplay,
	string monthNames,
	string monthAbbreviations,
	string timeOrder,
	string timeSeparator,
	numeric minuteStep,
	numeric secondStep,
	string separator,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	boolean combine,
	boolean twelveHour
) {
	$args(name="dateTimeSelectTags", args=arguments);
	local.rv = "";
	local.separator = arguments.separator;
	local.label = arguments.label;

	// create date portion
	arguments.order = arguments.dateOrder;
	arguments.separator = arguments.dateSeparator;
	// when a list of 6 elements has been passed in as labels we assume the first 3 are meant to be placed on the date related tags
	if (ListLen(local.label) == 6) {
		arguments.label = ListGetAt(local.label, 1) & "," & ListGetAt(local.label, 2) & "," & ListGetAt(local.label, 3);
	}
	if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect") {
		local.rv &= dateSelect(argumentCollection=arguments);
	} else {
		local.rv &= dateSelectTags(argumentCollection=arguments);
	}

	// separate date and time with a string ("-" by default)
	local.rv &= local.separator;

	// create time portion
	arguments.order = arguments.timeOrder;
	arguments.separator = arguments.timeSeparator;
	// when a list of 6 elements has been passed in as labels we assume the last 3 are meant to be placed on the time related tags
	if (ListLen(local.label) == 6) {
		arguments.label = ListGetAt(local.label, 4) & "," & ListGetAt(local.label, 5) & "," & ListGetAt(local.label, 6);
	}
	if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect") {
		local.rv &= timeSelect(argumentCollection=arguments);
	} else {
		local.rv &= timeSelectTags(argumentCollection=arguments);
	}
	return local.rv;
}

/**
* Builds and returns a string containing a select form control for a range of years based on the supplied name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected The year that should be selected initially.
* @startYear See documentation for [doc:dateSelect].
* @endYear See documentation for [doc:dateSelect].
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:textField].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
*/
public string function yearSelectTag(
	required string name,
	string selected="",
	numeric startYear,
	numeric endYear,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	date $now=now()
) {
	$args(name="yearSelectTag", args=arguments);
	if (IsNumeric(arguments.selected)) {
		arguments.selected = $dateForSelectTags("year", arguments.selected, arguments.$now);
	}
	arguments.order = "year";
	return dateSelectTags(argumentCollection=arguments);
}

/**
* Builds and returns a string containing a select form control for the months of the year based on the supplied name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected The month that should be selected initially.
* @monthDisplay See documentation for [doc:dateSelect].
* @monthNames See documentation for [doc:dateSelect].
* @monthAbbreviations See documentation for [doc:dateSelect].
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:textField].
* @labelPlacement around See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
*/
public string function monthSelectTag(
	required string name,
	string selected="",
	string monthDisplay,
	string monthNames,
	string monthAbbreviations,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	date $now=now()
) {
	$args(name="monthSelectTag", args=arguments);
	if (IsNumeric(arguments.selected) && IsValid("range", arguments.selected, 0, 12)) {
		arguments.selected = $dateForSelectTags("month", arguments.selected, arguments.$now);
	}
	arguments.order = "month";
	return dateSelectTags(argumentCollection=arguments);
}

/**
* Builds and returns a string containing a select form control for the days of the week based on the supplied name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected The day that should be selected initially.
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:textField].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
*/
public string function daySelectTag(
	required string name,
	string selected="",
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	date $now=now()
) {
	$args(name="daySelectTag", args=arguments);
	if (IsNumeric(arguments.selected) && IsValid("range", arguments.selected, 0, 31)) {
		arguments.selected = $dateForSelectTags("day", arguments.selected, arguments.$now);
	}
	arguments.order = "day";
	return dateSelectTags(argumentCollection=arguments);
}

/**
* Builds and returns a string containing one select form control for the hours of the day based on the supplied name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected The day that should be selected initially.
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:textField].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
* @twelveHour See documentation for [doc:timeSelect].
*/
public string function hourSelectTag(
	required string name,
	string selected="",
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	boolean twelveHour,
	date $now=now()
) {
	$args(name="hourSelectTag", args=arguments);
	if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60) {
		arguments.selected = createTime(arguments.selected, Minute(arguments.$now), Second(arguments.$now));
	}
	arguments.order = "hour";
	return timeSelectTags(argumentCollection=arguments);
}

/**
* Builds and returns a string containing one select form control for the minutes of an hour based on the supplied name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected The day that should be selected initially.
* @minuteStep See documentation for [doc:timeSelect].
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:textField].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
*/
public string function minuteSelectTag(
	required string name,
	string selected="",
	numeric minuteStep,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	date $now=now()
) {
	$args(name="minuteSelectTag", args=arguments);
	if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60) {
		arguments.selected = createTime(Hour(arguments.$now), arguments.selected, Second(arguments.$now));
	}
	arguments.order = "minute";
	return timeSelectTags(argumentCollection=arguments);
}

/**
* Builds and returns a string containing one select form control for the seconds of a minute based on the supplied name.
*
* [section: View Helpers]
* [category: Form Tag Functions]
*
* @name See documentation for [doc:textFieldTag].
* @selected The day that should be selected initially.
* @secondStep See documentation for [doc:timeSelect].
* @includeBlank See documentation for [doc:select].
* @label See documentation for [doc:textField].
* @labelPlacement See documentation for [doc:textField].
* @prepend See documentation for [doc:textField].
* @append See documentation for [doc:textField].
* @prependToLabel See documentation for [doc:textField].
* @appendToLabel See documentation for [doc:textField].
*/
public string function secondSelectTag(
	required string name,
	string selected="",
	numeric secondStep,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	date $now=now()
) {
	$args(name="secondSelectTag", args=arguments);
	if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60) {
		arguments.selected = createTime(Hour(arguments.$now), Minute(arguments.$now), arguments.selected);
	}
	arguments.order = "second";
	return timeSelectTags(argumentCollection=arguments);
}

/**
* Internal Function
*/
public date function $dateForSelectTags(
	required string part,
	required numeric value,
	required date $now
) {
	local.year = Year(arguments.$now);
	local.month = Month(arguments.$now);
	local.day = Day(arguments.$now);
	local.rv = arguments.$now;
	switch (arguments.part) {
		case "year":
			local.year = arguments.value;
			break;
		case "month":
			local.month = arguments.value;
			break;
		case "day":
			local.day = arguments.value;
			break;
	}

	// Handle February.
	if (local.month == 2 && ((!IsLeapYear(local.year) && local.day > 29) || (IsLeapYear(local.year) && local.day > 28))) {
		if (IsLeapYear(local.year)) {
			local.day = 29;
		} else {
			local.day = 28;
		}
	}

	try {
		local.rv = CreateDate(local.year, local.month, local.day);
	} catch (any e) {
		local.rv = arguments.$now;
	}
	return local.rv;
}

</cfscript>
