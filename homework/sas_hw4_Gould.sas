*************************************************************;
*  Assignment 4 (124 pts)                                   *;
*  1. This assignment will be due on Friday, 3/07/2025      *;
*     at 11:59 pm.                                          *;
*  2. Save this file in your own folder in order to edit it.*;
*  3. Name your file as sas_hw4_last name_first name.       *;
*  4. Follow the instructions to complete each step and use *;
*     Comment to answer questions if there are any.         *;
*     Carefully label the problems.                         *;
*  5. When you finish all the problems and are ready to     *;
*     submit this assignment, download the .sas file and    *;
*     submit it via Canvas.                                 *;
*************************************************************;

*************************************************************;
* Use the macro variable path for the location of your      *;
* course folder and create a library hw4 using the macro    *;
* variable. (4 pts)                                         *;
*************************************************************;
%let path = /home/u64436407/STA 4133/data;
libname hw4 "&path";


**************************************************************;
*  PRACTICE 1 (15 pts)                                       *;
*  1) Examine the program and answer the following           *;
*     questions.                                             *;
*     a) Which statements are compile-time only?(3 pts)      *;
*     b) What will be assigned for the length of Size?(3 pts)*;
*  2) Run the program and examine the results.               *;
*  3) Modify the program to resolve the truncation of        *;
*     Size. Read the first 5 rows from the input table.      *;
*     (3 pts)                                                *;
*  4) Add PUTLOG statements to provide the following         *;
*     information in the log:                                *;
*     a) Immediately after the SET statement, write START    *;
*        DATA STEP ITERATION to the log as a color-coded     *;
*        note. (2 pts)                                       *;
*     b) After the Type= assignment statement, write the     *;
*        value of Type to the log. (2 pts)                   *;
*     c) At the end of the DATA step, write the contents     *;
*        of the PDV to the log. (2 pts)                      *;
*  5) Run the program and read the log to examine the        *;
*     messages written during execution.                     *;
**************************************************************;

/* 1) 
a. Compile time only statements include: keep, where, format
b. 	if Acres<1000 then Size="Small";
	else if Acres<100000 then Size="Medium";
	else Size="Large"; */
	

/* 2 & 3) */
data np_parks;
	set hw4.np_final (obs = 5); *Added this;
	keep Region ParkName AvgMonthlyVisitors Acres Size;
    where Type="PARK";
	format AvgMonthlyVisitors Acres comma10.;
    Type=propcase(Type);
	AvgMonthlyVisitors=sum(DayVisits,Campers,OtherLodging)/12;
run;


/* 4 & 5) Add putlog statements */
data np_parks;
	set hw4.np_final (obs = 5);
	putlog "START DATA STEP ITERATION";
	keep Region ParkName AvgMonthlyVisitors Acres Size;
    where Type="PARK";
    PUTLOG TYPE=;
	format AvgMonthlyVisitors Acres comma10.;
    Type=propcase(Type);
	AvgMonthlyVisitors=sum(DayVisits,Campers,OtherLodging)/12;
	if Acres<1000 then Size="Small";
	else if Acres<100000 then Size="Medium";
	else Size="Large";
	PUTLOG _ALL_;
run;



*************************************************************;
*  PRACTICE 2 (15 pts)                                      *;
*  1) Use the DATA step to create three tables:             *;
*     monument, park, and other from hw4.np_yearlytraffic. *;
*     (3 pts)                                               *;
*  2) Drop ParkType from the monument and park tables.      *;
*     Drop Region from all three tables.  (4 pts)           *;
*  3) Write the rows to monument table if ParkType is       *;
*     National Monument; write rows to park if the ParkType *;
*     is National Park; for any other ParkTypes, write the  *;
*     rows to other table. (6 pts)                          *;
*  4) Submit the program and verify the output. How many    *;
*     rows are in the other table. (2 pts)                  *;
*************************************************************;

/* 1) Create three tables */
DATA monument (drop = parktype) park (drop=parktype) other;
	set hw4.np_yearlytraffic;
run;

/* 2) Drop Parktype and region */
DATA monument (drop = parktype) park (drop=parktype) other;
	set hw4.np_yearlytraffic;
	drop region;
run;

/* 3)  */
DATA monument (drop = parktype) park (drop=parktype) other;
	set hw4.np_yearlytraffic;
	drop region;
	if parktype = 'National Monument' then output monument;
		else if parktype = 'National Park' then output park;
			else output other;
