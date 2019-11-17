* ==============================================================================
* Date : November 2019
* Project : Finance of the Nations
* 
* This program downloads and parses metadata from Statistics Canada CANSIM tables.

* Output: json_data.dta
*
* Third-party packages: net inst jsoniolite, from("https://adanaee.github.io/FOTN/") replace force
* ==============================================================================


// Drop program from memory if it exists
cap prog drop getmembermap
log

prog def getmembermap, rclass
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
	save "`temp'/`cube'_MetaData.dta", replace

	* Display the metadata of the table
	* =================================

	use "`temp'/`cube'_MetaData.dta", replace /* original data file */

	* This part cleans up the data by creating/dropping/renaming the variables
	
	keep if key4=="member"
	drop key
	reshape wide value, i(key3 key5) j(key6) string
	rename value* *
	
	drop key1 key2 key4 key5 memberNameFr memberUomCode terminated vintage  ///
	classificationCode classificationTypeCode geoLevel
	
	rename (key3 parentMemberId memberNameEn) 								///
	(dimensionLevel parentId memberName)
	
	replace dimensionLevel = 												///
	substr(dimensionLevel,strlen(dimensionLevel),strlen(dimensionLevel))
	
	destring dimensionLevel memberId parentId, replace
	sort dimensionLevel memberId
	
	* This part identifies how far down each member is in their respective dimension.
	
	gen treelevel = 0
	local i = 1
	local ubound = _N
	while `i' <= `ubound' {
		if parentId[`i'] !=. { /*if not . add 1 */
			replace treelevel = treelevel + 1 in `i'
		}
		local k = dimensionLevel[`i'] /* need to loop by dimension */
		if parentId[`i'] !=. {
			local j = parentId[`i']
			local n = 1
			while `n' < `ubound' {
			/*inc based on parent level*/
				if (`j' == memberId[`n'] & `k' == dimensionLevel[`n']){ 
					replace treelevel = treelevel[`n'] + 1 					///
					if parentId[`n'] !=. in `i'
				}
				local n = `n' + 1
			}
		}
		local i = `i' + 1
	}
	
	save "`temp'/`cube'_MetaData.dta", replace
	li *, compress
	di "Cube: `cube'"
	
end
