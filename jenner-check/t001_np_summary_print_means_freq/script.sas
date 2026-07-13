/* Adapted from homework/sas_hw2_Gould_Justin qbu192.sas, PRACTICE 1
   Original read hw2.np_summary via a LIBNAME pointing at the author's
   SAS Studio home folder. Substituted a small inline sample here with
   the same columns (Reg, Type, ParkName, DayVisits, TentCampers,
   RVCampers) so the PROC steps run unmodified against real park-style
   data. */

data np_summary;
	length Reg $2 Type $4 ParkName $30;
	input Reg $ Type $ ParkName $ DayVisits TentCampers RVCampers;
	datalines;
IM NP Yellowstone 450000 12000 8000
IM NP Grand_Teton 180000 5000 3000
SE NP Everglades 220000 0 1500
SE NP Great_Smoky_Mountains 610000 15000 9000
PW NP Yosemite 390000 9000 6000
PW NP Olympic 145000 4000 2000
NC NP Badlands 60000 1200 900
AK NP Denali 30000 500 100
IM NM Devils_Tower 25000 300 200
SE NM Fort_Sumter 15000 0 0
PW NM Muir_Woods 40000 0 0
NC NM Wind_Cave 12000 200 150
;
run;

/* #2 Get an overview of the table */
proc print data=np_summary (obs=20);
run;

/* #3 Reg Type ParkName DayVisits TentCampers RVCampers */
proc print data=np_summary (obs=20);
	var Reg Type ParkName DayVisits TentCampers RVCampers;
run;

/* #4 Using Proc means */
proc means data=np_summary;
	var DayVisits TentCampers RVCampers;
run;

/* #5 Using univariate */
proc univariate data=np_summary;
	var DayVisits TentCampers RVCampers;
run;

/* #6 using Proc freq and TABLES */
proc freq data=np_summary;
	tables reg type;
run;
