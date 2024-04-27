clear; close all; 
rng("default")

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

%Initialize empty matrices for Training
mses = zeros(length(lambda_range),length(ecg));
snr_imp = zeros(length(lambda_range),length(ecg));
prd = zeros(length(lambda_range),length(ecg));
den_sigs = cell(length(lambda_range),length(ecg));

%Initialize Variables
noise_scaling_factor = 0.2; 
start_time = 350; 
end_time = 370; 

%Loop through each training ECG
for i = 1:length(training_ecg)
    orig_sig = training_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(training_ecg{i,1}(start_time*Fs:end_time*Fs));
    orig_sig_plus_noise = orig_sig+em_noise(start_time*Fs:end_time*Fs)*noise_scaling_factor; 
    
    t = (1:length(orig_sig))/Fs;
    count = 1; 
    
    for lambda = lambda_range
        [denoisedSig,~] = NLM_1dDarbon(orig_sig_plus_noise,lambda,P,PatchHW);
        nanvals = ~isnan(denoisedSig);
        denoisedSig = (denoisedSig(~isnan(denoisedSig)));
        den_sigs{count,i} = denoisedSig;  
        orig_sig_plus_noise_nonan = (orig_sig_plus_noise(~isnan(denoisedSig)));
        orig_sig_no_nan = (orig_sig(~isnan(denoisedSig)));
        denoisedSig = denoisedSig(1:end-11); 
        orig_sig_no_nan = orig_sig_no_nan(12:end);
        orig_sig_plus_noise_nonan = orig_sig_plus_noise_nonan(12:end);

        
        mses(count,i) = mean((orig_sig_no_nan-denoisedSig).^2);
        snr_imp(count,i) = 10*log10(sum((orig_sig_plus_noise_nonan-orig_sig_no_nan).^2)/sum((denoisedSig-orig_sig_no_nan).^2));
        prd(count,i) = 100*sqrt(sum((denoisedSig-orig_sig_no_nan).^2)/sum(orig_sig_no_nan.^2));
        count = count+1; 
    end 
end


%% Plot Training Data MSE & SNR Improvement

figure; 
subplot(2,1,1);
plot(lambda_range,mean(mses,2),'LineWidth',2);
title("Training MSE")
xlabel('Lambda')
ylabel('MSE')
subplot(2,1,2);
plot(lambda_range,mean(snr_imp,2),'LineWidth',2);
title("SNR Improvement")
ylabel('SNR Improvement (dB)')
xlabel('Lambda)')

sgtitle('Training Metric Functions');


%%

i = 6; 
figure; 
orig_sig = ecg{i,1}(350*Fs:370*Fs) - mean(ecg{i,1}(350*Fs:370*Fs));
orig_sig_plus_noise = orig_sig+em_noise(350*Fs:370*Fs)*0.2; 
orig_sig = orig_sig(Fs:end);
orig_sig_plus_noise = orig_sig_plus_noise(Fs:end);    
        orig_sig = orig_sig(12:end);
        orig_sig_plus_noise = orig_sig_plus_noise(12:end);
subplot(4,1,1); hold on; 
denoisedSig = den_sigs{1,i};
plot(orig_sig);
plot(orig_sig_plus_noise);
plot(denoisedSig);
m = num2str(mses(1,i));
p = num2str(prd(1,i));
s = num2str(snr_imp(1,i));
ti = strcat('MSE: ',m, ' SNR: ', s, " PRD: ",p);
title(ti); 
subplot(4,1,2); hold on; 
denoisedSig = den_sigs{2,i};

plot(orig_sig);
plot(orig_sig_plus_noise);
plot(denoisedSig);
m = num2str(mses(2,i));
p = num2str(prd(2,i));
s = num2str(snr_imp(2,i));
ti = strcat('MSE: ',m, ' SNR: ', s, " PRD: ",p);
title(ti); 
subplot(4,1,3); hold on; 
denoisedSig = den_sigs{3,i};
plot(orig_sig);
plot(orig_sig_plus_noise);
plot(denoisedSig);
m = num2str(mses(3,i));
p = num2str(prd(3,i));
s = num2str(snr_imp(3,i));
ti = strcat('MSE: ',m, ' SNR: ', s, " PRD: ",p);
title(ti); 

subplot(4,1,4); hold on; 
denoisedSig = den_sigs{4,i};
plot(orig_sig);
plot(orig_sig_plus_noise);
plot(denoisedSig);
m = num2str(mses(4,i));
p = num2str(prd(4,i));
s = num2str(snr_imp(4,i));
ti = strcat('MSE: ',m, ' SNR: ', s, " PRD: ",p);
title(ti); 
