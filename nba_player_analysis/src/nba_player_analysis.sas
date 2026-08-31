*************************************************************;
*  Group Project - NBA Players Analysis                     *;
                                                            *;
*  Team Members: Justin Gould          *;
                                                            *;
*  Dataset: NBA 2020-21 Season Player Data                  *;    
                                                            *;
*  How does a player’s age impact their in-game statistics? *;
*   Stats such as assists (AST), Player Efficiency Rating   *;
*   (PER), and True Shooting Percentage (TS%) can all be    *;
*   considered as major variables that can determine the    *;
*   players skill level. The proc mean and DATA SAS steps   *;
*   can be utilized to perform in-depth analysis on both the*;
*   players and the variables.                              *;
*************************************************************;

*************************************************************;
*  User Warning: You will need to alter the paths in the    *;
*  LIBNAME and PROC IMPORT steps to meet your specific      *;
*  working directory requirements                           *;
                                                            *;
*************************************************************;


/* Step 1: Set the Library: */
LIBNAME nba "/home/u64436407/STA 4133/final project";


/* Step 2: Load the NBA players datasets */
PROC IMPORT 
    datafile='/home/u64436407/STA 4133/final project/player_salary.csv'
    dbms=csv
    out=nba.salary
    replace;
    getnames=yes;
    guessingrows=max;
RUN;

PROC IMPORT
	datafile= '/home/u64436407/STA 4133/final project/per_game_stats.csv' 
	dbms=csv
	out=nba.game_stats 
	replace;
	getnames=yes;
    guessingrows=max;
RUN;

PROC IMPORT
	datafile= '/home/u64436407/STA 4133/final project/advanced_stats.csv' 
	dbms=csv
	out=nba.advanced_stats 
	replace;
	getnames=yes;
    guessingrows=max;
RUN;


/* Step 3: Review the contents within the data and count the variables */
PROC CONTENTS data=nba.salary;
RUN;

PROC CONTENTS data=nba.advanced_stats;
RUN;

PROC CONTENTS data=nba.game_stats;
RUN;


/* Step 4: Sort the variables before merging */
PROC SORT data=nba.salary nodupkey;
	by id;
RUN;

PROC SORT data=nba.advanced_stats;
	by id;
RUN;
PROC SORT data=nba.game_stats;
	by id;
RUN;


/* Step 5: Merge the three datasets on ID and remove unnessasary columns */
DATA main;
	merge nba.salary 
		  nba.game_stats (drop=G MP) 
		  nba.advanced_stats;
	by id ;
	keep player Season Age Pos Tm MP
		 G PER BPM VORP WS PTS AST 
		 TRB STL BLK TOV 'TS.'n ID;
RUN;



/* #Optional: View Outliers */
PROC UNIVARIATE data=main;
    var G;
    id G; /* Puts the ID/Name next to the extreme values in the report */
RUN;


/* Step 6: Format the variables and remove outliers */
DATA final;
    set main;

    where Age is not missing and G >= 10 ;

    rename
        player  = player_name
        Season  = NBA_season
        Age     = player_age
        Pos     = Position
        Tm      = Team
        MP      = minutes_played
        G       = games_played
        PER     = player_efficiency_rating
        BPM     = box_plus_minus
        VORP    = value_over_replacement_player
        WS      = win_shares
        'TS.'n  = true_shooting_pct
        ID      = player_id;

    /* Convert character variables to numeric */
    points_scored   = input(strip(PTS), best32.);
    Assists         = input(strip(AST), best32.);
    total_rebounds  = input(strip(TRB), best32.);
    Steals          = input(strip(STL), best32.);
    Blocks          = input(strip(BLK), best32.);
    Turnovers       = input(strip(TOV), best32.);

    drop PTS AST TRB STL BLK TOV;
RUN;



/* Step 7: Calculate the average per position AND age */
PROC MEANS data=final mean noprint nway;
    class player_age;

    var Blocks Steals minutes_played
        player_efficiency_rating
        box_plus_minus
        win_shares
        points_scored
        Assists
        total_rebounds
        Turnovers
        true_shooting_pct
        value_over_replacement_player;

    output out=player_avg(drop=_TYPE_)
        mean=Blocks_avg
             Steals_avg
             Minutes_avg
             PER_avg
             BPM_avg
             WS_avg
             Points_avg
             Assists_avg
             Rebounds_avg
             Turnovers_avg
             TS_avg
             VORP_avg;
