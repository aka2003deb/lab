%experiment 1a
clc;

signal_length=1000;
signal_1=randn(1,signal_length);
signal_2=randn(1,signal_length);

autocorr_result1=xcorr(signal_1,signal_1);
autocorr_result2=xcorr(signal_2,signal_2);

lags=-(signal_length-1):(signal_length-1);

figure;

subplot(2,2,1);
plot(lags,autocorr_result1);
title('AutoCorrelation of Signal 1');
xlabel('Time');
ylabel('Magnitude');
grid on;

subplot(2,2,2);
plot(lags,autocorr_result2);
title('AutoCorrelation of Signal 2');
xlabel('Time');
ylabel('Magnitude');
grid on;

subplot(2,2,3);
[psd1,frequencies1]=pwelch(signal_1);
semilogy(frequencies1,psd1);
title('PSD of Signal 1');
xlabel('Frequency');
ylabel('PSD');
grid on;

subplot(2,2,4);
[psd2,frequencies2]=pwelch(signal_2);
semilogy(frequencies2,psd2);
title('PSD of Signal 2');
xlabel('Frequency');
ylabel('PSD');
grid on;

%experiment 1b
% Set seed for reproducibility
rng(42);

% Parameters
Fs = 1000;          % Sampling frequency (Hz)
T = 1/Fs;           % Sampling period
t = 0:T:1-T;        % Time vector

% Lowpass random process
lowpass_cutoff = 50;  % Cutoff frequency for lowpass filter (Hz)
lowpass_signal = randn(size(t));
lowpass_signal = lowpass_signal - mean(lowpass_signal);  % Remove DC component
lowpass_signal = lowpass(lowpass_signal, lowpass_cutoff, Fs);

% Bandpass random process
bandpass_center = 200;   % Center frequency for bandpass filter (Hz)
bandpass_bandwidth = 50; % Bandwidth for bandpass filter (Hz)
bandpass_signal = randn(size(t));
bandpass_signal = bandpass_signal - mean(bandpass_signal);  % Remove DC component
bandpass_signal = bandpass(bandpass_signal, [bandpass_center-bandpass_bandwidth/2, bandpass_center+bandpass_bandwidth/2], Fs);

% Plot lowpass random process
figure(1);
subplot(4, 1, 1);
plot(t, lowpass_signal);
title('Lowpass Random Process');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plo t bandpass random process
subplot(4, 1, 2);
plot(t, bandpass_signal);
title('Bandpass Random Process');
xlabel('Time (s)');
ylabel('Amplitude');
grid on
[psd,freq]=pwelch(lowpass_signal,[],[],[],1)
subplot(4,1,3)
plot(freq,psd)
[psd,freq]=pwelch(bandpass_signal,[],[],[],1)
subplot(4,1,4)
plot(freq,psd)
