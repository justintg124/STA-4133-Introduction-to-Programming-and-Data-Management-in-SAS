/* Adapted from homework/sas_hw3_Gould_Justin.sas, PRACTICE 3
   Original read hw3.np_summary via a LIBNAME pointing at the author's
   SAS Studio home folder. Substituted a small inline sample here with
   the same columns (Reg, ParkName, DayVisits, OtherLodging, Acres,
   OtherCamping, TentCampers, RVCampers, BackcountryCampers) so the
   DATA step's derived-column logic runs unmodified. */

data np_summary;
	length Reg $2 ParkName $24;
	input Reg $ ParkName $ DayVisits OtherLodging Acres OtherCamping TentCampers RVCampers BackcountryCampers;
	datalines;
IM Yellowstone 450000 12000 2219791 500 12000 8000 900
IM Grand_Teton 180000 4000 310044 200 5000 3000 400
SE Everglades 220000 0 1508538 0 0 1500 100
SE Great_Smoky_Mountains 610000 3000 522427 300 15000 9000 1200
PW Yosemite 390000 8000 761747 400 9000 6000 700
PW Olympic 145000 2000 922650 150 4000 2000 250
NC Badlands 60000 500 242756 50 1200 900 80
AK Denali 30000 1000 4740912 20 500 100 60
;
run;

/* #2 Creating a custom column: SqMiles from Acres */
/* #3 Creating a summed column: Camping */
/* #4 Format with commas */
/* #5 Keep the requested columns */
data np_summary_update;
	set np_summary;
	sqmiles = Acres*.0015625;
	camping = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
	format SqMiles Camping comma17.;
	keep Reg ParkName DayVisits Otherlodging Acres sqmiles camping;
run;

proc print data=np_summary_update;
run;
