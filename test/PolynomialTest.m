clc;clear;
IBI=importdata('chenzecheng_9_00_10_00.ibi');
t=IBI(:,1);y=IBI(:,2);
t2=(t-mean(t))./std(t);
n=3;    %ÄâºÏµÄ½×Êý
[p,S]= polyfit(t2,y,n);
trend(:,2) = polyval(p,t2);
figure;
plot(t,y);
hold on;
plot(t,trend(:,2));