<cfscript>

/**
 * Set certain parameters for future calls.
 *
 * [section: Configuration]
 * [category: Routing]
 *
 * @name Named route prefix.
 * @path Path prefix.
 * @package Package namespace to append to controllers.
 * @controller Controller to use in routes.
 * @shallow Turn on shallow resources.
 * @shallowPath Shallow path prefix.
 * @shallowName Shallow name prefix.
 * @constraints Variable patterns to use for matching.
 */
public struct function scope(
	string name,
	string path,
	string package,
	string controller,
	boolean shallow,
	string shallowPath,
	string shallowName,
	struct constraints,
	string $call="scope"
) {

	// Set shallow path and prefix if not in a resource.
	if (!ListFindNoCase("resource,resources", variables.scopeStack[1].$call)) {
		if (!StructKeyExists(arguments, "shallowPath") && StructKeyExists(arguments, "path")) {
			arguments.shallowPath = arguments.path;
		}
		if (!StructKeyExists(arguments, "shallowName") && StructKeyExists(arguments, "name")) {
			arguments.shallowName = arguments.name;
		}
	}

	// Combine path with scope path.
	if (StructKeyExists(variables.scopeStack[1], "path") && StructKeyExists(arguments, "path")) {
		arguments.path = $normalizePattern(variables.scopeStack[1].path & "/" & arguments.path);
	}

	// Combine package with scope package.
	if (StructKeyExists(variables.scopeStack[1], "package") && StructKeyExists(arguments, "package")) {
		arguments.package = variables.scopeStack[1].package & "." & arguments.package;
	}

	// Combine name with scope name.
	if (StructKeyExists(arguments, "name") && StructKeyExists(variables.scopeStack[1], "name")) {
		arguments.name = variables.scopeStack[1].name & capitalize(arguments.name);
	}

	// Combine shallow path with scope shallow path.
	if (StructKeyExists(variables.scopeStack[1], "shallowPath") && StructKeyExists(arguments, "shallowPath")) {
		arguments.shallowPath = $normalizePattern(variables.scopeStack[1].shallowPath & "/" & arguments.shallowPath);
	}

	// Copy existing constraints if they were previously set.
	if (StructKeyExists(variables.scopeStack[1], "constraints") && StructKeyExists(arguments, "constraints")) {
		StructAppend(arguments.constraints, variables.scopeStack[1].constraints, false);
	}

	// Put scope arguments on the stack.
	StructAppend(arguments, variables.scopeStack[1], false);
	ArrayPrepend(variables.scopeStack, arguments);

	return this;
}

/**
 * [section: Configuration]
 * [category: Routing]
 */
public struct function namespace(
	required string package,
	string name=arguments.package,
	string path=hyphenize(arguments.package)
) {
	return scope(argumentCollection=arguments, $call="namespace");
}

/**
 * Scopes any the controllers for any routes configured within this block to a subfolder (package) without adding the package name to the URL.
 *
 * [section: Configuration]
 * [category: Routing]
 *
 * @name Name to prepend to route name.
 * @package Subfolder to reference for controllers. This defaults to the value provided for `name`.
 */
public struct function package(required string name, string package=arguments.name) {
	return scope(name=arguments.name, package=arguments.package, $call="package");
}

/**
 * [section: Configuration]
 * [category: Routing]
 */
public struct function controller(
	required string controller,
	string name=arguments.controller,
	string path=hyphenize(arguments.controller)
) {
	return scope(argumentCollection=arguments, $call="controller");
}

/**
 * Set variable patterns to use for matching.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function constraints() {
	return scope(constraints=arguments, $call="constraints");
}

</cfscript>
