<cfscript>
	param name="params.type" default="core";
	param name="params.format" default="html";
	// Embedded Documentation Helpers

	/**
	* Take a metadata struct as from getMetaData() and get some additional info
	*
	* @meta metadata struct as returned from getMetaData()
	* @doctype ie. Controller || Model
	*/
	struct function parseMetaData(required struct meta, required string doctype){
		local.m=arguments.meta;
		local.rv["name"]=structKeyExists(local.m, "name")?local.m.name:"";
		local.rv["parameters"]=structKeyExists(local.m, "parameters")?local.m.parameters:[];
		local.rv["returntype"]=structKeyExists(local.m, "returntype")?local.m.returntype:"";
		local.rv["hint"]=structKeyExists(local.m, "hint")?local.m.hint:"";
		local.rv["section"]="";
		local.rv["sectionClass"]="";
		local.rv["category"]="";
		local.rv["categoryClass"]="";
		local.rv["availableIn"]=[doctype];
		// Look for [something: Foo] style tags in hint
		if(structKeyExists(local.rv, "hint")){
			local.tags=ReMatchNoCase('\[((.*?):(.*?))\]', local.rv.hint);
			if(arrayLen(local.tags)){
				for(tag in local.tags){
					tagName=replace(listFirst(tag, ":"), "[","","one");
					tagValue=replace(listLast(tag, ":"), "]","","one");
					local.rv[tagName]=tagValue;
					local.rv[tagName & "Class"]=cssClassLink(tagValue);
				}
				local.rv["hint"]=REReplaceNoCase(local.rv["hint"], "\[((.*?):(.*?))\]", "", "ALL");
			}
		}
		// Check for param defaults within wheels settings
		for(param in local.rv["parameters"]){
			if(structKeyExists(application.wheels.functions, local.rv["name"])
				&& structKeyExists(application.wheels.functions[local.rv["name"]], param['name'])){
					param['default']=application.wheels.functions[local.rv["name"]][param['name']];
				}
		}
		// Check for extended documentation
		local.rv["pathToExtended"]=expandPath("wheels/public/docs/reference/" & lcase(functionName) & ".txt");
		local.rv["hasExtended"]=fileExists(local.rv.pathToExtended)?true:false;
		if(local.rv.hasExtended){
			local.rv["extended"]="<pre>" & htmleditformat(fileread(local.rv.pathToExtended)) & "</pre>";
			local.rv["extended"]=trim(local.rv["extended"]);
		}
		return local.rv;
	}
	/**
	* Searches for ``` in hint description output and formats
	*
	* @str The Hint String
	*/
	string function hintOutput(str){
		local.rv=ReReplaceNoCase(arguments.str, '`(\w+)`', '<code>\1</code>', "ALL");
		return simpleFormat(trim(local.rv));
	}
	/**
	* Turns "My Thing" into "mything"
	*
	* @str The String
	*/
	string function cssClassLink(str){
		return trim(replace(lcase(str), " ", "", "all"));
	}

	/**
	* Sorts an array of structures based on a key in the structures.
	*
	* @param aofS      Array of structures.
	* @param key      Key to sort by.
	* @param sortOrder      Order to sort by, asc or desc.
	* @param sortType      Text, textnocase, or numeric.
	* @param delim      Delimiter used for temporary data storage. Must not exist in data. Defaults to a period.
	* @return Returns a sorted array.
	* @author Nathan Dintenfass (nathan@changemedia.com)
	* @version 1, December 10, 2001
	*/
	function $arrayOfStructsSort(aOfS,key){
	        //by default we'll use an ascending sort
	        var sortOrder = "asc";
	        //by default, we'll use a textnocase sort
	        var sortType = "textnocase";
	        //by default, use ascii character 30 as the delim
	        var delim = ".";
	        //make an array to hold the sort stuff
	        var sortArray = arraynew(1);
	        //make an array to return
	        var returnArray = arraynew(1);
	        //grab the number of elements in the array (used in the loops)
	        var count = arrayLen(aOfS);
	        //make a variable to use in the loop
	        var ii = 1;
	        //if there is a 3rd argument, set the sortOrder
	        if(arraylen(arguments) GT 2)
	            sortOrder = arguments[3];
	        //if there is a 4th argument, set the sortType
	        if(arraylen(arguments) GT 3)
	            sortType = arguments[4];
	        //if there is a 5th argument, set the delim
	        if(arraylen(arguments) GT 4)
	            delim = arguments[5];
	        //loop over the array of structs, building the sortArray
	        for(ii = 1; ii lte count; ii = ii + 1)
	            sortArray[ii] = aOfS[ii][key] & delim & ii;
	        //now sort the array
	        arraySort(sortArray,sortType,sortOrder);
	        //now build the return array
	        for(ii = 1; ii lte count; ii = ii + 1)
	            returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
	        //return the array
	        return returnArray;
	}

	include "docs/#params.type#.cfm";
</cfscript>