run;


/* 4) 148 rows are in the other table */

*************************************************************;
*  PRACTICE 3 (18 pts)                                      *;
*  1) Use a DATA step that creates temporary SAS tables     *;
*     named camping and lodging and reads the               *;
*     hw4.np_2017 table. (4 pts)                            *;
*  2) Compute a new column, CampTotal, that is the sum of   *;
*     CampingOther, CampingTent, CampingRV, and             *;
*     CampingBackcountry. Format CampTotal so that values   *;
*     are displayed with commas. (4 pts)                    *;
*  3) The camping table has the following specifications:   *;
*     a) includes rows if CampTotal is greater than zero    *;
*        (2 pts)                                            *;
*     b) contains the ParkName, Month, DayVisits, and       *;
*        CampTotal columns (2 pts)                          *;
*  4) The lodging table has the following specifications:   *;
*     a) includes rows where LodgingOther is greater        *;
*        than zero(2 pts)                                   *;
*     b) contains only the ParkName, Month, DayVisits,      *;
*        and LodgingOther columns (2 pts)                   *;
*  5) Submit the program and verify the output. How many    *;
*     rows are in each table. (2 pts)                       *;
*************************************************************;

/* 1) Tables for camping and lodging */
data camping lodging;
	set hw4.np_2017;
run;

/* 2) create camptotal */
data camping lodging;
	set hw4.np_2017;
	CampTotal = sum(CampingOther, CampingTent, CampingRV, CampingBackcountry);
	format CampTotal comma12.;
run;

/* 3 & 4 */
data camping (keep=ParkName Month DayVisits CampTotal) 
	lodging (keep=ParkName Month DayVisits LodgingOther);
	set hw4.np_2017;
	camptotal = sum(of camping:);
	format camptotal comma12;
	if camptotal > 0 then output camping;
	if LodgingOther > 0 then output lodging;
run;

/* 5) 1374 in the camping table and 383 in the lodging table  */

*************************************************************;
*  PRACTICE 4 (8 pts)                                       *;
*  1) Use a DATA step to create a temporary table           *;
*     TotalTraffic from hw4.np_yearlytraffic. (2 pts)       *;
*  2) Create a column, totTraffic, that is the running      *;
*     total of Count. (2 pts)                               *;
*  3) Keep the ParkName, Location, Count, and               *;
*     totTraffic columns in the output table. (2 pts)       *;
*  4) Format totTraffic so values are displayed with        *;
*     commas. (2 pts)                                       *;
*************************************************************;

/* 1) create the table */
data TotalTraffic;
	set hw4.np_yearlytraffic;
run;

/* 2) create tottraffic */
data totaltraffic;
	set hw4.np_yearlytraffic;
	tottraffic + count;
run;

/* 3) keep parkname location count tottraffic */
data totaltraffic;
	set hw4.np_yearlytraffic;
	tottraffic + count;
	keep parkname location count tottraffic;
	format tottraffic comma12.;
run;

/* 4) format tottraffic */
data totaltraffic;
	set hw4.np_yearlytraffic;
	tottraffic + count;
	keep parkname location count tottraffic;
	format tottraffic comma12.;
run;

*************************************************************;
*  PRACTICE 5 (20 pts)                                      *;
*  1) Use a DATA step to create a temporary table           *;
*     ParkTypeTraffic from hw4.np_yearlytraffic. (2 pts)    *;
*  2) Read only the rows from the input table where         *;
*     ParkType is National Monument or National Park.       *;
*     (4 pts)                                               *;
*  3) Create two new columns named MonumentTraffic and      *;
*     ParkTraffic. The value of each column is the running  *;
*     total of Count for that park type. (6 pts)            *;
*  4) Format the new columns so that values are displayed   *;
*     with commas. (2 pts)                                  *;
*  5) Create a listing report of parkTypeTraffic. Use       *;
*     Accumulating Traffic Totals for Park Types as the     *;
*     report title. Display the columns in this order:      *;
*     ParkType, ParkName, Location, Count, MonumentTraffic, *;
*     and ParkTraffic.(6 pts)                               *;
*************************************************************;
/* 1) create table */
data parktypetraffic;
	set hw4.np_yearlytraffic;
run;

/* 2) set the where statement*/
data parktypetraffic;
	set hw4.np_yearlytraffic;
	where parktype in ('National Monument' 'National Park');
run;

