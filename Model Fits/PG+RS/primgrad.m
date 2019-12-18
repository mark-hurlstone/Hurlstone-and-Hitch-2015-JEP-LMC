function pgrad = primgrad(parms,fminparms) 
pgrad = zeros(1,parms.ll);
for i=1:parms.ll	
	pgrad(i) = fminparms.GradStart*fminparms.GradDecrease.^(i-1);
end
