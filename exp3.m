%time domain sampling
clc
close all

tfinal = 0.01;
t = 0:0.00001:tfinal;

xanalog = cos(2*pi*400*t) + cos(2*pi*700*t);

subplot(4,1,1);
plot(t, xanalog , 'r-');
xlabel("Time");
ylabel("Amplitude");
title("Analog signal");

% Critical Sampling (fs=2fm)
fs=1400;
tsamp = 0:1/fs:tfinal;
xsampled = cos(2*pi*400*tsamp) + cos(2*pi*700*tsamp);
subplot(4,1,2);
plot(tsamp, xsampled , 'b*-');
xlabel("Time");
ylabel("Amplitude");
title("Critical Sampling(fs=2fm)");

% Under Sampling (fs<2fm)
fs=700;
tsamp = 0:1/fs:tfinal;
xsampled = cos(2*pi*400*tsamp) + cos(2*pi*700*tsamp);
subplot(4,1,3);
plot(tsamp, xsampled , 'b*-');
xlabel("Time");
ylabel("Amplitude");
title("UnderSampling(fs<2fm)");

% Over Sampling (fs>2fm)
fs=2000;
tsamp = 0:1/fs:tfinal;
xsampled = cos(2*pi*400*tsamp) + cos(2*pi*700*tsamp);
subplot(4,1,4);
plot(tsamp, xsampled , 'b*-');
xlabel("Time");
ylabel("Amplitude");
title("OverSampling(fs>2fm)");

%frequency domain sampling
tfinal = 0.01;
t = 0:0.00001:tfinal;
xanalog = cos(2*pi*400*t) + cos(2*pi*700*t);

% Plotting the analog signal
figure;
subplot(4,1,1);
plot(t, xanalog);
xlabel('Time');
ylabel('Amplitude');
title('Analog Signal (400 Hz + 700 Hz)');

% Critical sampling (fs = 2fm)
fs = 1400;
tsamp = 0:1/fs:13/fs;
xsampled = cos(2*pi*400*tsamp) + cos(2*pi*700*tsamp);
xsampled_DFT = abs(fft(xsampled));
xsampled_length = 0:length(xsampled_DFT)-1;

subplot(4,1,2);
stem(100*xsampled_length, xsampled_DFT);
xlabel('Frequency');
ylabel('Magnitude');
title('Critical Sampling (fs = 2fm)');


% Under Sampling (fs < 2fm)
fs = 700;
tsamp = 0:1/fs:6/fs;
xsampled = cos(2*pi*400*tsamp) + cos(2*pi*700*tsamp);
xsampled_DFT = abs(fft(xsampled));
xsampled_length = 0:length(xsampled_DFT)-1;

subplot(4,1,4);
stem(100*xsampled_length, xsampled_DFT);
xlabel('Frequency');
ylabel('Magnitude');
title('Under Sampling (fs < 2fm)');



% Over Sampling (fs > 2fm)
fs = 2000;
tsamp = 0:1/fs:19/fs;
xsampled = cos(2*pi*400*tsamp) + cos(2*pi*700*tsamp);
xsampled_DFT = abs(fft(xsampled));
xsampled_length = 0:length(xsampled_DFT)-1;

subplot(4,1,3);
stem(100*xsampled_length, xsampled_DFT);
xlabel('Frequency');
ylabel('Magnitude');
title('Over Sampling (fs > 2fm)');



