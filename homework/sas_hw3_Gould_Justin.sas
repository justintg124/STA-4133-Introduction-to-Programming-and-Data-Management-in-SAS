*************************************************************;
*  Assignment 3 Solution(104 pts)                           *;
*************************************************************;

***********************************************************;
*  PRACTICE 1 (14 pts)                                    *;
* 1) Create a library HW3 using the path of your course   *;
*    data folder. Using macro variable to do so is        *;
*    suggested. (2 pts)                                   *;                                       
* 2) Create a temporary table named eu_occ2016 and read   *;
*    hw3.eu_occ. (2 pts)                                  *;
* 3) Use the WHERE statement to select only the stays     *;
*    that were reported in 2016. Notice that YearMon is a *;
*    character column and the first four positions        *;
*    represent the year. (4 pts)                          *;
* 4) Use the FORMAT statement to apply the COMMA17. format*;
*    to the Hotel, ShortStay, and Camp columns.(2 pts)    *;
* 5) Use the DROP statement to exclude Geo from the       *;
*    output table.(2 pts)                                 
* 6) Submit the program and view the output data. How many*;
*    rows are included in the table eu_occ2016?(2 pts)    *;  
***********************************************************;

/* 1) create library  */
%let path = /home/u64436407/STA 4133/data;
libname hw3 "&path";


/* 2) create temp table  */
data eu_occ22016;
	set hw3.eu_occ;
run;


/* 3) use where to filter; */
data eu_occ22016;
	set hw3.eu_occ;
	where substr(yearmon, 1, 4) = '2016';
run;



/* 4) use format  */
data eu_occ22016;
	set hw3.eu_occ;
	* use where to filter;
	where substr(yearmon, 1, 4) = '2016';
	format hotel shortstay camp comma17.;
	run;

/* 5) use drop */
data eu_occ22016;
	set hw3.eu_occ;
	* use where to filter;
	where substr(yearmon, 1, 4) = '2016';
	format hotel shortstay camp comma17.;
	drop geo;
	run;
	
/* 6) 348 rows */

***********************************************************;
*  PRACTICE 2 (12 pts)                                    *;
* 1) Write a DATA step to read the hw3.np_species table   *;
*    and create a new table named fox. (2 pts)            *;
* 2) Include only the rows where Category is Mammal and   *;
*    Common_Names includes Fox in any case. (6 pts)       *;
* 3) Exclude the Category, Record_Status, Occurrence,     *;
*    and Nativeness columns.(2 pts)                       *;
* 4) Select and run the code. How many rows are included  *;
*    in the fox table? (2 pts)                            *;
***********************************************************;

/* 1) using the data step and creating a new table */
data fox;
	set hw3.np_species;
run;

/* 2) including Mammle and certain common names */
data fox;
	set hw3.np_species;
	where category = 'Mammal' and lowcase(common_names) like '%fox%';
run;

/* 3) Excluding columns */
data fox;
	set hw3.np_species;
	where category = 'Mammal' and lowcase(common_names) like '%fox%';
	drop category record_status occurrence nativeness;
run;

/* 4) 21 rows */

***********************************************************;
*  PRACTICE 3 (14 pts)                                    *; 
* 1) Create a table named np_summary_update from          *;
*    hw3.np_summary (2 pts)                               *;
* 2) Create a new column named SqMiles by multiplying     *;
*    Acres by .0015625. (2 pts)                           *;
* 3) Create a new column named Camping as the sum of      *;
*    OtherCamping, TentCampers, RVCampers, and            *;
*    BackcountryCampers. (4 pts)                          *;
* 4) Format SqMiles and Camping to include commas and     *;
*    zero decimal places. (2 pts)                         *;  
* 5) Keep Reg, ParkName, DayVisits, OtherLodging, Acres,  *;
*    and the new columns in the table (2pts)              *;
* 6) Submit the code. How many rows are included in the   *;
*    new table? (2 pts)                                   *;
***********************************************************;
/* 1) Creating the table */
data np_summary_update;
	set hw3.np_summary;
