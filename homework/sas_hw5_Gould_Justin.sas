*************************************************************;
*  Assignment 5 (84 pts)                                    *;
*  1. This assignment will be due on Friday, 03/20/2026     *;
*     at 11:59 pm.                                          *;
*  2. Save this file in your own folder in order to edit it.*;
*  3. Name your file as sas_hw5_last name_first name.       *;
*  4. Follow the instructions to complete each step and use *;
*     Comment to answer questions if there are any.         *;
*     Carefully label the problems.                         *;
*  5. When you finish all the problems and are ready to     *;
*     submit this assignment, download the .sas file and    *;
*     submit it via Canvas.                                 *;
*************************************************************;

*************************************************************;
* Use the macro variable path for the location of your      *;
* course folder and create a library hw5 using the macro    *;
* variable. (4 pts)                                         *;
*************************************************************;
%let path = /home/u64436407/STA 4133/data;
libname hw5 "&path";


***********************************************************;
*  PRACTICE 1 (24 pts)                                    *;
*  1) Use the PROC PRINT step to examine the column names *;
*     and the firsty 10 rows from the np_lodging table    *;
*     for rows that CL2010 is greater than 0. (4 pts)     *;
*  2) Create a temporary table named stays using the      *;
*     input table hw5.np_lodging. (2 pts)                 *; 
*  3) Use the LARGEST function to create three new        *;
*     columns (Stay1, Stay2, and Stay3) whose values are  *;
*     the first, second, and third highest number of      *;
*     nights stayed from 2010 through 2017 (CL2010-2017). *;
*     (6 pts)                                             *;
*  4) Use the MEAN function to create a column named      *;
*     StayAvg that is the average number of nights stayed *;
*     for the years 2010 through 2017. Use the ROUND      *;
*     function to round values to the nearest integer.    *;
*     (4 pts)                                             *;
*  5) Add a subsetting IF statement to output only rows   *;
*     with StayAvg greater than zero. (2 pts)             *;
*  6) Format Stay1-3 and StayAvg using commas. (2 pts)    *;
*  7) Keep Park, Stay1-3 and StayAvg.(2 pts)              *;
*  8) Submit the code, how many rows are in stays? (2 pts)*;
***********************************************************;
*1) Use the PROC PRINT step to examine the column names;
proc print data=hw5.np_lodging (obs=10);
	where cl2010 > 0;
run;

*2)  Create a temporary table named stays;
data stays;
	set hw5.np_lodging;
	*3) Use the LARGEST function to create three new        *;
*     columns;
	stay1 = largest(1, of cl:);
	stay2 = largest(2, of cl:);
	stay3 = largest(3, of cl:);
	*4) computer average and round it;
	stayavg = round(mean(of cl:));
	*5): delete all zero rows;
	if stayavg > 0;
	*6) Format Stay 1-3;
	format stay: comma12.;
	*7) Keep listed columns;
	keep park stay:;
	
run;

***********************************************************;
*  PRACTICE 2 (22 pts)                                    *;
*  1) Create a temporary table rainsummary from           *;
*     hw5.np_hourlyrain table. (2 pts)                    *;
*  2) Check the new table to make sure it is sorted by    *;
*     by MONTH. If not, use appropriate procedure to      *;
*     sort it. (2 pts)                                    *;
*  3) Group the data by MONTH. (2 pts)                    *;
*  4) Create a new column MonthlyRainTotal column to      *;
*     represents a cumulative total of Rain for each      *;
*     value of Month. (Hint: Use if/then to reset         *;
*     MonthlyRainTotal to 0 for the first day of the      *;
*     month.) (4 pts)                                     *;
*  5) Use the subsetting IF statement to continue         *;
*     processing a row only if it is the last row within  *;
*     each month. (2 pts)                                 *;                    
*  6) After the subsetting IF statement, create the       *; 
*     following new columns:                              *;
*     a) Date - the date portion of the DateTime column   *;
*     (2 pts)                                             *;
*     b) MonthEnd - the last day of the month(2 pts)      *;
*     (Hint: Use intnx function and use date as the 2nd   *;
*      argument)                                          *;
*  7) Format Date and MonthEnd as a date value and keep   *;
*     only the StationName, MonthlyRainTotal, Date, and   *;
*     MonthEnd columns. (4 pts)                           *;
*  8) Submit the code. How many rows are in the           *;
*     rainsummary table? (2 pts)                          *;
***********************************************************;
/* 1 and 2) Create rainsummary and sort the table by MONTH */
proc sort data=hw5.np_hourlyrain out=rainsummary;
	by month;
