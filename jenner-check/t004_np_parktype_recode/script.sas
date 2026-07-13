/* Adapted from homework/sas_hw3_Gould_Justin.sas, PRACTICE 5
   Original read hw3.np_summary via a LIBNAME pointing at the author's
   SAS Studio home folder. Substituted a small inline sample here with
   a Type column covering every code branch (NP, NM, NPRE/PRE/PRESERVE,
   NS, RVR/RIVERWAYS) so the IF-THEN/ELSE recoding and PROC FREQ run
   unmodified against real values, including the LENGTH fix the
   assignment calls for after noticing ParkType gets truncated without it. */

data np_summary;
	length Type $8;
	input Type $ ParkName $;
	datalines;
NP Yellowstone
NP Yosemite
NM Devils_Tower
NM Muir_Woods
NPRE Big_Cypress
PRE Mojave
NS Cape_Hatteras
NS Padre_Island
RVR Buffalo_River
RIVERWAYS Ozark
;
run;

/* #2 & #3: IF-THEN/ELSE to create ParkType, with LENGTH to avoid truncation */
data park_type;
	set np_summary;
	length parktype $8;
	if type = 'NP' then parktype = 'Park';
		else if type = 'NM' then parktype = 'Monument';
		else if type in ('NPRE' 'PRE' 'PRESERVE') then parktype = 'Preserve';
		else if type = 'NS' then parktype = 'Seashore';
		else parktype = 'River';
run;

/* #4 PROC FREQ report for ParkType */
proc freq data=park_type;
	table parktype;
run;
