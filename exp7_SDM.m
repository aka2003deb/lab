clc
clear all
close all
t = -5:0.01:5; %basic time axis
f =2;
w = 2*pi*f;
osr = 250; %can vary
fs1 = w/pi;
fs = fs1*osr;
%% sampling time
ts = -5:(1/fs):5; %sampling times are defined
y = @(t)sin(w.*t); %signal is defined
%% sigma delta quantisation
[u,q] = SDQ(y(ts),ts);
%% reconstruction algorithm
z = 0;
for k = 1:length(ts)
z = z + q(k).*sinc(w.*(t - ts(k)));
end
c = max(y(t))./max(z); %scaling is done as a consequence of oversampling
z = z.*c;
%% figures
figure(1)
subplot(3,1,1)
plot(t,y(t),'linewidth',2)
title('Original sinal')
xlabel('Time')
ylabel('Amplitude')
subplot(3,1,2)
plot(ts,q)
title('SDQ signal');
xlabel('Time');
ylabel('Amplitude');
subplot(3,1,3)
plot(t,z,'linewidth',2);
title('Reconstructed signal');
xlabel('Time');
ylabel('Amplitude');
figure(2);
plot(t,y(t),'linewidth',2)
hold on
plot(t,z,'linewidth',2);
title('Original vs Reconstructed');
figure(3);
plot(abs(z - y(t)),'linewidth',2);
title('Error');
figure(4);
subplot(3,1,1);
plot(abs(fftshift(fft(y(t)))));
xlabel('Frequency');
ylabel('Amplitude');
title('Spectrum of original signal');
subplot(3,1,2);
plot(abs(fftshift(fft(q))));
xlabel('Frequency');
ylabel('Amplitude');
title('Spectrum of SDQ');
subplot(3,1,3);
plot(abs(fftshift(fft(z))));
title('Spectrum of recovered signal');
xlabel('Frequency');
ylabel('Amplitude');
%% mse computation
error = immse(z,y(t));
%% function
function [u,q] = SDQ(y,t)
%as per basic equations, models a sigma delta modulator
%% code logic
q = zeros(1,length(t));
u = zeros(1,length(t)); %quantizaton noise/state variable
u(1) = 0.9; %taken 0.9 as in between 0 and 1 for stability (non inclusive)
%recursive equations for SDQ
for k = 2:length(t)
q(k) = sign(u(k-1) + y(k));
u(k) = u(k-1) + y(k) - q(k);
end
end
