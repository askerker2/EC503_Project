clear; close all; 
rng("default")

tic

load mitdb_dataset.mat
load em_noise.mat

Fs = 360;  %Frequency
PatchHW=10;  % patch half-width; ~ size of smallest feature, in samples
P = 2000;    % neighborhood search width; wider=more computation but more
lambda_range = 0.025:0.025:.4; %Lambda Values to Test

%Generate Training and Testing Datasets: 
size_of_full_dataset = length(ecg);
size_of_training_dataset = round(0.8*size_of_full_dataset);
training_data_indices = randperm(size_of_full_dataset,size_of_training_dataset);
training_ecg = ecg(training_data_indices,1);
testing_data_indices = [];
for i = 1:size_of_full_dataset
    if ~ismember(i, training_data_indices)
        testing_data_indices = [testing_data_indices, i];
    end 
end 
testing_ecg = ecg(testing_data_indices,1);


%%

%Initialize empty matrices for Training
mses = zeros(length(lambda_range),length(training_ecg));
snr_imp = zeros(length(lambda_range),length(training_ecg));
prd = zeros(length(lambda_range),length(training_ecg));
den_sigs = cell(length(lambda_range),length(training_ecg));

%Initialize Variables
noise_scaling_factor = 0.2; 
start_time = 250; 
end_time = 350; 

noise = em_noise*noise_scaling_factor;
noiseType = 'em';
[training_mses_em_p2, training_snr_imp_em_p2, training_den_sigs_em_p2] = Run_NLM(training_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);
[testing_mses_em_p2, testing_snr_imp_em_p2, testing_den_sigs_em_p2] = Run_NLM(testing_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);

noise_scaling_factor = 0.4; 
noise = em_noise*noise_scaling_factor;

lambda_range = 0.025:0.025:.8; %Lambda Values to Test

[training_mses_em_p4, training_snr_imp_em_p4, training_den_sigs_em_p4] = Run_NLM(training_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);
[testing_mses_em_p4, testing_snr_imp_em_p4, testing_den_sigs_em_p4] = Run_NLM(testing_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);

lambda_range = 0.025:0.025:.6; %Lambda Values to Test

noise_scaling_factor = 0.3; 
noise = em_noise*noise_scaling_factor;

[training_mses_em_p3, training_snr_imp_em_p3, training_den_sigs_em_p3] = Run_NLM(training_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);
[testing_mses_em_p3, testing_snr_imp_em_p3, testing_den_sigs_em_p3] = Run_NLM(testing_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);

lambda_range = 0.025:0.025:.4; %Lambda Values to Test

noise_scaling_factor = 0.1; 
noise = em_noise*noise_scaling_factor;

[training_mses_em_p1, training_snr_imp_em_p1, training_den_sigs_em_p1] = Run_NLM(training_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);
[testing_mses_em_p1, testing_snr_imp_em_p1, testing_den_sigs_em_p1] = Run_NLM(testing_ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs);

noiseType = 'ga';
targetSNR_dB = 12; 

[training_mses_ga_12, training_snr_imp_ga_12, training_den_sigs_ga_12] = Run_NLM(training_ecg,noiseType,targetSNR_dB,start_time,end_time,lambda_range, P, PatchHW, Fs);
[testing_mses_ga_12, testing_snr_imp_ga_12, testing_den_sigs_ga_12] = Run_NLM(testing_ecg,noiseType,targetSNR_dB,start_time,end_time,lambda_range, P, PatchHW, Fs);

noiseType = 'ga';
targetSNR_dB = 6; 

[training_mses_ga_6, training_snr_imp_ga_6, training_den_sigs_ga_6] = Run_NLM(training_ecg,noiseType,targetSNR_dB,start_time,end_time,lambda_range, P, PatchHW, Fs);
[testing_mses_ga_6, testing_snr_imp_ga_6, testing_den_sigs_ga_6] = Run_NLM(testing_ecg,noiseType,targetSNR_dB,start_time,end_time,lambda_range, P, PatchHW, Fs);

noiseType = 'ga';
targetSNR_dB = 2; 

[training_mses_ga_2, training_snr_imp_ga_2, training_den_sigs_ga_2] = Run_NLM(training_ecg,noiseType,targetSNR_dB,start_time,end_time,lambda_range, P, PatchHW, Fs);
[testing_mses_ga_2, testing_snr_imp_ga_2, testing_den_sigs_ga_2] = Run_NLM(testing_ecg,noiseType,targetSNR_dB,start_time,end_time,lambda_range, P, PatchHW, Fs);

toc
%% Run NLM Function

function [mses, snr_imp, den_sigs] = Run_NLM(ecg,noiseType,noise,start_time,end_time,lambda_range, P, PatchHW, Fs)

    %Initialize empty matrices
    mses = zeros(length(lambda_range),length(ecg));
    snr_imp = zeros(length(lambda_range),length(ecg));
    den_sigs = cell(length(lambda_range),length(ecg));
    
    %Loop through each ECG
    for i = 1:length(ecg)
        orig_sig = ecg{i,1}(start_time*Fs:end_time*Fs) - mean(ecg{i,1}(start_time*Fs:end_time*Fs));
        if strcmp(noiseType,'em')
            orig_sig_plus_noise = orig_sig+noise(start_time*Fs:end_time*Fs); 
        else 
            [orig_sig_plus_noise,~] = createSignalPlusNoise(orig_sig,noise);    
        end 

        t = (1:length(orig_sig))/Fs;
        count = 1; 
        
        for lambda = lambda_range
            [denoisedSig,~] = NLM_1dDarbon(orig_sig_plus_noise,lambda,P,PatchHW);
            denoisedSig = (denoisedSig(~isnan(denoisedSig)));
            den_sigs{count,i} = denoisedSig;  
            orig_sig_plus_noise_nonan = (orig_sig_plus_noise(~isnan(denoisedSig)));
            orig_sig_no_nan = (orig_sig(~isnan(denoisedSig)));
            denoisedSig = denoisedSig(1:end-11); 
            orig_sig_no_nan = orig_sig_no_nan(12:end);
            orig_sig_plus_noise_nonan = orig_sig_plus_noise_nonan(12:end);
            
            mses(count,i) = mean((orig_sig_no_nan-denoisedSig).^2);
            snr_imp(count,i) = 10*log10(sum((orig_sig_plus_noise_nonan-orig_sig_no_nan).^2)/sum((denoisedSig-orig_sig_no_nan).^2));
            count = count+1; 
        end 

    end

end 