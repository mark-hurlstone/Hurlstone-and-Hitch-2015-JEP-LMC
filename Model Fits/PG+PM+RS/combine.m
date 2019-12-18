function markers = combine(parms,fminparms)

% Retrieve primacy gradient
primacy = primgrad(parms,fminparms);

% Retrieve position markers
markers = createmarkers(parms,fminparms); 

% Weighting of primacy gradient and item markers
markers = (1-fminparms.Mix).*markers + fminparms.Mix.*repmat(primacy,parms.ll,1);