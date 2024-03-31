%delta modulation
close all;
clear all;
a=2;
t=0:2*pi/50:2*pi;
x=a*sin(t);
l=length(x);
plot(x,'r')
delta=0.2
hold on
xn=0;
for i=1:l
    if x(i)>xn(i)
        d(i)=1
        xn(i+1)=xn(i)+delta
    else
        d(i)=0;
        xn(i+1)=xn(i)-delta;
    end
end
stairs(xn)
hold on
for i=1:d
    if d(i)>xn(i)
        d(i)=0
        xn(i+1)=xn(i)-delta
    else
        d(i)=1
        xn(i+1)=xn(i)+delta
    end
end
plot(xn,'c')
legend('Analog Signal','DM with step size=0.2')
title('DELTA MODULATION')


% adaptive delta modulation

close all
clear all
clc
td = 0.01;
ts = 0.02;
t = 0:td:5;
x = 8*sin(2*pi*t);
delta = 0.1;
figure(1)
ADMout = adeltamod(x,delta,td,ts);
figure(2)
plot(t,ADMout,'-',t,x,'red');
function [ADMout] = adeltamod(sig_in, Delta, td, ts)
 if (round(ts/td) >= 2)
 Nfac = round(ts/td); %Nearest integer
 xsig = downsample(sig_in,Nfac);
 Lxsig = length(xsig);
 Lsig_in = length(sig_in);

 ADMout = zeros(Lsig_in); %Initialising output

 cnt1 = 0; %Counters for no. of previous consecutively increasing
 cnt2 = 0; %steps
 sum = 0;
 for i=1:Lxsig

 if (xsig(i) == sum)
 elseif (xsig(i) > sum)
 if (cnt1 < 2)
 sum = sum + Delta; %Step up by Delta, same as in DM
 elseif (cnt1 == 2)
 sum = sum + 2*Delta; %Double the step size after
 %first two increase
 elseif (cnt1 == 3)
 sum = sum + 4*Delta; %Double step size
 else
 sum = sum + 8*Delta; %Still double and then stop
 %doubling thereon
 end
 if (sum < xsig(i))
 cnt1 = cnt1 + 1;
 else
 cnt1 = 0;
 end
 else
 if (cnt2 < 2)
 sum = sum - Delta;
 elseif (cnt2 == 2)
 sum = sum - 2*Delta;
 elseif (cnt2 == 3)
 sum = sum - 4*Delta;
 else
 sum = sum - 8*Delta;
 end
 if (sum > xsig(i))
 cnt2 = cnt2 + 1;
 else
 cnt2 = 0;
 end
 end
 ADMout(((i-1)*Nfac + 1):(i*Nfac)) = sum;
 end
 end
end
%adaptive delta modulation alternative
function ADMout = adeltamod(sig_in, Delta, td, ts)
    Nfac = round(ts/td);
    xsig = downsample(sig_in, Nfac);
    ADMout = zeros(size(sig_in));
    sum = 0;
    cnt1 = 0;
    cnt2 = 0;
    
    for i = 1:length(xsig)
        if xsig(i) > sum
            step = Delta * 2^(min(3, cnt1));
            sum = sum + step;
            cnt1 = cnt1 + (sum < xsig(i));
            cnt2 = 0;
        elseif xsig(i) < sum
            step = Delta * 2^(min(3, cnt2));
            sum = max(0, sum - step);
            cnt1 = 0;
            cnt2 = cnt2 + (sum > xsig(i));
        end
        ADMout(((i-1)*Nfac + 1):(i*Nfac)) = sum;
    end
end

% Example usage
td = 0.01;
ts = 0.02;
t = 0:td:(5-td); % Adjusted to match the length of ADMout
x = 8*sin(2*pi*t);
delta = 0.1;

ADMout = adeltamod(x, delta, td, ts);
plot(t, 9*sin(2*pi*t), '-', t, x, 'red');
