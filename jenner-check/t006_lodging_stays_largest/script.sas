/* Adapted from homework/sas_hw5_Gould_Justin.sas, PRACTICE 1
   Original read hw5.np_lodging via a LIBNAME pointing at the author's
   SAS Studio home folder. Substituted a small inline sample here with
   a Park column plus eight yearly CL2010-CL2017 columns (matching the
   author's cl: array naming) so the LARGEST/MEAN/ROUND logic and the
   varname-list ("of cl:") syntax run unmodified. */

data np_lodging;
	length Park $20;
	input Park $ CL2010 CL2011 CL2012 CL2013 CL2014 CL2015 CL2016 CL2017;
	datalines;
Yellowstone 1200 1350 1500 1420 1600 1750 1680 1900
Yosemite 900 950 0 1100 1050 1200 1150 1300
Everglades 0 0 0 0 0 0 0 0
Denali 300 320 280 0 400 450 410 500
Badlands 150 0 0 200 0 220 0 250
;
run;

/* #2 Create a temporary table named stays */
data stays;
	set np_lodging;
	/* #3 LARGEST function for the three highest CL2010-2017 values */
	stay1 = largest(1, of cl:);
	stay2 = largest(2, of cl:);
	stay3 = largest(3, of cl:);
	/* #4 MEAN + ROUND for the average */
	stayavg = round(mean(of cl:));
	/* #5 subsetting IF to drop all-zero rows */
	if stayavg > 0;
	/* #6 Format Stay 1-3 and StayAvg with commas */
	format stay: comma12.;
	/* #7 Keep listed columns */
	keep park stay:;
run;

proc print data=stays;
run;
