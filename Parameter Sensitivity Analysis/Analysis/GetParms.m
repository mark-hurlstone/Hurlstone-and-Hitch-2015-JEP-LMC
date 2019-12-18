% This is used to obtain regression parameter estimates for the models'
% predicted postponement slopes.

clear all

ll = 9; % List-length
X = 1:ll; 

% Import data for the models
pm     = dlmread('pm_ms.txt');
pmrs   = dlmread('pmrs_ms.txt');
pmoi   = dlmread('pmoi_ms.txt'); 
pgrs   = dlmread('pgrs_ms.txt');
pgpmrs = dlmread('pgpmrs_ms.txt'); 

% Select data for postponements only
pm     = pm(:,ll:ll*2-1);
pmrs   = pmrs(:,ll:ll*2-1);
pmoi   = pmoi(:,ll:ll*2-1);
pgrs   = pgrs(:,ll:ll*2-1);
pgpmrs = pgpmrs(:,ll:ll*2-1);

%:::::::::::::::::: Obtain Regression Slope Parameter Estimates

% Calculate postponement slopes for PM model
pm_Slopes = zeros(length(pm),2);
for i=1:length(pm)
    Y = pm(i,:);
    if (sum(isnan(Y)==0)>1) % Only obtain estimates when we have more than one element
        valid_Data1 = ~isnan(X);
        valid_Data2 = ~isnan(Y);
        valid_Data_Both = valid_Data1 & valid_Data2;
        keep1 = X(valid_Data_Both);
        keep2 = Y(valid_Data_Both);
        pm_Slopes(i,:) = polyfit(keep1,keep2,1);
    end
end

% Calculate postponement slopes for PM+RS model
pmrs_Slopes = zeros(length(pmrs),2);
for i=1:length(pmrs)
    Y = pmrs(i,:);
    if (sum(isnan(Y)==0)>1)
        valid_Data1 = ~isnan(X);
        valid_Data2 = ~isnan(Y);
        valid_Data_Both = valid_Data1 & valid_Data2;
        keep1 = X(valid_Data_Both);
        keep2 = Y(valid_Data_Both);
        pmrs_Slopes(i,:) = polyfit(keep1,keep2,1);
    end
end
    
% Calculate postponement slopes for PM+OI model
pmoi_Slopes = zeros(length(pmoi),2);
for i=1:length(pmoi)
    Y = pmoi(i,:);   
    if (sum(isnan(Y)==0)>1) 
        valid_Data1 = ~isnan(X);
        valid_Data2 = ~isnan(Y);
        valid_Data_Both = valid_Data1 & valid_Data2;
        keep1 = X(valid_Data_Both);
        keep2 = Y(valid_Data_Both);
        pmoi_Slopes(i,:) = polyfit(keep1,keep2,1);
    end
end
    
% Calculate postponement slopes for PG+RS model
pgrs_Slopes = zeros(length(pgrs),2);
for i=1:length(pgrs)
    Y = pgrs(i,:);
    if (sum(isnan(Y)==0)>1)
        valid_Data1 = ~isnan(X);
        valid_Data2 = ~isnan(Y);
        valid_Data_Both = valid_Data1 & valid_Data2;
        keep1 = X(valid_Data_Both);
        keep2 = Y(valid_Data_Both);
        pgrs_Slopes(i,:) = polyfit(keep1,keep2,1);
    end
end

% Calculate postponement slopes for PG+PM+RS model
pgpmrs_Slopes = zeros(length(pgpmrs),2);
for i=1:length(pgpmrs)
    Y = pgpmrs(i,:);
    if (sum(isnan(Y)==0)>1)
        valid_Data1 = ~isnan(X);
        valid_Data2 = ~isnan(Y);
        valid_Data_Both = valid_Data1 & valid_Data2;
        keep1 = X(valid_Data_Both);
        keep2 = Y(valid_Data_Both);
        pgpmrs_Slopes(i,:) = polyfit(keep1,keep2,1);
    end
end

% Seletct slope estimates 
pm_Slopes     = pm_Slopes(:,1); 
pmrs_Slopes   = pmrs_Slopes(:,1); 
pmoi_Slopes   = pmoi_Slopes(:,1); 
pgrs_Slopes   = pgrs_Slopes(:,1);  
pgpmrs_Slopes = pgpmrs_Slopes(:,1);

% Exclude slopes associated with perfect recall accuracy!
pm_Slopes     = pm_Slopes(find(pm_Slopes~=0));
pmrs_Slopes   = pmrs_Slopes(find(pmrs_Slopes~=0));
pmoi_Slopes   = pmoi_Slopes(find(pmoi_Slopes~=0));
pgrs_Slopes   = pgrs_Slopes(find(pgrs_Slopes~=0));
pgpmrs_Slopes = pgpmrs_Slopes(find(pgpmrs_Slopes~=0));

%:::::::::::::::::::: Write data to files for later
dlmwrite('pm_Slopes.txt', pm_Slopes, 'delimiter', '\t\')
dlmwrite('pmrs_Slopes.txt', pmrs_Slopes, 'delimiter', '\t\')
dlmwrite('pmoi_Slopes.txt', pmoi_Slopes, 'delimiter', '\t\')
dlmwrite('pgrs_Slopes.txt', pgrs_Slopes, 'delimiter', '\t\')
dlmwrite('pgpmrs_Slopes.txt', pgpmrs_Slopes, 'delimiter', '\t\')
