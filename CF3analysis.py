## This is the beginning of my matplotlib exploration

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

CF3 = pd.read_csv('AllCF3-BPS.csv')

new_cols = ['id','t','T', 'f', 'f_error', 'alpha', 'alpha_error', 'tau1', 'tau2', 'tau3','BPS']
old_cols = CF3.columns.values
map_cols = dict(zip(old_cols, new_cols))
CF3_new = CF3.rename(map_cols, axis = 1)

##I put '-' for inconclusive BPS observations (have to be filtered)
CF3_inconclusive_spots = CF3_new[CF3_new['BPS'] == '-']
CF3_conclusive_spots = CF3_new[CF3_new['BPS'] != '-']
##fixing the type of BPS to be numeric
CF3_conclusive_spots['BPS'] = CF3_conclusive_spots['BPS'].astype(float)
#print(CF3_conclusive_spots.dtypes) # wohoo, we're ready for analysis!

#### BPS Analysis
CF3_BPS0 = CF3_conclusive_spots[CF3_conclusive_spots.BPS == 0]
CF3_BPS1 = CF3_conclusive_spots[CF3_conclusive_spots.BPS == 1]
#print(CF3_BPS0, CF3_BPS1, CF3_conclusive_spots) just making sure didn't lose anything due to float == int inequality

##convert to numpy for easier use with matplotlib
CF3_BPS0_np = CF3_BPS0.to_numpy()
CF3_BPS1_np = CF3_BPS1.to_numpy()

### BPS-Diffusivity Analysis
BPS0_alpha = CF3_BPS0.alpha.to_numpy()*10**6
BPS1_alpha = CF3_BPS1.alpha.to_numpy()*10**6

##histogram
nbins = 10

plt.figure(figsize=(8,6))
plt.hist(BPS0_alpha, nbins, density=True, alpha = 0.5, label='BPS=0')
plt.hist(BPS1_alpha, nbins, density=True, alpha = 0.5, label='BPS=1')
plt.legend(loc='upper right')
plt.title('Thermally-Aged CASS CF3 Thermal Diffusivity Distributions')
plt.xlabel('Thermal Diffusivity [mm^2/s]')
plt.ylabel('Count (normalized)')

plt.show()
