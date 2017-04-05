component extends="Base" output=false {

	/**
	 * Map database types to the ones used in CFML.
	 */
	public string function $getType(required string type) {
		switch (arguments.type) {
			case "bigint":
				local.rv = "cf_sql_bigint";
				break;
			case "binary": case "geometry": case "point": case "linestring": case "polygon": case "multipoint": case "multilinestring": case "multipolygon": case "geometrycollection":
				local.rv = "cf_sql_binary";
				break;
			case "bit": case "bool":
				local.rv = "cf_sql_bit";
				break;
			case "blob": case "tinyblob": case "mediumblob": case "longblob":
				local.rv = "cf_sql_blob";
				break;
			case "char":
				local.rv = "cf_sql_char";
				break;
			case "date":
				local.rv = "cf_sql_date";
				break;
			case "decimal":
				local.rv = "cf_sql_decimal";
				break;
			case "double":
				local.rv = "cf_sql_double";
				break;
			case "float":
				local.rv = "cf_sql_float";
				break;
			case "int": case "mediumint":
				local.rv = "cf_sql_integer";
				break;
			case "smallint": case "year":
				local.rv = "cf_sql_smallint";
				break;
			case "time":
				local.rv = "cf_sql_time";
				break;
			case "datetime": case "timestamp":
				local.rv = "cf_sql_timestamp";
				break;
			case "tinyint":
				local.rv = "cf_sql_tinyint";
				break;
			case "varbinary":
				local.rv = "cf_sql_varbinary";
				break;
			case "varchar": case "text": case "mediumtext": case "longtext": case "tinytext": case "enum": case "set":
				local.rv = "cf_sql_varchar";
				break;
		}
		return local.rv;
	}

	/**
	 * Call functions to make adapter specific changes to arguments before executing query.
	 */
	public struct function $querySetup(
	  required array sql,
	  numeric limit=0,
	  numeric offset=0,
	  required boolean parameterize,
	  string $primaryKey=""
	) {
		$convertMaxRowsToLimit(args=arguments);
		$removeColumnAliasesInOrderClause(args=arguments);
		$moveAggregateToHaving(args=arguments);
		return $performQuery(argumentCollection=arguments);
	}

	/**
	 * Override Base adapter's function.
	 */
	public string function $defaultValues() {
		return "() VALUES()";
	}

	include "../../plugins/standalone/injection.cfm";
}
