
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                            %
% COMPETITIVE QUEUING MODEL OF SERIAL RECALL %
% BASED ON FARRELL & LEWANDOWSKY (2004)      %
%                                            %                          
% THIS IS USED TO FIT THE PM+RS MODEL        %
%                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mark Hurlstone                  %
% School of Psychology            %
% University of Western Australia %
% mark.hurlstone@uwa.edu.au       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
close all
global parms data score
parms.seed = 111211;

% Import data for fitting
data.accspc = dlmread('Exp3UngAccSpc.txt'); 
data.rtspc  = dlmread('Exp3UngRtSpc.txt'); 
data.trans  = dlmread('Exp3UngTrans.txt');
data.ldf    = dlmread('Exp3UngFltLdf.txt'); 


%%%%%%%%%%%%%%
% PARAMETERS %
%%%%%%%%%%%%%%

parms.ll = 9;                 % List length
parms.nTrials = 10000;        % N simulation trials

% CQ MODEL PARAMETERS
parms.ExciteWeight = 1.1;     % Excitatory weight
parms.InhibitWeight = -0.1;   % Inhibitory weight
parms.CQThresh = 1;           % Threshold for response
parms.MaxIters = 200;         % Max iterations for each response
parms.NoiseMean = 0;          % Mean noise
parms.NoiseSD = .04;          % Std.Dev of noise

% POSITION MARKING 
fminparms.ItemWeight = 1;     % Activation of target item 
fminparms.ItemDistinct = .65; % Distinctiveness of position markers

% PRIMACY GRADIENT 
parms.GradStart = .6;         % Start value for primacy gradient
parms.GradDecrease = .85;     % Decrease in primacy gradient
parms.Mix = 0;                % Weighting of primacy gradient and position markers

% RESPONSE SUPPRESSION
fminparms.ResSupp = .95;      % Extent of response suppression

% OUTPUT INTERFERENCE
parms.OutInt = 0;             % Amount of output interference

% SCALING
fminparms.Scaling = 50;       % Iteration-to-ms scaling parameter


%%%%%%%%%%%%%%
% FMINSEARCH %
%%%%%%%%%%%%%%

% Converts parameters for fminsearch
temp = struct2cell(fminparms);
for i=1:length(temp)
	parmarray(i)=temp{i};
end

% Parameter boundaries for fminsearch
parms.LB = zeros(1,length(parmarray));
parms.UB = [1 1 1 200]; 

% Set up fminsearch
x = parmarray; 
nfuncevals = 500;
tolerance = .1;
defopts = optimset ('fminsearch');
options = optimset (defopts, 'Display', 'iter', 'TolFun', tolerance,'MaxFunEvals', nfuncevals);

% Initialize data storage
n = length(data.accspc);
fits.accspc = zeros(n,parms.ll);
fits.crtspc = zeros(n,parms.ll);
fits.trans = zeros(n,parms.ll*2-1);
fits.transrt = zeros(n,parms.ll*2-1);
fits.normtransrt = zeros(n,parms.ll*2-1);
fits.finalstate = zeros(n,length(x)+3);

% Fit the model to each participant 
for pars=1:n

    [x,fval,dummy,output] = mywrapperLoopfmin(parmarray,data.accspc(pars,:),data.rtspc(pars,:),data.trans(pars,:),data.ldf(pars,:),parms);

    %:::: Show where we are up to
	participant = pars
	finalstate = x

	%:::: Generate predictions for finalparms
	cq(x)
	
    %:::: Calculate lnL AIC and BIC scores 
    obs =  [data.accspc(pars,:) data.rtspc(pars,:)./10^4 data.trans(pars,:) data.ldf(pars,:)./10^4];
    pred = [score.accspc score.crtspc./10^4 score.trans./sum(score.trans) score.fltrdtransrt./10^4];
    n = length(obs) - sum(isnan(obs-pred));
    ssd = nansum((pred-obs).^2);
    lnL = n * log(ssd/n);
    AIC = lnL + 2*length(parmarray);
    BIC = lnL + length(parmarray) * log(n);
        
    %:::: Store predicitions
    fits.accspc(pars,:) = score.accspc; 
    fits.crtspc(pars,:) = score.crtspc;
    fits.trans(pars,:) = score.trans./sum(score.trans);
    fits.transrt(pars,:) = score.transrt;
    fits.fltrdtransrt(pars,:) = score.fltrdtransrt;
    fits.finalstate(pars,:) = [lnL AIC BIC x];

	%:::: Write data to files 
	dlmwrite('accspc.txt',fits.accspc, 'delimiter', '\t');
	dlmwrite('crtspc.txt',fits.crtspc, 'delimiter', '\t');
	dlmwrite('trans.txt',fits.trans, 'delimiter', '\t');
	dlmwrite('transrt.txt',fits.transrt, 'delimiter', '\t');
	dlmwrite('fltrdtransrt.txt',fits.fltrdtransrt, 'delimiter', '\t');
	dlmwrite('finalstate.txt',fits.finalstate, 'delimiter', '\t');

end

% Show average fits
nanmean(fits.accspc) 
nanmean(fits.crtspc)
nanmean(fits.trans)
nanmean(fits.transrt)
nanmean(fits.fltrdtransrt)
nanmean(fits.finalstate)

% Plot predictions
% Accuracy SPC
subplot(2,2,1)
plot(nanmean(fits.accspc))  
title('Accuracy SPC')
xlabel('Serial Position')
ylabel('Proportion Correct')

% Latency SPC
subplot(2,2,2)
plot(nanmean(fits.crtspc))
title('Latency SPC')
xlabel('Serial Position')
ylabel('Latency (Iterations)')

% Transposition Gradients
subplot(2,2,3)
plot(nanmean(fits.trans))
title('Transposition Gradient')
xlabel('Transposition Displacement')
ylabel('Proportion Responses')

% Latency-Displacement Functions
subplot(2,2,4)
plot(nanmean(fits.transrt))
title('Displacement Latencies')
xlabel('Transposition Displacement')
ylabel('Latency (Iterations)')