# 2022-CASS-Aging-TGS

## "CASS Charpy Data-RoomT 2020Jan.xlsx"
Charpy Data of all CASS samples at different aging conditions. Rows highlighted in yellow represent CF3 data. Received from TS Byun on Jan 2020. Data can be used to make the Charpy Energy vs. Aging Condition.

## "ALLCF3-BPS.csv"
13 samples, 40 spots per sample, 520 rows. Columns represent TGS signals' extracted functional parameters table + an additional column I calculated manually called "binary peak split" by eye balling TGS signals time-domain and frequency-domain to determine whether there is peak splitting "1", no speak splitting "0", or inconclusive "-".

## "CF3analysis.py"
Reads "ALLCF3-BPS.csv" and plots the two histograms. Doesn't calculate p-value. I wrote this so we can make prettier plots for the paper.

## "TGS_CASS_CF3.RData"
Same as "ALLCF3-BPS.csv" but in a format that can be loaded to R's workspace.

## "TGSCASS_Analysis.R"
Performs the statictical analysis including the t-test that gives the primary result of our work. Plots the histograms overlayed with vertical lines at the means of each histogram and labels the p-value on the plot.  

