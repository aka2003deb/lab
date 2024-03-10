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
