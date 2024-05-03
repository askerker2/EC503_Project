Main code for PCA denoising: PCA_WaveStacking_v2.m

To run code, first add the "ECG SIGNAL PQRST PEAK DETECTION TOOLBOX"
	https://www.mathworks.com/matlabcentral/fileexchange/73850-ecg-signal-pqrst-peak-detection-toolbox
	R. Sanghavi, F. Chheda, S. Kanchan and S. Kadge, "Detection Of Atrial Fibrillation in Electrocardiogram Signals using Machine Learning," 2021 2nd Global Conference for Advancement in Technology (GCAT), 2021, pp. 1-6, doi: 10.1109/GCAT52182.2021.9587664.


Script assumes user is running with "PCA" as the current working directory. Parent directory contains 'mitdb_dataset.mat'

Need to have the following in current folder (included in git):
createSignalPlusNoise.m --> used to add Gaussian noise to ECG signals
lin10.m --> called within createSignalPlusNoise.m
ecgsCentered.m --> part of the pre-processing for PCA, called in PCA_denoisingMIT.m
PCA_denoisingMIT.m --> handles the segmentation, PCA denoising, and reconstruction of an ECG signal

PCA_WaveStacking_v2 takes about 3 minutes to run in full:

It loads ECG data from all 48 records in MIT Database.
For each record, the appropriate noise is added to generate noisyECG
pan_tompkin2 (from "ECG SIGNAL PQRST PEAK DETECTION TOOLBOX") is used to identify R peaks and calculate intervals on each noisy signal.
The signal is segmented to perform PCA.
Each feature vector in X is one RRsegment of noisyECG
First principal component used to generate estimated Segments
Segments are then sequentially pieced back together to generate the denoised signal

Plots are generated of record 4 illustrating performance for all 6 experiements (3 Gaussian, 3 EM)

Use the code at line 95 to generate exploratory plots, choosing patient number and experiment number.