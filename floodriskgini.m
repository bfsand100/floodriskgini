%floodriskgini.m
%Matlab script to illustrate Lorenz Curves and the Gini Index
%Brett Sanders, UCI
%See: https://www.nature.com/articles/s41893-022-00977-7

clear
close all


%Part I: The dataset

%In this demonstration code, we create a synthetic dataset of population,
%hazard, damage, and social variables. For future applications, data
%will need to be organized elsewhere and loaded here as a table.


%Number of units in dataset
N=100; 
%Population distribution (uniform)
p=ones(N,1);
%Hazard distribution (linear)
hmax=2;
h=linspace(0,hmax,N)';
%Damage distribution (linear)
dmax=1e5;
d=linspace(0,dmax,N)';
%Social variable (linear)
% e.g., racial/ethnic pop fraction, vulnerability index, income
vmax=1;
v=linspace(0,vmax,N);
%Note: damage and hazard are correlated here with v (expect inequality)


%Part II: Damage Based Lorenz Curve

%Create Table for Damage-Based Lorenz Curve
T_d=zeros(N,3);
T_d(:,1)=p;
T_d(:,2)=d;
T_d(:,3)=v;

%Sort Table by Social Variable
T_d_sort=sortrows(T_d,3,'ascend');

%Build CDFs
P(1,1)=0;
D(1,1)=0;
for i = 1:N
    if i==1
        P(i+1,1) = T_d_sort(i,1); %Population
        D(i+1,1) = T_d_sort(i,2); %Damage
    else
        P(i+1,1) = T_d_sort(i,1) + P(i,1);
        D(i+1,1) = T_d_sort(i,2) + D(i,1);
    end
end
%Normalize CDFs
Phat=P/P(N+1,1);
Dhat=D/D(N+1,1);
%Find Proportion of Damage at Median of Population
[nearestval,idx]=min(abs(Phat-0.5));
Dhat50=Phat(idx,1); %
%Compute Flood Damage Gini Index
dumG=0;
for i = 1:N
    dumG=dumG+(Phat(i+1,1)-Phat(i,1))*(Dhat(i+1,1)+Dhat(i,1));
end
Gini_d=1-dumG;
figure(1)
plot(Phat,Dhat,'LineWidth',2)
xlabel('Proportion of Population')
ylabel('Proportion of Damage')
title('Damage Lorenz Curve With Sorting for Social Variable v')
%Note: this graph is concave up, showing disproportionate
%amount of flood damages with increasing levels of the social variable


%Part III: Exposure Based Lorenz Curve

%Create Table for Exposure-Based Lorenz Curve
T_e=zeros(N,3);
T_e(:,1)=p;
T_e(:,2)=h;
T_e(:,3)=v;

%Sort Table by Social Variable
T_e_sort=sortrows(T_e,3,'ascend');

%Build CDFs
P(1,1)=0;
E(1,1)=0;
for i = 1:N
    if i==1
        P(i+1,1) = T_e_sort(i,1); %Population
        E(i+1,1) = T_e_sort(i,1)*T_e_sort(i,2); %Exposure
    else
        P(i+1,1) = T_e_sort(i,1) + P(i,1);
        E(i+1,1) = T_e_sort(i,1)*T_e_sort(i,2) + E(i,1);
    end
end
%Normalize CDFs
Phat=P/P(N+1,1);
Ehat=E/E(N+1,1);
%Find Proportion of Damage at Median of Population
[nearestval,idx]=min(abs(Phat-0.5));
Ehat50=Phat(idx,1); %
%Compute Flood Exposure Gini Index
dumG=0;
for i = 1:N
    dumG=dumG+(Phat(i+1,1)-Phat(i,1))*(Dhat(i+1,1)+Dhat(i,1));
end
Gini_e=1-dumG;
figure(2)
plot(Phat,Ehat,'LineWidth',2)
xlabel('Proportion of Population')
ylabel('Proportion of Exposure')
title('Exposure Lorenz Curve With Sorting for Social Variable v')
%Note: this graph is concave up, showing disproportionate
%amount of flood exposure with increasing levels of the social variable












