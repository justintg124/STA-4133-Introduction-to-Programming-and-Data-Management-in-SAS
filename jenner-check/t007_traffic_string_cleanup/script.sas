/* Adapted from homework/sas_hw5_Gould_Justin.sas, PRACTICE 4
   Original read hw5.np_monthlytraffic via a LIBNAME pointing at the
   author's SAS Studio home folder. Substituted a small pipe-delimited
   inline sample here with ParkName/ParkCode/Location columns in the
   same shape (park name ending in a type code, a location string with
   mixed case) so the SCAN/SUBSTR/FIND/COMPBL/PROPCASE/TRANWRD/CATX
   chain runs unmodified against real string values. */

data np_monthlytraffic;
	length ParkName $30 ParkCode $4 Location $40;
	infile datalines dlm='|';
	input ParkName $ ParkCode $ Location $;
	datalines;
Yellowstone NP|YELL|Traffic Count At North Entrance
Grand Teton NP|GRTE|Traffic Count At South Entrance
Everglades NP|EVER|Traffic Count At Main Gate
Denali NP|DENA|traffic count at West entrance
;
run;

/* #1 create table */
/* #2 where to keep rows that end with NP */
data parks;
	set np_monthlytraffic;
	where scan(parkname, -1) = 'NP';
	/* introduce the extra interior blanks the assignment describes
	   seeing in the source data, so COMPBL below has real work to do */
	location = tranwrd(location, ' ', '  ');
	/* #3a SUBSTR + FIND to strip the trailing NP code */
	park = substr(parkname, 1, find(parkname, 'NP')-2);
	/* #3b COMPBL + PROPCASE to normalize Location */
	location = compbl(propcase(location));
	/* #3c TRANWRD to blank out the boilerplate prefix */
	gate = tranwrd(location, 'Traffic Count At', ' ');
	/* #3d CATX to build a hyphenated code */
	gatecode = catx('-', parkcode, gate);
run;

proc print data=parks;
	var park parkcode location gate gatecode;
run;