RUN;


/* Visial 1: View the player age distribution */
title 'Age Distribution';
ODS GRAPHICS ON;
PROC SGPLOT data=player_avg NOAUTOLEGEND;
    vbar player_age / response=_freq_ stat=sum;
    xaxis label="Player Age";
    yaxis label="Number of Players";
RUN;
title;
ODS GRAPHICS OFF;


/* Step 8: MAIN DATASET Remove outliers of players whose age category appears less than 5 times. */
DATA player_avg;
    set player_avg;

    if _FREQ_ >= 5;
RUN;


title 'Points By Age';
ODS GRAPHICS ON;
PROC SGPLOT data=player_avg NOAUTOLEGEND;
    vbar player_age / response=Points_avg;
    xaxis label="Player Age";
    yaxis label="Average Points"
    	min=5 
    	max=15;
RUN;
title;
ODS GRAPHICS OFF;



/* Visual 2: Age effect on Efficiency ratings */
PROC SGPLOT data=player_avg NOAUTOLEGEND;

    series x=player_age y=Per_avg /
        lineattrs=(color=black thickness=2);

    scatter x=player_age y=Per_avg /
        markerattrs=(symbol=circlefilled size=8);

    xaxis grid label="Player Age";
    yaxis grid label="Average Player Efficiency Rating";
    title "The Effect of Age on Player Efficiency";
    
RUN;

/* Visual 3: Age effect on Blocks */
PROC SGPLOT data=player_avg NOAUTOLEGEND;

    series x=player_age y=Blocks_avg /
        lineattrs=(color=black thickness=2);

    scatter x=player_age y=Blocks_avg /
        markerattrs=(symbol=circlefilled size=8);

    xaxis grid label="Player Age";
    yaxis grid label="Blocks";
    title "Blocks";
    
RUN;

/* Visual 4: Age effect on Steals */
PROC SGPLOT data=player_avg NOAUTOLEGEND;

    series x=player_age y=Steals_avg /
        lineattrs=(color=black thickness=2);

    scatter x=player_age y=Steals_avg /
        markerattrs=(symbol=circlefilled size=8);

    xaxis grid label="Player Age";
    yaxis grid label="Steals";
    title "The Effect of Age on Average Steals";
    
RUN;

/* Visual 5: Age effect on BPM rating */
PROC SGPLOT data=player_avg NOAUTOLEGEND;

    series x=player_age y=BPM_avg /
        lineattrs=(color=black thickness=2);

    scatter x=player_age y=BPM_avg /
        markerattrs=(symbol=circlefilled size=8);

    xaxis grid label="Player Age";
    yaxis grid label="Box/Plus Minus";
    title "The Effect of Age on BPM";
    
RUN;

/* Visual 6: Age effect on VORP */
PROC SGPLOT data=player_avg NOAUTOLEGEND;

    series x=player_age y=VORP_avg /
        lineattrs=(color=black thickness=2);

    scatter x=player_age y=VORP_avg /
        markerattrs=(symbol=circlefilled size=8);

    xaxis grid label="Player Age";
    yaxis grid label="VORP";
    title "The Effect of Age on VORP";
    
RUN;

/* Additional Graphs: Age effect on assists */
PROC SGPLOT data=player_avg NOAUTOLEGEND;

    series x=player_age y=Assists_avg /
        lineattrs=(color=black thickness=2);

    scatter x=player_age y=Assists_avg /
        markerattrs=(symbol=circlefilled size=8);

    xaxis grid label="Player Age";
    yaxis grid label="Assists";
    title "The Effect of Age on Assists";
RUN;

/* Additional Graphs: Age effect on rebounds */
PROC SGPLOT data=player_avg NOAUTOLEGEND;

    series x=player_age y=Rebounds_avg /
        lineattrs=(color=black thickness=2);

    scatter x=player_age y=Rebounds_avg /
        markerattrs=(symbol=circlefilled size=8);

    xaxis grid label="Player Age";
    yaxis grid label="Rebounds";
    title "The Effect of Age on Rebounds";
    
RUN;
