/* Adapted from homework/sas_hw2_Gould_Justin qbu192.sas, PRACTICE 6 and 7
   Originals read hw2.np_summary / hw2.np_largeparks via a LIBNAME pointing
   at the author's SAS Studio home folder. Substituted small inline
   DATALINES samples with the same columns so PROC SORT's BY / WHERE
   options and the NODUP/DUPOUT dedup logic run unmodified against real
   park-style data (including a deliberate duplicate row, as the original
   dataset was noted to contain some). */

data np_summary;
	length Reg $2 Type $2 ParkName $30;
	input Reg $ Type $ ParkName $ DayVisits;
	datalines;
IM NP Yellowstone 450000
IM NP Grand_Teton 180000
SE NP Everglades 220000
SE NP Great_Smoky_Mountains 610000
PW NP Yosemite 390000
PW NP Olympic 145000
NC NP Badlands 60000
AK NP Denali 30000
;
run;

/* #1 Sorting the table, descending Reg then descending ParkName */
proc sort data=np_summary out=np_sort;
	by descending Reg descending ParkName;
	/* #2 WHERE statement to select Type equal to NP */
	where type = 'NP';
run;

proc print data=np_sort;
run;

data np_largeparks;
	length ParkName $30;
	input ParkName $ Acres;
	datalines;
Yellowstone 2219791
Yellowstone 2219791
Grand_Teton 310044
Everglades 1508538
Great_Smoky_Mountains 522427
Great_Smoky_Mountains 522427
Yosemite 761747
Olympic 922650
;
run;

/* Practice 7 #2 removing exact duplicate rows */
proc sort data=np_largeparks out=park_clean nodup
	dupout=park_dups;
	by _all_;
run;

proc print data=park_clean;
run;

proc print data=park_dups;
run;