run;


data rainsummary;
	set rainsummary;
	*3): group the table;
	by Month;
	*4): compute the cumulative rain amount for each month;
	if first.month = 1 then MonthlyRainTotal = 0;
		monthlyraintotal + rain;
	*5): output the last row of each month;
	if last.month = 1;
	*6a) Create date;
	date = datepart(datetime);
	*6a) Create MonthEnd;
	monthend = intnx('month', date, 0, 'e');
	*7) format the data columns;
	format date monthend date9.;
	keep StationName MonthlyRainTotal Date MonthEnd;
run;

/* 8. How many rows are there? There is a total of 12 rows */


***********************************************************;
*  PRACTICE 3 (14 pts)                                    *;
*  1) Create a temporary table clean_traffic from         *;
*     hw5.np_monthlytraffic table. (2 pts)                *;
*  2) Run the program and examine the data. Notice that   *;
*     ParkName includes a code at the end of each value   *;
*     that represents the park type. Also notice that     *;
*     some of the values for Location are in uppercase.   *;
*  3) Add a LENGTH statement to create a new              *;
*     five-character column named Type. (2 pts)           *;
*  4) Add an assignment statement that uses the SCAN      *;
*     function to extract the last word from the ParkName *;
*     column and assigns the resulting value to Type.     *;
*     (2 pts)                                             *;
*  5) Add an assignment statement to use the UPCASE and   *;
*     COMPRESS functions to change the case of Region and *;
*     remove any blanks. (4 pts)                          *;
*  6) Add an assignment statement to use the PROPCASE     *;
*     function to change the case of Location. (2 pts)    *;
*  7) Drop Year column. Submit the code and check if      *;
*     changes are made correctly. (2 pts)                 *;
***********************************************************;
/* 1 and 2) create table */
data clean_traffic;
	set hw5.np_monthlytraffic;
	* 3) create type using length statement;
	length type $5;
	* 4) scan function to extract word from string;
	type = scan(parkname, -1);
	* 5) Add an assignment statement;
	region = upcase(compress(region, 'N'));
	* 6) Use the propcase function;
	location = propcase(location);
	* 7) Drop the year column;
	drop year;
run;



***********************************************************;
*  PRACTICE 4 (20 pts)                                    *;
*  1) Create a temporary table named PARKS from           *;
*     hw5.np_monthlytraffic table. (2 pts)                *;            
*  2) Reads only those rows where ParkName ends with NP.  *;
*     (2 pts)                                             *;
*  3) Modify the DATA step to create or modify the        *;
*     following columns:                                  *;
*     a) Use the SUBSTR function to create a new column   *;
*        named Park that reads each ParkName value and    *;
*        excludes the NP code at the end of the string.   *;
*        Note: Use the FIND function to identify the      *;
*        position number of the NP string. That value can *;
*        be used as the third argument of the SUBSTR      *;
*        function to specify how many characters to read. *;
*        (4 pts)                                          *;
*     b) Convert the Location column to proper case. Use  *;
*        the COMPBL function to remove any extra blanks   *;
*        between words.  (4 pts)                          *;                                 
*     c) Use the TRANWRD function to create a new column  *;
*        named Gate that reads Location and converts the  *;
*        string Traffic Count At to a blank.(4 pts)       *;
*     d) Create a new column names GateCode that          *;
*        concatenates ParkCode and Gate together with a   *;
*        single hyphen between the strings. (4 pts)       *;
*  4) Submit the code and check the results.              *;
***********************************************************;
/* 1) create the table */
data parks;
	set hw5.np_monthlytraffic;
	* 2) where to keep rows end with NP;
	*where upcase(parkname) like '%NP';
	where scan(parkname, -1) = 'NP';
	* 3a) Use SUBSTR
	*park = scan(parkname, 1);
	park = substr(parkname, 1, find(parkname, 'NP')-2);
	* 3b) Convert the location column;
	location = compbl(propcase(location));
	* 3c) Use TRANWRD to create new column;
	gate = TRANWRD(location, 'Traffic Count At', ' ');
	* 3d) Create gatecode;
	gatecode = catx('-', parkcode, gate);
run;

















