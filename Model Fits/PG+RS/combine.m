function markers = combine(parms,fminparms)

% Retrieve primacy gradient
primacy = primgrad(parms,fminparms);

% Retrieve position markers
markers = createmarkers(parms); 

% Weighting of primacy gradient and item markers
markers = (1-parms.Mix).*markers + parms.Mix.*repmat(primacy,parms.ll,1);