run;

/* 2) Creating a custom column */
data np_summary_update;
	set hw3.np_summary;
	sqmiles = Acres*.0015625;
run;

/* 3) Creating a summed column */
data np_summary_update;
	set hw3.np_summary;
	sqmiles = Acres*.0015625;
	camping = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
run;

/* 4) Including commas in the output */
data np_summary_update;
	set hw3.np_summary;
	sqmiles = Acres*.0015625;
	camping = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
	format SqMiles Camping comma17.;
run;

/* 5) */
data np_summary_update;
	set hw3.np_summary;
	sqmiles = Acres*.0015625;
	camping = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
	format SqMiles Camping comma17.;
	keep Reg ParkName DayVisits Otherlodging Acres sqmiles camping;
run;

/* 6) 135 rows */


******************************************************************;
*   PRACTICE 4 (18 pts)                                          *;
* 1) Write a DATA step to create a temporary table named         *;
*    eu_occ_total that is based on the hw3.eu_occ table.         *;
*    (2 pts)                                                     *;         
* 2) Create the following new columns:                           *;
*     *Year: the four-digit year extracted from YearMon (2 pts)  *;
*     *Month: the two-digit month extracted from YearMon (2 pts) *;
*     *ReportDate: the first day of the reporting month (2 pts)  *;
*   Note: Use the MDY function and the new Year and Month        *; 
*   columns                                                      *;  
*     *Total: the total nights spent at any establishment (2 pts)*; 
* 3) Format Hotel, ShortStay, Camp, and Total with commas.(2 pts)*;
* 4) Format ReportDate to display the values in the form JAN2018.*;
*    (2 pts)                                                     *;
* 5) Keep Country, Hotel, ShortStay, Camp, ReportDate, and Total *;
*    in the new table.(2 pts)                                    *;
* 6) Submit the program and view the output data. What is the    *;
*    value of ReportDate in row one?(2 pts)                      *;
******************************************************************;


/* 1) creating a temporary table */
data eu_occ_total;
	set hw3.eu_occ;
run;

/* 2) Creating Year, Month, and ReportDate columns */
data eu_occ_total;
	set hw3.eu_occ;
	year = substr(yearmon, 1, 4);
	month = substr(yearmon, 6,2);
	reportdate = mdy(month, 1, year);
	total = camp + shortstay + hotel;
run;


/* 3) Formatting with commas */
data eu_occ_total;
	set hw3.eu_occ;
	year = substr(yearmon, 1, 4);
	month = substr(yearmon, 6,2);
	reportdate = mdy(month, 1, year);
	total = camp + shortstay + hotel;
	* 3)+4): format newly created columns;
	format Hotel ShortStay Camp total comma17.;
run;

/* 4) Format ReportDate to display the values in the form JAN2018 */
data eu_occ_total;
	set hw3.eu_occ;
	year = substr(yearmon, 1, 4);
	month = substr(yearmon, 6,2);
	reportdate = mdy(month, 1, year);
	total = camp + shortstay + hotel;
	* 3)+4): format newly created columns;
	format Hotel ShortStay Camp total comma17. reportdate MONYY7.;
run;

/* 5) Keep Country, Hotel, ShortStay, Camp, ReportDate, and Total in the new table */
data eu_occ_total;
	set hw3.eu_occ;
	year = substr(yearmon, 1, 4);
	month = substr(yearmon, 6,2);
	reportdate = mdy(month, 1, year);
	total = camp + shortstay + hotel;
	* 3)+4): format newly created columns;
	format Hotel ShortStay Camp total comma17. reportdate MONYY7.;
	keep country hotel shortstay camp reportdate total;
run;

/* 6) SEP2017 */