/* 3 & 4 create new columns and format them */
data parktypetraffic;
	set hw4.np_yearlytraffic;
	where parktype in ('National Monument' 'National Park');
	if parktype = 'National Monument' then monumenttraffic + count;
	if parktype = 'National Park' then parktraffic + count;
	format monumenttraffic parktraffic comma12.;
run;

/* 5 Set the report title */
title 'Accumulating Traffic Totals for Park Types';
proc print data=parktypetraffic;
run;
title;

****************************************************************;
*  PRACTICE 6 (24 pts)                                         *;
*  1) Use a PROC SORT step to sort the hw4.np_yearlytraffic    *;
*     table by ParkType and ParkName. (4 pts)                  *;
*  2) Output the sorted table with name sortedtraffic.         *;
*     Keep ParkType, ParkName, Location and Count. (4 pts)     *; 
*  3) Use the DATA step to do the following:                   *;
*     a) Read the sorted table created in PROC SORT and create *;
*        a table named TypeTraffic.(2 pts)                     *;
*     b) Add a BY statement to group the data by ParkType.     *;
*        (2 pts)                                               *;
*     c) Create a column, TypeCount, that is the running       *;
*        total of Count within each ParkType. (Hint: Use the   *;
*        if/then statement to reset TypeCount at the beginning *;
*        of each ParkType group)(4 pts)                        *;
*     d) Format TypeCount so values are displayed with commas. *;
*        (2 pts)                                               *;
*     e) Keep only the ParkType and TypeCount columns.(2 pts)  *;
*  4) Run the program and confirm TypeCount is reset at        *;
*     the beginning of each ParkType group.                    *;
*  5) Modify the program to write only the last row for        *;
*     each ParkType to the output table.(2 pts) Which park     *;
*     type is most popular? (2 pts)
****************************************************************;

/* 1) Sort the table */
proc sort data=hw4.np_yearlytraffic out=sortedtraffic;
	by parktype parkname;
run;

/* 2) */
data TypeTraffic;
	set sortedtraffic;
	keep ParkType ParkName Location Count
run;

/* 3 & 4 */
data TypeTraffic;
	set sortedtraffic;
	by parktype;
	first_parktype = first.parktype;
	last_parktype = last.parktype;
	if first.parktype = 1 then typecount = 0;
		typecount + count;
	if last.parktype = 1 then output;
run;

/* 5) Zion NP is the most popular */

****************************************************************;
*  PRACTICE 7 (20 pts)                                         *;
*  1) Create a sorted copy of sashelp.shoes with name          *;
*     shoes_sorted that is sorted by Region and Product (4 pts)*;
*  2) Use the DATA step to read the sorted table and create    *;
*     a new table named profitsummary. (2 pts)                 *;
*  3) Create a column named Profit that is the difference      *;
*     between Sales and Returns. (2 pts)                       *;
*  4) Create an accumulating column named TotalProfit that     *;
*     is a running total of Profit within each value of Region *;
*     and Product. (Hint: a BY statment may be needed before   *;
*     the column is created.) (4 pts)                          *;
*  5) Reset TotalProfit for each new combination of Region     *;
*     and Product. Run the program and verify that TotalProfit *;
*     is accurate. (2 pts)                                     *;
*  6) Modify the DATA step to include only the last row for    *;
*     each Region and Product combination. (2 pts)             *;
*  7) Keep Region, Product, and TotalProfit. (2 pts)           *;
*  8) Format TotalProfit as a currency value. (2 pts)          *;
****************************************************************;
/* 1) create and sort */
proc sort data=sashelp.shoes out=shoes_sorted;
	by region product;
run;

/*  2) */
data profitsummary;
	set shoes_sorted;
	by region product;
	keep region product;
run;

/* 3) create profit */
data profitsummary;
	set shoes_sorted; 
	profit = sales - returns;
	by region product;
	keep region product;
run;

/* 4 & 5 */
 
data profitsummary;
	set shoes_sorted; 
	profit = sales - returns;
	if first.product = 1 then totalprofit = 0;
		totalprofit + profit;
	if last.product = 1 then output;
run;

/* 6 & 7 & 8*/
 
data profitsummary;
	set shoes_sorted; 
	profit = sales - returns;
	by region product; *6;
	if first.product = 1 then totalprofit = 0;
		totalprofit + profit;
	if last.product = 1 then output;
	keep region product totalprofit; *7;
	format totalprofit dollar12.; *8;
run;

 