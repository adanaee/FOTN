********************************************************************************
*                                                                              *
* Description -                                                                *
*   Program to serialize a dataset and return a JSON representation of the     *
*   data.                                                                      *
*                                                                              *
* System Requirements -                                                        *
*   JRE 1.8 or Higher.                                                         *
*                                                                              *
* Output - (Optional)                                            			   *
*   Prints a JSON object to the Stata console. *
*                                                                              *
* Lines -                                                                      *
* 	95	                                                                       *
*                                                                              *
********************************************************************************

*! jsoniolite
*! 10OCT2019
*! v 0.0.8

// Drop program from memory if it exists
cap prog drop jsoniolite

// Define program as an r-class program
prog def jsoniolite, rclass

	// Set version
	version 13.0

	// Define input syntax
	syntax anything(name=subtype id="Input/Output Type") [if] [in] , [		 ///
	ELEMents(passthru) noURL FILEnm(string) OBid(passthru) 					 ///
	METAprint(passthru)  What(passthru) STUBname(passthru) ]

	// Tokenize the first argument
	gettoken cmd opts : subtype

	// Make sure there aren't any issues with the macro expansion for filepaths
	if `"`url'"' == "nourl" loc filenm `: subinstr loc filenm `"~"' `"`: env HOME'"''

	// If command is keyvay
	if `"`cmd'"' == "kv" keyval `"`filenm'"', `elements' `url'

	// Return local with the total number of keys
	ret loc totalkeys `r(totalkeys)'

	// Set the local macro that needs to be returned
	ret loc thejson `"`r(thejson)'"'

// End of the program definition
end

// JSON Deserializer
prog def keyval, rclass

	// Define input syntax
	syntax anything(name=source id="Source of the JSON Input") [,			 ///
	ELEMents(string) noURL ]
	
	javacall com.stata.textfilter.FileFilter main, args(`source')
	

	// If elements is null
	if `"`elements'"' == "" loc elements ".*"

	// Assumes data is coming from a URL unless specified otherwise
	if `"`url'"' == "nourl" {

		// Call Java method to import from file
		javacall org.paces.Stata.Input.InJSON insheetFile,					 ///
		args(`source' "`elements'")

	} // End IF Block for files

	// If it is a URL
	else {

		// Call Java method to import from URL
		javacall org.paces.Stata.Input.InJSON insheetUrl, args(`source' "`elements'")

	} // End ELSE Block for URLs

	// Return local with the total number of keys
	ret loc totalkeys `totalkeys'

// End subroutine
end