***********************************************************;
*   PRACTICE 5 (20 pts)                                   *;
* 1) Write a DATA step to create a temporary table named  *;
*    park_type that is based on the hw3.np_summary.       *;
*    (2 pts)                                              *;
* 2) Use IF-THEN/ELSE statements to create a new column,  *;
*    ParkType, based on the value of Type.                *;
*      * NP -> Park (2 pts)                               *;
*      * NM -> Monument (2 pts)                           *;
*      * NPRE, PRE, or PRESERVE -> Preserve (4 pts)       *;
*      * NS -> Seashore (2 pts)                           *;
*      * RVR or RIVERWAYS -> River (2 pts)                *;
* 3) Select and run the code. Check the values for        *;
*    ParkType. Fix the issue using an appropriate         *;
*    Statement. (2 pts)                                   *;
* 4) Use the PROC FREQ step to generate a frequency       *;
*    report for variable ParkType. (2 pts)                *;
* 5) What is the frequency of Seashore? (2 pts)           *;
***********************************************************;

/* 1) Creating a temp table */
data park_type;
	set hw3.np_summary;
run;


/* 2) Using IF-THEN/ELSE to create a new columns*/
data park_type;
	set hw3.np_summary;
	if type = 'NP' then parktype = 'Park';
		else if type = 'NM' then parktype = 'Monument';
		else if type in ('NPRE' 'PRE' 'PRESERVE') then parktype = 'Preserve';
		else if type = 'NS' then parktype = 'Seashore';
		else parktype = 'River';
run;


/* 3) fixing the truncated values */
data park_type;
	set hw3.np_summary;
	length parktype $8;
	if type = 'NP' then parktype = 'Park';
		else if type = 'NM' then parktype = 'Monument';
		else if type in ('NPRE' 'PRE' 'PRESERVE') then parktype = 'Preserve';
		else if type = 'NS' then parktype = 'Seashore';
		else parktype = 'River';
run;

/* 4) */
proc freq data=park_type;
	table parktype;
run;



/* 5) seashore frequency is 10 */

***********************************************************;
*   PRACTICE 6 (26 pts)                                   *;
* 1) Write a DATA step to create two temporary tables,    *;
*    named parks and monuments, that are based on the     *;
*    hw3.np_summary table. Read only national parks or    *;
*    monuments from the input table. (Type is either NP   *;
*    or NM.) (2 pts)                                      *;
* 2) Create a new column named Campers that is the sum of *;
*    all columns that contain counts of campers           *;
*    (OtherCamping, TentCampers, RVCampers,               *;
*    BackcountryCampers).(2 pts)                          *;
* 3) When Type is NP, create a new column named ParkType  *;
*    that is equal to Park, and write the row to the      *;
*    parks table. When Type is NM, assign ParkType as     *;
*    Monument and write the row to the monuments table.   *;
*    (16 pts)                                             *;
* 4) Select and run the code. Check the values for        *;
*    ParkType. Fix the issue using an appropriate         *;
*    Statement. (2 pts)                                   *;
* 5) Keep Reg, ParkName, DayVisits, OtherLodging, Campers,*;
*    and ParkType in both output tables. (2 pts)          *;
* 6) Submit the program and view the output data. How     *;
*    many rows are in each table? (2 pts)                 *;
***********************************************************;

/* 1) creating data tables named parks and monuments */
data parks monuments;
	set hw3.np_summary;
	where type in ('NP' 'NM');
run;

/* 2) creating a new column named campers */
data parks monuments;
	set hw3.np_summary;
	where type in ('NP' 'NM');
	campers = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
run;

/* 3 and 4) creating parktype and fixing issue */
data parks monuments;
	set hw3.np_summary;
	where type in ('NP' 'NM');
	campers = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
	length parktype $8;
	if type = 'NP' then do;
		parktype = 'Park';
		output parks;
	end;
	else do;
		parktype = 'Monument';
		output monuments;
	end;
run;


/* 5) */
data parks monuments;
	set hw3.np_summary;
	where type in ('NP' 'NM');
	campers = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
	length parktype $8;
	if type = 'NP' then do;
		parktype = 'Park';
		output parks;
	end;
	else do;
		parktype = 'Monument';
		output monuments;
	end;
	keep Reg ParkName DayVisits OtherLodging Campers Parktype;
run;

/* 6) 51 rows in each table*/




