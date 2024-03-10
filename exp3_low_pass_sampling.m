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
clc
close all

tfinal = 0.01;
t=0:0.00001:tfinal;

figure;

xanalog = cos(2*pi*400*t)+cos(2*pi*700*t);
subplot(4,2,2);
plot(t, xanalog , 'r-');
xlabel("Time");
ylabel("Amplitude");
title("Analog signal");

x_DFT = abs(fftshift(fft(xanalog)));
l=length(x_DFT);
x_length = -l/2:l/2-1;
subplot(4,2,1);
stem(100*x_length+50,x_DFT);
axis([-800 800 0 600]);
xlabel("Frequency");
ylabel("Magnitude");
title("Analog signal in Frequency Domain")

% Critical Sampling (fs=2fm)
fs=1400;
tsamp = 0:1/fs:14/fs;
xsampled = cos(2*pi*400*tsamp)+cos(2*pi*700*tsamp);
xsampled_DFT = abs(fftshift(fft(xsampled)));
xsampled_length = -length(xsampled_DFT)/2:length(xsampled_DFT)/2-1;
subplot(4,2,3);
stem(100*xsampled_length+50,xsampled_DFT);
axis([-800 800 0 15])
xlabel("Frequency");
ylabel("Magnitude");
title("Critical Sampling(fs=2fm)");

xrecon = ifft(fft(xsampled));
subplot(4,2,4);
plot(tsamp,xrecon);
xlabel("Time");
ylabel("Amplitude");
title("Critical Sampling(fs=2fm)");

% Under Sampling (fs<2fm)
fs =700;
tsamp = 0:1/fs:6/fs;
xsampled = cos(2*pi*400*tsamp)+cos(2*pi*700*tsamp);
xsampled_DFT = abs(fftshift(fft(xsampled)));
xsampled_length = -length(xsampled_DFT)/2:length(xsampled_DFT)/2-1;
subplot(4,2,5);
stem(100*xsampled_length+50,xsampled_DFT);
axis([-800 800 0 15])
xlabel("Frequency");
ylabel("Magnitude");
title("Under Sampling(fs<2fm)");

xrecon = ifft(fft(xsampled));
subplot(4,2,6);
plot(tsamp,xrecon);
xlabel("Time");
ylabel("Amplitude");
title("Under Sampling(fs<2fm)");

% Over Sampling (fs>2fm)
fs=2000;
tsamp = 0:1/fs:20/fs;
xsampled = cos(2*pi*400*tsamp) + cos(2*pi*700*tsamp);
xsampled_DFT = abs(fft(xsampled));
xsampled_length = -length(xsampled_DFT)/2:length(xsampled_DFT)/2-1;
subplot(4,2,7);
stem(100*xsampled_length,xsampled_DFT);
axis([-800 800 0 15])
xlabel("Frequency");
ylabel("Magnitude");
title("Over Sampling(fs>2fm)");

xrecon = ifft(fft(xsampled));
subplot(4,2,8);
plot(tsamp,xrecon);
xlabel("Time");
ylabel("Amplitude");
title("Over Sampling(fs>2fm)");
