%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
% GRID SEARCH FOR PG+RS MODEL  %
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mark Hurlstone                  %
% School of Psychology            %
% University of Western Australia %
% mark.hurlstone@uwa.edu.au       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
global score
parms.seed = 111211;


%%%%%%%%%%%%%%
% PARAMETERS %
%%%%%%%%%%%%%%

parms.ll = 9;               % List length
parms.nTrials = 1000;       % N simulation trials

% CQ MODEL PARAMETERS
parms.ExciteWeight = 1.1;   % Excitatory weight
parms.InhibitWeight = -0.1; % Inhibitory weight
parms.CQThresh = 1;         % Threshold for response
parms.MaxIters = 200;       % Max iterations for each response
parms.NoiseMean = 0;        % Mean noise
parms.NoiseSD = .04;        % Std.Dev of noise

% POSITION MARKING 
parms.ItemWeight = 1;       % Marker scaling
parms.ItemDistinct = .65;   % Distinctiveness of position markers

% PRIMACY GRADIENT 
parms.GradStart = .6;       % Start value for primacy gradient
parms.GradDecrease = .85;   % Decrease in primacy gradient
parms.Mix = 1;              % Weighting of primacy gradient and position markers (0 = positional only; 1 = primacy only) 

% RESPONSE SUPPRESSION
parms.ResSupp = .95;        % Extent of response suppression

% OUTPUT INTERFERENCE
parms.OutInt = 0;           % Amount of output interference


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRID SEARCH FOR PG+RS MODEL %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define parameter space
pspace.GradStart = .05:.1:.95;
pspace.GradDecrease = .05:.1:.95;
pspace.ResSupp = .05:.1:.95;

% Number of simulations
nsims = length(pspace.GradStart)*length(pspace.GradDecrease)*length(pspace.ResSupp);

% Initialize scoring structure
grid.accspc = zeros(nsims, parms.ll);          % Accuracy SPC
grid.crtspc = zeros(nsims, parms.ll);          % Latency SPC 
grid.trans = zeros(nsims, parms.ll*2-1);       % Transposition gradient
grid.transrt = zeros(nsims, parms.ll*2-1);     % Transposition latencies
grid.fltrdtransrt = zeros(nsims, parms.ll*2-1);% Normalized transposition latencies
grid.state = zeros(nsims, 3);                  % Holds parameter vectors

% Initiate grid search
pvec = 0;
for GradStart = pspace.GradStart
    for GradDecrease = pspace.GradDecrease
        for ResSupp = pspace.ResSupp
            pvec = pvec +1;
            parms.GradStart = GradStart;
            parms.GradDecrease = GradDecrease; % *THIS WAS THE PROBLEM!
            parms.ResSupp = ResSupp;
            cq(parms)

            grid.accspc(pvec,:) = score.accspc./parms.nTrials;
            grid.crtspc(pvec,:) = score.crtspc./score.accspc;
            grid.trans(pvec,:) = score.trans./sum(score.trans);
            grid.transrt(pvec,:) = score.transrt./score.transreps;
            grid.fltrdtransrt(pvec,:) = score.fltrdtransrt./score.transreps;
            grid.state(pvec,:) = [GradStart,GradDecrease,ResSupp];
        end
    end
    pvec
end

% Write predictions to files 
dlmwrite('accspc.txt',grid.accspc,'delimiter', '\t');
dlmwrite('crtspc.txt',grid.crtspc,'delimiter', '\t');
dlmwrite('trans.txt',grid.trans,'delimiter', '\t');
dlmwrite('transrt.txt',grid.transrt,'delimiter', '\t');
dlmwrite('fltrdtransrt.txt',grid.fltrdtransrt,'delimiter', '\t');
dlmwrite('state.txt',grid.state,'delimiter', '\t');