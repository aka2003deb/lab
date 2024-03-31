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

clc;
close all;
clear all;

td=0.002;
t=[0:td:1];
xsig=sin(2*pi*t)-sin(6*pi*t);
ts=0.2;
delta=0.2*8;
Lsig=length(xsig);
if(rem(ts/td,1)==0)
    nfac=round(ts/td);
    p_zoh=ones(1,nfac);
    s_down=downsample(xsig,nfac);
    Num_it=length(s_down);
    s_DMout(1)=delta/2;
    for k=2:Num_it
        xvar=s_DMout(k-1);
        s_DMout(k)=xvar+delta*sign(s_down(k-1)-xvar);
    end
    S_DMout=kron(s_DMout,p_zoh);
else
    S_DMout=[];
end

figure(1);
sfig1=plot(t,xsig,'k',t,S_DMout(1:Lsig),'b');
set(sfig1,'LineWidth',2);
