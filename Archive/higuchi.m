function fractalDim = higuchi(timeSeries,kMax)

[~, N] = size(timeSeries);

for k = 1:kMax
    for m = 1:k
        sum = 0;
        for i = 1:floor((N-m)/k)
            sum = abs(timeSeries(m+i*k)-timeSeries(m+(i-1)*k))+sum;
        end
        LM(m)=(sum*((N-1)/(floor((N-m)/k)*k)))/k;
    end
	L(k)=mean(LM);
	if L(k) == 0
		L(k) = 1e-3;
	end
    clear LM;
end

D_Points = 1:kMax;
Reg_x = log(1./D_Points);
Reg_x = [ones(kMax , 1) Reg_x'];
Out_Reg = regress((log(L(1:kMax)))', Reg_x);
fractalDim = Out_Reg(2);
end
