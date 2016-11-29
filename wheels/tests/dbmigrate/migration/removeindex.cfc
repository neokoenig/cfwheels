component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_removeIndex_removes_an_index() {
		tableName = "dbm_removeindex_tests";
		indexName = "idx_to_remove";
		t = migration.createTable(name=tableName, force=true);
		t.integer(columnNames="integercolumn");
		t.create();

		migration.addIndex(table=tableName, columnNames='integercolumn', indexName=indexName);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="index"
		);
		if(application.wheels.serverName == 'Adobe ColdFusion' && listFirst(application.wheels.serverVersion) == '10'){
			sql="SELECT * FROM query WHERE index_name = '#indexName#'";
			sql2="SELECT * FROM query WHERE index_name = '#indexName#'";
		} else {
			sql="SELECT * FROM query WHERE index_name = '#ucase(indexName)#'";
			sql2="SELECT * FROM query WHERE index_name = '#ucase(indexName)#'";
		}
		created = $query(query=info, dbtype="query", sql=sql);

		migration.removeIndex(table=tableName, indexName=indexName);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="index"
		);
		removed = $query(query=info, dbtype="query", sql=sql2);

		migration.dropTable(tableName);
	    assert("created.recordCount eq 1");
		assert("removed.recordCount eq 0");
	}
}
