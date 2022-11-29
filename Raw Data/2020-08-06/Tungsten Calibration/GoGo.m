%%%%%%%%%%%%%%%%%%%
%Either run from directory containing all raw TGS data files for this exposure, or change directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
%Either run from directory containing all raw TGS data files for this exposure, or change directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

grat=7.6; 	% pulled from metadata in first file, in microns
overlay1="Date: 8-6-2020,   Time: 10:18,   \lambda=7.6\mu m"	% pulled from metadata in first file
overlay2="Study: Tungsten-Calibration,   Sample: 2020-08-06"	% pulled from metadata in first file

posstr="Tungsten-Calibration-2020-08-06-07.60um-spot0-POS-1.txt";
negstr="Tungsten-Calibration-2020-08-06-07.60um-spot0-NEG-1.txt";

EndTime=2.000500E-7	% automatically extracted from first file to analyze

TimeIndex=-1  % Loop through these in a script to determine the best one

TGSPhaseAnalysis(posstr,negstr,grat,2,0,EndTime,TimeIndex,overlay1,overlay2);
%%%%%%%%%%%%%%%%%%%
%Either run from directory containing all raw TGS data files for this exposure, or change directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

grat=7.6; 	% pulled from metadata in first file, in microns
overlay1="Date: 8-6-2020,   Time: 10:19,   \lambda=7.6\mu m"	% pulled from metadata in first file
overlay2="Study: Tungsten-Calibration,   Sample: 2020-08-06"	% pulled from metadata in first file

posstr="Tungsten-Calibration-2020-08-06-07.60um-spot1-POS-1.txt";
negstr="Tungsten-Calibration-2020-08-06-07.60um-spot1-NEG-1.txt";

EndTime=2.000500E-7	% automatically extracted from first file to analyze

TimeIndex=-1  % Loop through these in a script to determine the best one

TGSPhaseAnalysis(posstr,negstr,grat,2,0,EndTime,TimeIndex,overlay1,overlay2);
%%%%%%%%%%%%%%%%%%%
%Either run from directory containing all raw TGS data files for this exposure, or change directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

grat=7.6; 	% pulled from metadata in first file, in microns
overlay1="Date: 8-6-2020,   Time: 10:21,   \lambda=7.6\mu m"	% pulled from metadata in first file
overlay2="Study: Tungsten-Calibration,   Sample: 2020-08-06"	% pulled from metadata in first file

posstr="Tungsten-Calibration-2020-08-06-07.60um-spot2-POS-1.txt";
negstr="Tungsten-Calibration-2020-08-06-07.60um-spot2-NEG-1.txt";

EndTime=2.000500E-7	% automatically extracted from first file to analyze

TimeIndex=-1  % Loop through these in a script to determine the best one

TGSPhaseAnalysis(posstr,negstr,grat,2,0,EndTime,TimeIndex,overlay1,overlay2);
%%%%%%%%%%%%%%%%%%%
%Either run from directory containing all raw TGS data files for this exposure, or change directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

grat=7.6; 	% pulled from metadata in first file, in microns
overlay1="Date: 8-6-2020,   Time: 10:23,   \lambda=7.6\mu m"	% pulled from metadata in first file
overlay2="Study: Tungsten-Calibration,   Sample: 2020-08-06"	% pulled from metadata in first file

posstr="Tungsten-Calibration-2020-08-06-07.60um-spot3-POS-1.txt";
negstr="Tungsten-Calibration-2020-08-06-07.60um-spot3-NEG-1.txt";

EndTime=2.000500E-7	% automatically extracted from first file to analyze

TimeIndex=-1  % Loop through these in a script to determine the best one

TGSPhaseAnalysis(posstr,negstr,grat,2,0,EndTime,TimeIndex,overlay1,overlay2);
%%%%%%%%%%%%%%%%%%%
%Either run from directory containing all raw TGS data files for this exposure, or change directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

grat=7.6; 	% pulled from metadata in first file, in microns
overlay1="Date: 8-6-2020,   Time: 10:24,   \lambda=7.6\mu m"	% pulled from metadata in first file
overlay2="Study: Tungsten-Calibration,   Sample: 2020-08-06"	% pulled from metadata in first file

posstr="Tungsten-Calibration-2020-08-06-07.60um-spot4-POS-1.txt";
negstr="Tungsten-Calibration-2020-08-06-07.60um-spot4-NEG-1.txt";

EndTime=2.000500E-7	% automatically extracted from first file to analyze

TimeIndex=-1  % Loop through these in a script to determine the best one

TGSPhaseAnalysis(posstr,negstr,grat,2,0,EndTime,TimeIndex,overlay1,overlay2);
quit;
