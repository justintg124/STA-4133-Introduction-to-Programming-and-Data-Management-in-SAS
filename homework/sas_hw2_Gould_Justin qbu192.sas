*************************************************************;
*  Assignment 2 (74 pts)                                    *;
*  1. This assignment will be due on Friday, 2/13/2026      *;
*     at 11:59 pm.                                          *;
*  2. Save this file in your own folder in order to edit it.*;
*  3. Name your file as sas_hw2_last name_first name_abc123.*;
*  4. Follow the instructions to complete each step and use *;
*     Comment to answer questions if there are any.         *;
*     Carefully label the problems.                         *;
*  5. When you finish all the problems and are ready to     *;
*     submit this assignment, download the .sas file and    *;
*     submit it via Canvas.                                 *;
*************************************************************;


***********************************************************;
*  PRACTICE 1 (22 pts)                                    *;
*    1) Use the LIBNAME statement to create a library     *;
*       named HW2 for SAS data sets with the file path of *;
*       your data folder. (2pts)                          *;
*    2) Complete the PROC PRINT statement to list the     *;
*       first 20 observations in HW2.NP_SUMMARY. (2pts)   *;
*    3) Add a VAR statement to include only the following *;
*       variables: Reg, Type, ParkName, DayVisits,        *;
*       TentCampers, and RVCampers. Highlight the step    *;
*       and run the selected code. (2 pts)                *;
*    4) Copy the PROC PRINT step and paste it at the end  *;
*       of the program. Change PRINT to MEANS and remove  *;
*       the OBS= data set option. Modify the VAR          *;
*       statement to calculate summary statistics for     *;
*       DayVisits, TentCampers, and RVCampers. Highlight  *;
*       the step and run the selected code.  (2 pts)      *;
*       What is the minimum value for tent campers? (1 pt)*;
*       Is that value unexpected? (1 pt)                  *;
*    5) Copy the PROC MEANS step and paste it at the end  *;
*       of the program. Change MEANS to UNIVARIATE.       *;
*       Highlight the step and run the selected code.     *;
*       (2 pts)                                           *;
*       Are there negative values for any of the columns? *;
*       (1 pt)                                            *;
*    6) Copy the PROC UNIVARIATE step and paste it at the *;
*       end of the program. Change UNIVARIATE to FREQ.    *;
*       Change the VAR statement to a TABLES statement to *;
*       produce frequency tables for Reg and Type.        *;
*       Highlight the step and run the selected code.     *;
*       (2 pts)                                           *;
*       Are there any lowercase codes? (1 pt) What are    *;
*       the codes that occur only once in the table?      *;
*       (1 pt)                                            *;
*    7) Add comments before each step to document the     *;
*       program.  (5 pts)                                 *;
***********************************************************;
/* #1 Creating the library for hw2 */
libname hw2 '/home/u64436407/STA 4133/data';


/* #2 Get an overview of the table*/
proc print data=hw2.np_summary (obs=20);
run;


/* #3 Reg Type ParkName DayVisits TentCampers RVCampers */
proc print data=hw2.np_summary (obs=20);
	var Reg Type ParkName DayVisits TentCampers RVCampers;
run;


/* #4 Using Proc means */ 
proc means data=hw2.np_summary;
	var DayVisits TentCampers RVCampers;
run;

/* The minimum value for tent campers is $0 and yes, this value is unexpected. */



/* #5 Using univariete */

proc univariate data=hw2.np_summary;
	var DayVisits TentCampers RVCampers;
run;
/* No negative values */


/* #6 using Proc freq and TABLES */
proc freq data=hw2.np_summary;
	tables reg type;
run;

/* No lowercase codes appear */
/*  all of the codes appear only one time. */


***********************************************************;
*  PRACTICE 2  (6 pts)                                    *;
*  The hw2.np_summary table contains public use statistics*;
*  from the National Park Service. The park type codes are*;
*  inconsistent for national preserves. Examine these     *;
*  inconsistencies by producing a report that lists any   *;
*  national preserve.
*  1) Use the PROC PRINT statement to list the            *; 
*     observations in HW2.NP_SUMMARY. Add a WHERE         *;
*     statement to print only the rows where ParkName     *;
*     includes Preserve. (4 pts)                          *;
*  2) Submit the program and verify the generated output. *;
*     Which codes are used for Preserves?  (2 pt)         *;
***********************************************************;

/* #1 Using the where statement as a filter */
proc print data=hw2.np_summary (obs=10);
	*where statement to filter rows;
	where upcase(parkname) like '%PRESERVE';
run;

/* #2 A, IM, SE, and PW are the codes used for Preserve */



