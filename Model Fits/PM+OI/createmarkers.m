function markers = createmarkers(parms,fminparms) 
markers = zeros(parms.ll,parms.ll);  
for i=1:parms.ll
    for j=1:parms.ll
        markers(i,j) = fminparms.ItemDistinct.^abs(i-j);
    end
end

% Weighting and normalisation
markers = fminparms.ItemWeight * (markers./repmat(sum(markers'),parms.ll,1)');