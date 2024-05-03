# EC503_Project
By Steven Hopkins, Sergio Rodriguez, Abigail Skerker 

## Intro

Welcome to the repository for the denoising analysis of the MIT-BIH Arrhythmia Database using Principal Component Analysis (PCA), Independent Component Analysis (ICA), and Non-Local Means (NLM). This repository contains the dataset, MATLAB files, and supporting functions utilized in our research project to explore and evaluate various denoising techniques applied to ECG signals.

The MIT-BIH Arrhythmia Database is a widely used dataset in the field of cardiology, comprising annotated ECG recordings with diverse arrhythmias and noise types. Leveraging this dataset, our research aims to assess the efficacy of PCA, ICA, and NLM algorithms in reducing noise while preserving the diagnostic information present in ECG signals.

Within this repository, you will find:

 - The MIT-BIH Arrhythmia Database, providing access to the raw ECG recordings and corresponding annotations.
 - MATLAB files containing the implementation of denoising algorithms, including PCA, ICA, and NLM, tailored for analyzing ECG signals.
 - Supporting functions and scripts utilized in data preprocessing, algorithm implementation, and result analysis.

## Dataset
([MIT-BIH Dataset](https://www.physionet.org/content/nstdb/1.0.0/)
- mitdb_dataset.mat 
  - Moody GB, Muldrow WE, Mark RG. A noise stress test for arrhythmia detectors. Computers in Cardiology 1984; 11:381-384.
- em_noise.mat

## Dependencies/Add-On

- Signal Processing Toolbox by MathWorks
- ECG SIGNAL PQRST PEAK DETECTION TOOLBOX Version 2.1.4 (2.43 MB) by Rohan Sanghavi
- PCA and ICA Package Version 2.2.0.0 (2.12 MB) by Brian Moore
- Statistics and Machine Learning Toolbox by MathWorks
  
## PCA Files

- PCA_WaveStacking_v2.m - Main script
- ecgsCentered.m - part of the pre-processing for PCA, called in PCA_denoisingMIT.m
- PCA_denoisingMIT.m - handles the segmentation, PCA denoising, and reconstruction of an ECG signal

## ICA Files

- ICA_Final.mlx - Main Script
- ICA_testing.mlx - Small scale signal testing

## NLM Files

- NLM_Final_Code3.m - Main code to implement NLM
- NLM_CreateFigures.m - Create NLM Figures
- NLM_1dDarbon.m
  - Tracey BH, Miller EL. Nonlocal means denoising of ECG signals. IEEE Trans Biomed Eng. 2012;59(9):2383-2386. doi:10.1109/TBME.2012.2208964 

## Supporting Files

##### Code to add Gaussian Noise: 
(Tracey BH, Miller EL. Nonlocal means denoising of ECG signals. IEEE Trans Biomed Eng. 2012;59(9):2383-2386. doi:10.1109/TBME.2012.2208964)
- lin10.m 
- createSignalPlusNoise.m 
