function [deNoised2Plot,snr_imp,variancesExplained] = PCA_denoisingMIT(noisySignalX,refSignalU,RRintervals,rPeakStamps,movingWindowSize,k,sampleRange2Plot)
%PCA_denoisingMIT (noisySignalX,recordNumber,movingWindowSize,k,samples2Plot)
%   noisySignalX (d x 1) will be a 1-dimensional time-series signal from the MIT dataset with
%       (or without) noise added

%   refSignalU (d x 1) is the corresponding reference signal

%   RRintervals - time (in samples) between R-peaks in reference Signal
   
%   movingWindowSize sets the size of the window when calculating moving
%       mean of the R-R segments.

%   k sets the # of Principal Componenets used to estimate the
%       signal after PCA is performed

%   sampleRange2Plot specifies a range of samples over which to plot
%       results comparing de-noised signal to noisy and original versions
%       (i.e. 1001:4000)
 
medianSegLength = median(RRintervals);
mu_moving = movmean(noisySignalX,movingWindowSize);
data = noisySignalX - mu_moving;
%data = noisySignalX;
numSegments = length(rPeakStamps)-1;
segmentLength = max(RRintervals) + ceil(medianSegLength /10);

% Each segment padded with NaN's at beginning and end
segments = nan(numSegments,segmentLength);
startstopIndices = zeros(2,numSegments);

%%%%% SEGMENTATION & MEAN-CENTERING of RR Intervals %%%%%%
%%%%% First Segment %%%%%
ecgStart = 1;
ecgEnd = rPeakStamps(1) + floor((rPeakStamps(2) - rPeakStamps(1))/2);
ecgLength = ecgEnd - ecgStart + 1;
delta = segmentLength - ecgLength;
segment = data(ecgStart:ecgEnd);
segStart = floor(delta/2);
segEnd = segmentLength - ceil(delta/2) - 1;
startstopIndices(:,1) = [segStart;segEnd];
segments(1,segStart:segEnd) = segment;

for i = 2:numSegments-1
    ecgStart = ecgEnd+1;
    ecgEnd = rPeakStamps(i) + ceil((rPeakStamps(i+1) - rPeakStamps(i))/2);
    ecgLength = ecgEnd - ecgStart + 1;
    delta = segmentLength - ecgLength;
    segment = data(ecgStart:ecgEnd);
    segStart = floor(delta/2);
    segEnd = segmentLength - ceil(delta/2) - 1;
    startstopIndices(:,i) = [segStart;segEnd];
    segments(i, segStart:segEnd) = segment;
end
%%%%% LAST SEGMENT %%%%%
i = i+1;
ecgStart = ecgEnd+1;
ecgEnd = rPeakStamps(i) + ceil((rPeakStamps(i+1) - rPeakStamps(i))/2);
ecgLength = ecgEnd - ecgStart + 1;
delta = segmentLength - ecgLength;
segment = data(ecgStart:ecgEnd);
segStart = floor(delta/2);
segEnd = segmentLength - ceil(delta/2) - 1;
startstopIndices(:,end) = [segStart;segEnd];
segments(end,segStart : segEnd) = segment;

% Calculate row means
%kb = floor(movingWindowSize/2);
%kf =  ceil(movingWindowSize/2);
%mov_means = movmean(segments,movingWindowSize, 2,'omitnan');
%X_driftCorr = segments - mov_means;
row_means = mean(segments,2,'omitnan');
% Center the feature matrix (zero-mean)
X_centered = segments - row_means;
% Fill the NaN's with the mean of each row, which is now zero
X_centered = fillmissing(X_centered,'constant',0);

%%%%% CENTER THE PEAK OF EACH SEGMENT AT THE MIDDLE ROW INDEX %%%%%
[centeredSegments, refTimes] = ecgsCentered(X_centered,startstopIndices);

%%%%% PERFORM PCA ON CENTERED DATA AND KEEP K PRINCIPAL COMPONENTS %%%%%
[Y_pca,W_PCA,~,~,explained,mu] = pca(centeredSegments);
variancesExplained = explained'; %Return as a row vector

pcaDenoised = W_PCA(:,1:k) * Y_pca(:,1:k)' + row_means + mu;

sigDenoised = [];
    
for i = 1:numSegments
    segStart = startstopIndices(1,i);
    segEnd = startstopIndices(2,i);

    %Reconstruct de-noised signal by piecing together individual
    %segments
    sigDenoised = [sigDenoised, pcaDenoised(i,segStart:segEnd)];
end
n=length(sigDenoised);
sigDenoised = sigDenoised + mu_moving(1:n)'; %Add back the moving mean

%%%%% ERROR COMPARISIONS %%%%%
    
%Compare Denoised Signal to Ground Truth
delta = abs(sigDenoised - refSignalU(1:length(sigDenoised))');

%Compare Ground Truth to Noisy Signal
deltaNoise = abs(refSignalU(1:length(sigDenoised)) - noisySignalX(1:length(sigDenoised)));
deltaSquare = delta.^2;
deltaNoiseSquare = deltaNoise.^2;
MSE = 1/n * sum(deltaSquare);
MSE_noise = 1/n * sum(deltaNoiseSquare);

snr_imp = 10*log10(MSE_noise/MSE);
deNoised2Plot = sigDenoised(sampleRange2Plot);
end