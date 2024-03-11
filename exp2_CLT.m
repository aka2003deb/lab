clc; close all; clear all;
N= 100000;
n= 100000;
s=100;
population= exprnd(2,1,N);
sample_mean= zeros(1,n);
for i = 1:n
    sample = randsample(population,s,true);
    sample_mean(i)= mean(sample);
end
figure;
subplot(2,1,1);
histogram(population,'Normalization','pdf','EdgeColor', 'None');
title('Population Distribution');
xlabel('Value');
ylabel('Probability Density');
subplot(2,1,2);
histogram(sample_mean,'Normalization','pdf','EdgeColor','None');
hold on;
title ('Distribution of Sample Means');
xlabel('Sample Mean');
ylabel('Probability Density');
legend('Sample Means', 'Expected Normal Distribution');
mu_pop= mean(population);
std_pop= std(population);
exp_mean= mu_pop;
exp_std= std_pop/sqrt(s);
x= linspace (min(sample_mean),max(sample_mean));
y= normpdf(x,exp_mean,exp_std);
plot(x,y,'r','LineWidth',2);
hold off;

%PART 2 

n=10000;
N1=10;
ds=randi([1,2],n,N1);
sv=sum(ds,2);
no=2*N1;
probd=histcounts(sv,2:no+1)/n;
figure (1);
bar(2:no,probd);
title('Central Limit Theorem: N=10 Coin');
xlabel('Possible Outcomes');
ylabel('Probability');

n=10000;
N2=10;
ds=randi([1,6],n,N2);
sv=sum(ds,2);
no=6*N2;
probd=histcounts(sv,2:no+1)/n;
figure (2);
bar(2:no,probd);
title('Central Limit Theorem: N=10 Dice');
xlabel('Possible Outcomes');
ylabel('Probability');
