{smcl}
{* *! version 0.0.8  01NOV2017}{...}

{hline}
{p 2 2 8}I/O operations with JSON Data{p_end}
{hline}

{p 4 4 8}{hi:jsoniolite {hline 2}} A slightly modified version of jsonio built on
the {browse "https://github.com/wbuchanan/StataJSON": StataJSON} jsonio command written by William Buchanan.

{title:Description}
{p 4 4 4}{cmd:jsoniolite} is a stripped version of jsonio. Jsoniolite now only contains the {help jsonio##kv:key-value}  interface and can only ingest files.

{title:Syntax}

{p 4 4 4}{cmd:jsonio} {it:{opt kv}}
[{opt varlist}] {ifin} , [
{cmdab:no:URL} {cmdab:file:nm(}{it:string}{cmd:)}] {break}


{title:Subcommands}
{marker kv}{p 4 4 8}{cmd:kv} is a subcommand for {help jsonio} that is used to
load data from the JSON file into the active dataset as a key/value pair.
This method defines two variables in the dataset - key and value.  If the type of each
datum is not constant across all elements the values will be loaded as a string.
However, if the values are of a single type, they will be loaded into the dataset with
the appropriate type casting applied.  {p_end}


{title:Options}

{p 4 4 8}{cmd:nourl} because we are now only reading data from a file, nourl must be specified to make jsonio read the data from the file. {p_end}

{p 4 4 8}{cmdab:file:nm} this parameter specifies the location of the JSON to ingest.  If the JSON is stored in a file, be sure to use the {cmd:nourl}
option.  {p_end}


{marker examples}{title:Examples}{break}

{p 4 4 4} deserialize from file {p_end}

{p 8 8 12}jsoniolite kv, file(fileLocation) nourl


{title: Original Author of jsonio}{break}
{p 2 2 2}William R. Buchanan, Ph.D. {p_end}
{p 2 2 2}Director, Office of Data, Research, & Accountability{p_end}
{p 2 2 2}{browse "http://www.fcps.net":Fayette County Public Schools}{p_end}
{p 2 2 2}Billy.Buchanan at fayette [dot] kyschools [dot] us{p_end}