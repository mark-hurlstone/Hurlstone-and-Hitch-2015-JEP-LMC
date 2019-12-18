function [bestx,bestFval,bestdummy,bestoutput] = mywrapperLoopfmin(parmarray,obsspc,obsrtspc,obstrans,obsldf,parms) 

global score

bestFval = realmax;
bestx = parmarray.*0;
bestdummy=0;
bestoutput = 0;

for p1 = .65                            % fminparms.ItemDistinct
    for p2 = .85                        % fminparms.GradDecrease
        for p3 = [.3 .6 .9]             % fminparms.Mix
            for p4 = .95                % fminparms.ResSupp
                for p5 = 50             % fminparms.Scaling
                    tic
                    [x,fval,dummy,output] = fminsearchbnd(@bof,[p1 p2 p3 p4 p5],parms.LB,parms.UB);
                    toc
                    if fval < bestFval
                        bestFval = fval;
                        bestx = x;
                        bestdummy = dummy;
                        bestoutput = output;
                    end
                end
            end
        end
    end
end
    
% Nested function inherits data from wrapper function
    function lnL = bof(fminparms)
        cq(fminparms);
        obs =  [obsspc obsrtspc./10^4 obstrans obsldf./10^4]        
        pred = [score.accspc score.crtspc./10^4 score.trans./sum(score.trans) score.fltrdtransrt./10^4]
        n = length(obs) - sum(isnan(obs-pred));
        ssd = nansum((pred-obs).^2);        
        lnL = n * log(ssd/n); 
    end
end