function cq(parmarray) 

global parms score

% Retrieve parameter values from parmarray
fminparms.ItemWeight = parmarray(1);
fminparms.ItemDistinct = parmarray(2);
fminparms.Scaling = parmarray(3);

% Retrieve lateral inhibition weight matrix
W = weightMatrix(parms);

% Initialize scoring structure
score.accspc = zeros(1,parms.ll); 
score.rtspc = zeros(1,parms.ll);
score.crtspc = zeros(1,parms.ll);
score.trans = zeros(1,parms.ll*2-1);
score.transreps = zeros(1,parms.ll*2-1);
score.transrt = zeros(1,parms.ll*2-1);
score.fltrdtransrt = zeros(1,parms.ll*2-1);

% Responses + latencies
allRes = zeros(parms.nTrials,parms.ll); % All responses
allRts = zeros(parms.nTrials,parms.ll); % All latencies

% Randomization stuff
randn('state',parms.seed);
rand('state',parms.seed);

%%%%%%%%%%%%%%%%%
% RUN THE MODEL %
%%%%%%%%%%%%%%%%%

gmarkers = combine(parms,fminparms);
for trial=1:parms.nTrials	
    markers = gmarkers;
    for pos=1:parms.ll
        Vin = markers(pos,:)+(parms.NoiseSD.*randn(1,parms.ll)*parms.OutInt*pos);
        negVals = Vin < 0;
        Vin(negVals) = 0;
        Vout = W*Vin'+(parms.NoiseMean+parms.NoiseSD.*randn(1,parms.ll))';
        for cycle=1:parms.MaxIters
            if (max(Vout)>parms.CQThresh)
                [~, recall] = max(Vout);
                markers(:,recall) = markers(:,recall)*(1-parms.ResSupp);
                allRes(trial,pos) = recall;
                allRts(trial,pos) = cycle;
            break
            else
                Vin = Vout; 
                negVals = Vin<0;
                Vin(negVals) = 0; 
                Vout = W*Vin+(parms.NoiseMean+parms.NoiseSD.*randn(1,parms.ll))';
            continue 
            end
        end
    end
end
allRts = allRts * fminparms.Scaling;
scoring(parms,allRes,allRts);