***********************************************************;
*  PRACTICE 3 (12 pts)                                    *; 
*    Use the PROC PRINT and WHERE statements to examine   *;
*    the hw2.eu_occ table. Label and comment each step.   *;
*  1) List the rows for Country euqals Bulgaria or Malta. *;
*     Run the program. (3 pts) How many rows are included.*;
*       (1 pt)                                            *;
*  2) List the rows where Hotel is greater than 1,000,000 *;
*     and ShortStay is less than 60,000. (3 pts)          *;
*     How many rows are included. (1 pt)                  *;             
*  3) List rows where Hotel,ShortStay, and Camp are       *;
*     missing. Run the program.  (3 pts)                  *;
*     How many rows are included. (1 pt)                  *;      
***********************************************************;

PROC CONTENTS DATA=hw2.eu_occ;
RUN;

/* #1 Filtering out Bulgaria and Malta */
PROC PRINT DATA=hw2.EU_OCC;
	WHERE upcase(COUNTRY) IN ('BULGARIA' 'MALTA');
RUN;
/* 330 rows were included */


/* #2 Applying conditions to HOTEL*/

PROC PRINT DATA=HW2.EU_OCC;
	WHERE HOTEL >= 100000 AND SHORTSTAY < 60000;
RUN;

/* 2954 rows are included */


/* #3 Taking out missing rows  */
PROC PRINT DATA=HW2.EU_OCC;
where hotel is missing and shortstay is missing and camp is missing;
RUN;
/* Answer: 101 Observations */



***********************************************************;
*   PRACTICE 4 (12 pts)                                   *;
*    1) Use the PROC PRINT step to list the rows for      *;
*       variables DayVisits TentCampers and RVCampers in  *;
*       HW2.NP_SUMMARY where DayVisits is greater than    *;
*       or equal to 300,000 and Reg is equal to IM.       *;
*       (4 pts)                                           *;
*    2) How many observations are listed (1pt)            *;
*    3) Write two %LET statements to create macro         *;
*       variables named Visits and Region. Set the        *;
*       initial values of the variables to match the      *;
*       where statement. (2 pts)                          *;
*    4) Copy the code in part 1) and modify the WHERE     *;
*       statement to reference the macro variables.       *;
*       Run the code and verify if the same results are   *;
*       produced. (2 pts)                                 *;
*    5) Copy the code in parts 3) and 4).                 *;
*       Change the values of the macro variables to       *;
*       500,000 and SE. Run the code and how many         *;
*       observations are listed. (3 pts)                  *;
***********************************************************;
/* #1 listing out rows for variables */

proc print data=hw2.np_summary;
	where dayvisits >- 300000 and reg = 'IM';
run;

/* #2 52 observations are listed */


/* #3  Define a macro variable*/
%let visits = 300000;
%let region = IM;

/* #4 referencing code 1 and modifying WHERE */
proc print data=hw2.np_summary;
	where dayvisits >- &visits and reg = "&region";
run;

/* #5 changing the macros */
%let visits = 500000;
%let region = SE;

proc print data=hw2.np_summary;
	where dayvisits >- &visits and reg = "&region";
run;

***********************************************************;
*   PRACTICE 5 (6 pts)                                    *;
*    1) Use the PROC PRINT step to read the data in       *;
*       HW2.STOCKS. (2 pts)                               *;
*    2) Add a format statement to format the Open, High,  *;
*       LOW and CLOSE with a dollar sign and the Volume   *;
*       with a comma. (4 pts)                             *;
***********************************************************;



/* #1 and 2 adding a format statement to format the data */
proc print data=hw2.stocks;
	*2 format statement;
	format open high low close dollar12.2 volume comma12. date yymmdd10.;
run;


***********************************************************;
*   PRACTICE 6 (8 pts)                                    *;
*    1) Use the PROC SORT step to read HW2.NP_SUMMARY     *;
*       and create a temporary sorted table named         *;
*       NP_SORT. (2 pts)                                  *;
*    2) Add a BY statement to order the data by Reg and   *;
*       descending ParkName and descending DayVisits.     *;
*       Check the output table to verify. (4 pts)         *;
*    3) Add a WHERE statement to select Type equal to NP. *;
*       Submit the program. (2 pts)                       *;
***********************************************************;

/* #1 Sorting the table */
proc sort data=hw2.np_summary out=np_sort;
/* #2 adding the BY statement */
	by descending Reg decending ParkName;
/* 	#3 adding a WHERE statement */
	where type = 'NP';
run;


***********************************************************;
*   PRACTICE 7 (8 pts)                                    *;
*    1) Open and review the HW2.NP_LARGEPARKS table.      *;
*       Are there any exact duplicated rows for some      *;
*       parks. (2 pts)                                    *;
*    2) Write a PROC SORT step that creates two tables    *;
*       park_clean and park_dups and remove the duplicate *;
*       rows. (4 pts)                                     *;
*    3) How many duplicated rows are removed. (2 pts)     *;
***********************************************************;
/* #1 Opening and reviewing the table */
PROC PRINT DATA=HW2.NP_LARGEPARKS;
RUN;

/* #2  removing duplicates from the table */
PROC SORT DATA=HW2.NP_LARGEPARKS OUT=park_clean NODUP
	DUPOUT=park_dups;
	BY _ALL_;
RUN; 

/*#3 #30 duplicate rows were deleted */


