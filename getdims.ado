* ==============================================================================
* Date : November 2019
* Project : Finance of the Nations
* 
* This program displays the description and number  of each dimension in the table

* Output: <cube_number>.dta
*
* Third-party packages: net inst jsoniolite, from("https://adanaee.github.io/FOTN/") replace force
* ==============================================================================


// Drop program from memory if it exists
cap prog drop getdims
log

prog def getdims, rclass
	version 13.0
	args cube
	
	// Drop the variables from memory if they exists
	capture drop dimensionName dimensionLevel
	capture drop dimensionLevel memberId memberName parentId treelevel
	
	* Define the name of JSON output file
	local output_file "output.json"
	* Define the directory
	local temp `c(pwd)'

	local URL "https://www150.statcan.gc.ca/t1/wds/rest/getCubeMetadata"

	* Download and parse the metadata to key/value pairs
	* ==================================================

	* POST data to URL and save it
	getmetadata `URL' "`cube'" "`temp'/`output_file'"

	* Parse the .json file to key/value pairs
	jsoniolite kv, file("`temp'/`output_file'") nourl
	split key, p("/")
	save "`temp'\`cube'_dimNames.dta", replace

	* Display the metadata of the table
	* =================================
	
	use "`temp'\`cube'_dimNames.dta", replace
	keep if key4=="dimensionNameEn"
	drop key
	drop key1 key2 key4 key5 key6
	rename (key3 value)(dimensionLevel dimensionName)
	
	replace dimensionLevel = 												///
	substr(dimensionLevel,strlen(dimensionLevel),strlen(dimensionLevel))
	
	destring dimensionLevel, replace
	sort dimensionLevel
	save "`temp'\`cube'_dimNames.dta", replace
	li *, compress
	di "Cube: `cube'"
	
end
