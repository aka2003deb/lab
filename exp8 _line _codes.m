%line codes generation

N= 10; % Number of input bits
a=floor(2*rand (1,N)) % generates random 1's and zero's and displays
A=5; % Pulse amplitude
Tb=1; %bit period
fs=100; % Number of samples (even number) taken in a bitperiod
%Unipolar NRZ
U=[];
for k=1:N;
U = [U A*a(k)*ones(1,fs)];
end
%Unipolar RZ
U_rz=[];
for k=1:N;
c = ones(1,fs/2);
b = zeros(1,fs/2);
p = [c b];
U_rz = [U_rz A*a(k)*p];
end
%Polar NRZ
P=[];
for k=1:N
P = [P ((-1)^(a(k) + 1))*A*ones(1,fs)];
end
%Polar RZ
P_rz=[];
for k = 1:N
c = ones(1,fs/2);
b = zeros(1,fs/2);
p = [c b];
P_rz = [P_rz ((-1)^(a(k)+1))*A*p];
end
%Bipolar NRZ
B=[];
count=-1;
for k= 1:N
if a(k)==1
if count==-1
B = [B A*a(k)*ones(1,fs)];
count=1;
else
B = [B -A*a(k)*ones(1,fs)];
count=-1;
end
else
B = [B A*a(k)*ones(1,fs)];
end
end
%Bipolar RZ / AMI RZ
B_rz=[];
count=-1;
for k= 1:N
if a(k)==1
if count==-1
B_rz = [B_rz A*a(k)*ones(1,fs/2) zeros(1,fs/2)];
count=1;
else
B_rz = [B_rz -A*a(k)*ones(1,fs/2) zeros(1,fs/2)];
count=-1;
end
else
B_rz = [B_rz A*a(k)*ones(1,fs)];
end
end
%Split-phase or Manchester code
M=[];
for k = 1:N
c = ones(1,fs/2);
b = -1*ones(1,fs/2);
p = [c b];
M = [M ((-1)^(a(k)+1))*A*p];
end
T = linspace(0,N*Tb, length(U));% Time vector % Lengths of all codes are same
figure(1)
subplot(4, 1, 1); plot(T,U,'LineWidth',2)
axis([0 N*Tb -6 6])
title('Unipolar NRZ')
grid on
subplot(4, 1, 2); plot(T,U_rz,'LineWidth',2)
axis([0 N*Tb -6 6])
title('Unipolar RZ')
grid on
subplot(4, 1, 3); plot(T,P,'LineWidth',2)
axis([0 N*Tb -6 6])
title('Polar NRZ')
grid on
subplot(4, 1, 4); plot(T,P_rz,'LineWidth',2)
axis([0 N*Tb -6 6])
title('Polar RZ')
grid on
figure(2)
subplot(3, 1, 1); plot(T,B,'LineWidth',2)
axis([0 N*Tb -6 6])
title('Bipolar NRZ')
grid on
subplot(3, 1, 2); plot(T,B_rz,'LineWidth',2)
axis([0 N*Tb -6 6])

title('Bipolar RZ / RZ-AMI')
grid on
subplot(3, 1, 3); plot(T,M,'LineWidth',2)
axis([0 N*Tb -6 6])
title('Split-phase or Manchester code')
grid on

%PSD of line codes

v = 1;   % Voltage level of a bit
R = 1;   % Bitrate
T = 1/R; % Bit period
f = 0:0.001*R:2*R; % Frequency vector in terms of bit rate
f = f + 1e-10; % Avoid division by zero in the sinusoid
f_zero = 1e-9;   % Small offset for the frequency component at f=0

% PSD curves are plotted for Bitrate=1 bps and Pulse amplitude=1 V

% Unipolar NRZ
s_unipolar_nrz = (v^2 * T/4) * (sin(pi * f * T) ./ (pi * f * T)).^2;
s_unipolar_nrz(1) = s_unipolar_nrz(1) + (v^2 / 4) + f_zero; % Add impulse at f=0

figure;
stem(f_zero, s_unipolar_nrz(1), 'or', 'LineWidth', 2, 'MarkerSize', 8); % Impulse at f=0
hold on;
plot(f, s_unipolar_nrz, '-r', 'LineWidth', 2);

% Manchester code
s_manchester = (v^2 * T) * ((sin(pi * f * T/2) ./ (pi * f * T/2)).^2) .* (sin(pi * f * T/2).^2);
plot(f, s_manchester, '--g', 'LineWidth', 2);

% Polar NRZ
s_polar_nrz = (v^2 * T) * (sin(pi * f * T) ./ (pi * f * T)).^2;
plot(f, s_polar_nrz, '--b', 'LineWidth', 2);

% Bipolar RZ
s_bipolar_rz = (v^2 * T/4) * ((sin(pi * f * T/2) ./ (pi * f * T/2)).^2) .* (sin(pi * f * T).^2);
plot(f, s_bipolar_rz, '--k', 'LineWidth', 2);

legend('Unipolar NRZ: impulse at f=0', 'Unipolar NRZ', 'Manchester code', 'Polar NRZ', 'Bipolar RZ / RZ-AMI');
xlabel('Normalized frequency');
ylabel('Power spectral density');
title('Power Spectral Density for Different Line Codes');

%probality of error

% The probability of error, for equally likely data, with AWGN and matched filter
E = 0:1:25; % Eb/N0 = SNR of the received signal

% Unipolar NRZ
P1 = (1/2) * erfc(sqrt(E/2));

% Polar NRZ and Manchester code have the same Pe for equiprobable 1's and 0's
P2 = (1/2) * erfc(sqrt(E));

% Bipolar RZ / RZ-AMI
P3 = (3/4) * erfc(sqrt(E/2));

E_dB = 10 * log10(E); % SNR in dB

figure;
semilogy(E_dB, P1, '-k', E_dB, P2, '-r', E_dB, P3, '-b', 'LineWidth', 2);
legend('Unipolar NRZ', 'Polar NRZ and Manchester', 'Bipolar RZ / RZ-AMI', 'Location', 'best');
xlabel('SNR per bit, Eb/No (dB)');
ylabel('Bit error probability Pe');
title('Bit Error Probability for Different Digital Communication Schemes in AWGN');
grid on;
