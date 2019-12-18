function rmsd = rmsdev(data, model)
n = length(data);
sd = zeros(1,n);
for i=1:n
	sd(i) = (model(i)-data(i)).^2;
end

rmsd = sqrt(sum(sd)/n);


