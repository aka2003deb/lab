% Number of dice
numDice = 50;
% Number of dice rolls
numRolls = 10000;

% Simulate rolling 'numDice' dice and calculate the sum
diceSum = randi([1, 2], numRolls, numDice);
sumValues = sum(diceSum, 2);

% Calculate the probability distribution
numOutcomes = numDice * 2; % Possible outcomes for 'numDice' dice
probDistribution = histcounts(sumValues, numDice:numOutcomes + 1) / numRolls;

% Plotting
subplot(2,1,1);
bar(numDice:numOutcomes, probDistribution);
title(['Probability Distribution of Sum of ' num2str(numDice) ' Coins']);
xlabel('Possible Sum Outcomes');
ylabel('Probability');

subplot(2,1,2);
numdice=50;
numrolls=10000;
dicesum=randi([1,6],numrolls,numdice);
sumvalues=sum(dicesum,2);
numoutcomes=6*numdice;
prob=histcounts(sumvalues,numdice:numoutcomes+1)/numrolls;
bar(numdice:numoutcomes,prob)
title("Central limit theorem for 50 dice");
xlabel('Possible outcomes')
ylabel("probability") ye wala
