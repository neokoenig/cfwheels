<cfscript>
application.wheels.controllerPath = "wheels/tests/_assets/controllers";
application.wheels.modelPath = "/wheelsMapping/tests/_assets/models";
application.wheels.modelComponentPath = "wheels.tests._assets.models";
application.wheels.dataSourceName = "wheelstestdb";

/* turn off default validations for testing */
application.wheels.automaticValidations = false;
application.wheels.assetQueryString = false;
application.wheels.assetPaths = false;

/* redirections should always delay when testing */
application.wheels.functions.redirectTo.delay = true;

/* turn off transactions by default */
application.wheels.transactionMode = "none";

/* turn off request query caching */
application.wheels.cacheQueriesDuringRequest = false;

/* Test suite specific flags */

// Is this ACF10?
application.testenv.isACF10=false;
if(application.wheels.serverName == 'Adobe ColdFusion' && listFirst(application.wheels.serverVersion) == '10'){
	application.testenv.isACF10=false;
}

// Is this Oracle?
application.testenv.isOracle=false;
application.testenv.db=$dbinfo(datasource=application.wheels.dataSourceName, type="version");
if(application.testenv.db.database_productname == "Oracle"){
	application.testenv.isOracle=true;
}
</cfscript>
