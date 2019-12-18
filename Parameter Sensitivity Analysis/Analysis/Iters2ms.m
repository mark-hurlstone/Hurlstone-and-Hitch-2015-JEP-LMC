% Script for converting model predictions from iterations to milliseconds

clear all

% Import data and model predictions for LDFs
data_ldf   = nanmean(dlmread('dataldf.txt'));
pm_ldf     = dlmread('pmldf.txt');
pmrs_ldf   = dlmread('pmrsldf.txt');
pmoi_ldf   = dlmread('pmoildf.txt');
pgrs_ldf   = dlmread('pgrsldf.txt');
pgpmrs_ldf = dlmread('pgpmrsldf.txt');

% These will hold the regression parameter estimates for the models
pm_parms     = zeros(length(pm_ldf),2);
pmrs_parms   = zeros(length(pmrs_ldf),2);
pmoi_parms   = zeros(length(pmoi_ldf),2);
pgrs_parms   = zeros(length(pgrs_ldf),2);
pgpmrs_parms = zeros(length(pgpmrs_ldf),2);

%:::: Obtain scaling parameters for converting model predicitons

% PM
for i=1:length(pm_ldf)    
    X = pm_ldf(i,:); Y = data_ldf;
    valid_Data1 = ~isnan(X); valid_Data2 = ~isnan(Y);
    valid_Data_Both = valid_Data1 & valid_Data2;
    keep1 = X(valid_Data_Both); keep2 = Y(valid_Data_Both);
    pm_parms(i,:) = polyfit(keep1,keep2,1);   
end

% PM+RS
for i=1:length(pmrs_ldf)   
    X = pmrs_ldf(i,:); Y = data_ldf;
    valid_Data1 = ~isnan(X); valid_Data2 = ~isnan(Y);
    valid_Data_Both = valid_Data1 & valid_Data2;
    keep1 = X(valid_Data_Both); keep2 = Y(valid_Data_Both);
    pmrs_parms(i,:) = polyfit(keep1,keep2,1);
end

% PM+OI
for i=1:length(pmoi_ldf)    
    X = pmoi_ldf(i,:); Y = data_ldf;
    valid_Data1 = ~isnan(X); valid_Data2 = ~isnan(Y);
    valid_Data_Both = valid_Data1 & valid_Data2;
    keep1 = X(valid_Data_Both); keep2 = Y(valid_Data_Both);
    pmoi_parms(i,:) = polyfit(keep1,keep2,1);  
end

% PG+RS
for i=1:length(pgrs_ldf)    
    X = pgrs_ldf(i,:); Y = data_ldf;
    valid_Data1 = ~isnan(X); valid_Data2 = ~isnan(Y);
    valid_Data_Both = valid_Data1 & valid_Data2;
    keep1 = X(valid_Data_Both); keep2 = Y(valid_Data_Both);
    pgrs_parms(i,:) = polyfit(keep1,keep2,1);   
end

% PG+PM+RS
for i=1:length(pgpmrs_ldf)    
    X = pgpmrs_ldf(i,:); Y = data_ldf;
    valid_Data1 = ~isnan(X); valid_Data2 = ~isnan(Y);
    valid_Data_Both = valid_Data1 & valid_Data2;
    keep1 = X(valid_Data_Both); keep2 = Y(valid_Data_Both);
    pgpmrs_parms(i,:) = polyfit(keep1,keep2,1);    
end

%:::: Convert model predictions into milliseconds using scaling parameters
pm_ms     = zeros(length(pm_ldf),length(data_ldf));
pmrs_ms   = zeros(length(pmrs_ldf),length(data_ldf));
pmoi_ms   = zeros(length(pmoi_ldf),length(data_ldf));
pgrs_ms   = zeros(length(pgrs_ldf),length(data_ldf));
pgpmrs_ms = zeros(length(pgpmrs_ldf),length(data_ldf));

for j=1:length(data_ldf)        
    pm_ms(:,j)     = pm_parms(:,2)+(pm_parms(:,1).* pm_ldf(:,j)); 
    pmrs_ms(:,j)   = pmrs_parms(:,2)+(pmrs_parms(:,1).* pmrs_ldf(:,j));
    pmoi_ms(:,j)   = pmoi_parms(:,2)+(pmoi_parms(:,1).* pmoi_ldf(:,j));
    pgrs_ms(:,j)   = pgrs_parms(:,2)+(pgrs_parms(:,1).* pgrs_ldf(:,j));
    pgpmrs_ms(:,j) = pgpmrs_parms(:,2)+(pgpmrs_parms(:,1).* pgpmrs_ldf(:,j));
end
    
%:::: Write predictions to files
dlmwrite('pm_ms.txt', pm_ms, 'delimiter', '\t')
dlmwrite('pmrs_ms.txt', pmrs_ms, 'delimiter', '\t')
dlmwrite('pmoi_ms.txt', pmoi_ms, 'delimiter', '\t')
dlmwrite('pgrs_ms.txt', pgrs_ms, 'delimiter', '\t')
dlmwrite('pgpmrs_ms.txt', pgpmrs_ms, 'delimiter', '\t')
