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
subplot(2, 1, 1);
plot(t, lowpass_signal);
title('Lowpass Random Process');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plo t bandpass random process
subplot(2, 1, 2);
plot(t, bandpass_signal);
title('Bandpass Random Process');
xlabel('Time (s)');
ylabel('Amplitude');
grid on
[psd,freq]=pwelch(lowpass_signal,[],[],[],1)
figure(2);
subplot(2,1,1)
plot(freq,psd)
[psd,freq]=pwelch(bandpass_signal,[],[],[],1)
subplot(2,1,2)
plot(freq,psd)
