{smcl}
{* *! version 0.0.1  12FEB2016}{...}
{cmd:help getmetadata}
{hline}

{title:Title}

{hi:getmetadata {hline 2}} a Java based Stata interface to do a POST request. This program requires Java 8 or above and handles all of the parsing of
the data on the JVM (e.g., requires no dependencies on other packages).  This
is being packaged with the jsonio package
 {p_end}

{title:Syntax}

{p 4 4 4}{cmd:getmetadata} {it:POST url} {it:POST body} {it:save location} {break}

{title:Description}

{p 4 4 4}{cmd:getmetadata} allows users send POST requests to retrieve json data and write it to a file to be deserialized. {p_end}


{title: Author}{break}
{p 1 1 1} Andy Danaee {break}
University of Toronto {break}