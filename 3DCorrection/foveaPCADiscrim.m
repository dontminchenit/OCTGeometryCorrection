figure(1)
clf

p1 = 1;
p2 = 2;
scatter(score1(sex==1,p1),score1(sex==1,p2),[],'r')
hold on
scatter(score1(sex==2,p1),score1(sex==2,p2),[],'b')
xlabel('PC1');
ylabel('PC2');


figure(2)
clf

p1 = 1;
p2 = 3;
scatter(score1(sex==1,p1),score1(sex==1,p2),[],'r')
hold on
scatter(score1(sex==2,p1),score1(sex==2,p2),[],'b')
xlabel('PC1');
ylabel('PC3');

figure(3)
clf

p1 = 2;
p2 = 3;
scatter(score1(sex==1,p1),score1(sex==1,p2),[],'r')
hold on
scatter(score1(sex==2,p1),score1(sex==2,p2),[],'b')
xlabel('PC2');
ylabel('PC3');


figure(4)
clf
scatter(axialLength,score1(:,1))
xlabel('axialLength');
ylabel('PC1');


figure(5)
clf
scatter(axialLength,score1(:,2))
xlabel('axialLength');
ylabel('PC2');


figure(6)
clf
scatter(axialLength,score1(:,3))
xlabel('axialLength');
ylabel('PC3');

figure(7)
clf
scatter(age,score1(:,1))
xlabel('age');
ylabel('PC1');


figure(8)
clf
scatter(age,score1(:,2))
xlabel('age');
ylabel('PC2');


figure(9)
clf
scatter(age,score1(:,3))
xlabel('age');
ylabel('PC3');

