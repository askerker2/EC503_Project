%% Plot Training Data MSE & SNR Improvement

% figure; 
% hold on; 
% lambda_range = 0.025:0.025:.4; %Lambda Values to Test
% plot(lambda_range,mean(training_mses_em_p1,2),'LineWidth',2);
% plot(lambda_range,mean(training_mses_em_p2,2),'LineWidth',2);
% plot(lambda_range,mean(training_mses_em_p3(1:16,:),2),'LineWidth',2);
% xlabel('Lambda')
% ylabel('MSE')
% title('EM Noise Training MSE');
% legend("0.1 Noise","0.2 Noise","0.3 Noise")
% 
% figure; 
% hold on; 
% lambda_range = 0.025:0.025:.4; %Lambda Values to Test
% plot(lambda_range,mean(training_mses_ga_12,2),'LineWidth',2);
% plot(lambda_range,mean(training_mses_ga_6,2),'LineWidth',2);
% plot(lambda_range,mean(training_mses_ga_2,2),'LineWidth',2);
% xlabel('Lambda')
% ylabel('MSE')
% title('Gaussian Noise Training MSE');
% legend("12dB Noise","6dB Noise","2dB Noise")

figure; 
hold on; 
lambda_range = 0.025:0.025:.4; %Lambda Values to Test
plot(lambda_range,mean(training_snr_imp_em_p1,2),'LineWidth',2);
plot(lambda_range,mean(training_snr_imp_em_p2,2),'LineWidth',2);
plot(lambda_range,mean(training_snr_imp_em_p3(1:16,:),2),'LineWidth',2);
xlabel('Lambda')
ylabel('SNR Improvement (dB)')
title('EM Noise Training SNR Improvement');
legend("0.1 Noise","0.2 Noise","0.3 Noise")
ylim([-4, 8])

figure; 
hold on; 
lambda_range = 0.025:0.025:.4; %Lambda Values to Test
plot(lambda_range,mean(training_snr_imp_ga_12,2),'LineWidth',2);
plot(lambda_range,mean(training_snr_imp_ga_6,2),'LineWidth',2);
plot(lambda_range,mean(training_snr_imp_ga_2,2),'LineWidth',2);
xlabel('Lambda')
ylabel('SNR Improvement (dB)')
title('Gaussian Noise SNR Improvement');
legend("12dB Noise","6dB Noise","2dB Noise")
ylim([-4, 8])

%% Plot Results

figure; 
i = 1; 
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
orig_sig_plus_noise = orig_sig+em_noise(start_time*Fs:end_time*Fs)*0.1;    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
subplot(3,1,1)
mean_mses = mean(training_mses_em_p1,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_em_p1{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
legend('Original ECG','Noised ECG','Denoised ECG')
title('0.1 EM Noise')

subplot(3,1,2)
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
orig_sig_plus_noise = orig_sig+em_noise(start_time*Fs:end_time*Fs)*0.2;    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
mean_mses = mean(training_mses_em_p2,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_em_p2{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
%legend('Original ECG','Noised ECG','Denoised ECG')
title('0.2 EM Noise')

subplot(3,1,3)
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
orig_sig_plus_noise = orig_sig+em_noise(start_time*Fs:end_time*Fs)*0.3;    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
mean_mses = mean(training_mses_em_p3,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_em_p3{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
%legend('Original ECG','Noised ECG','Denoised ECG')
title('0.3 EM Noise')

figure; 
noise = 12; 
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
[orig_sig_plus_noise,~] = createSignalPlusNoise(orig_sig,noise);    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
subplot(3,1,1)
mean_mses = mean(training_mses_ga_12,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_ga_12{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
legend('Original ECG','Noised ECG','Denoised ECG')
title('12dB Gaussian Noise')

subplot(3,1,2)
noise = 6; 
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
[orig_sig_plus_noise,~] = createSignalPlusNoise(orig_sig,noise);    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
mean_mses = mean(training_mses_ga_6,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_ga_6{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
%legend('Original ECG','Noised ECG','Denoised ECG')
title('6dB Gaussian Noise')

subplot(3,1,3)
noise = 2; 
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
[orig_sig_plus_noise,~] = createSignalPlusNoise(orig_sig,noise);    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
mean_mses = mean(training_mses_ga_2,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_ga_2{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
%legend('Original ECG','Noised ECG','Denoised ECG')
title('2dB Gaussian Noise')

%%
figure; 
subplot(2,1,2)
noise = 2; 
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
[orig_sig_plus_noise,~] = createSignalPlusNoise(orig_sig,noise);    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
mean_mses = mean(training_mses_ga_12,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_ga_2{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
legend('Original ECG','Noised ECG','Denoised ECG')
title('2dB Gaussian Noise')

subplot(2,1,1)
orig_sig = testing_ecg{i,1}(start_time*Fs:end_time*Fs) - mean(testing_ecg{i,1}(start_time*Fs:end_time*Fs));
orig_sig_plus_noise = orig_sig+em_noise(start_time*Fs:end_time*Fs)*0.3;    
orig_sig = orig_sig(12:end);
orig_sig_plus_noise = orig_sig_plus_noise(12:end);
mean_mses = mean(training_mses_em_p2,2);
[me,idx] = min(mean_mses);
den_sig = testing_den_sigs_em_p3{idx,i};
t = (1:length(orig_sig))/Fs;
t2 = (1:length(den_sig))/Fs;
hold on; 
plot(t,orig_sig,'LineWidth',1);
plot(t,orig_sig_plus_noise,'LineWidth',1);
plot(t2,den_sig,'LineWidth',1);
xlim([0,5]);
xlabel('Time (s)')
legend('Original ECG','Noised ECG','Denoised ECG')
title('0.3 EM Noise')

% 
% subplot(4,1,1); hold on; 
% denoisedSig = den_sigs{1,i};
% plot(orig_sig);
% plot(orig_sig_plus_noise);
% plot(denoisedSig);
% m = num2str(mses(1,i));
% p = num2str(prd(1,i));
% s = num2str(snr_imp(1,i));
% ti = strcat('MSE: ',m, ' SNR: ', s, " PRD: ",p);
% title(ti); 
% subplot(4,1,2); hold on; 
% denoisedSig = den_sigs{2,i};

%% 

mean_snrs = mean(training_snr_imp_em_p1,2);
[me,idx] = max(mean_snrs);
snr_out(1) = mean(testing_snr_imp_em_p1(idx,:));

mean_snrs = mean(training_snr_imp_em_p2,2);
[me,idx] = max(mean_snrs);
snr_out(2) = mean(testing_snr_imp_em_p2(idx,:));

mean_snrs = mean(training_snr_imp_em_p3,2);
[me,idx] = max(mean_snrs);
snr_out(3) = mean(testing_snr_imp_em_p3(idx,:));

mean_snrs = mean(training_snr_imp_ga_12,2);
[me,idx] = max(mean_snrs);
snr_out(4) = mean(testing_snr_imp_ga_12(idx,:));

mean_snrs = mean(training_snr_imp_ga_6,2);
[me,idx] = max(mean_snrs);
snr_out(5) = mean(testing_snr_imp_ga_6(idx,:));

mean_snrs = mean(training_snr_imp_ga_2,2);
[me,idx] = max(mean_snrs);
snr_out(6) = mean(testing_snr_imp_ga_2(idx,:));
