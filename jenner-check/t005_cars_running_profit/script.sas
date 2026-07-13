/* Adapted from homework/sas_hw4_Gould.sas, PRACTICE 7
   Original reads sashelp.shoes, a table shipped with SAS itself, and its
   BY-group running-total logic (first./last., accumulator reset, format
   as currency) is otherwise reproduced verbatim below. Jenner's sashelp
   library doesn't currently include SHOES, so this bundle points the
   same code at sashelp.cars instead (also SAS-shipped, no upload
   required) using its equivalent Origin/Type grouping columns in place
   of Region/Product and MSRP/Invoice in place of Sales/Returns. */

/* #1 create and sort */
proc sort data=sashelp.cars out=cars_sorted;
	by origin type;
run;

/* #2, #3, #4, #5: running total of Profit within Origin/Type,
   keeping only the last row per group */
data profitsummary;
	set cars_sorted;
	profit = msrp - invoice;
	by origin type;
	if first.type = 1 then totalprofit = 0;
		totalprofit + profit;
	if last.type = 1 then output;
	/* #7 */
	keep origin type totalprofit;
	/* #8 format as currency */
	format totalprofit dollar12.;
run;

proc print data=profitsummary;
run;
