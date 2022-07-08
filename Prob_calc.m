 p=0.9;

ProbCoeff=zeros(12,12);
for k = 1:12
    for ll=0:k
    ProbCoeff(k,(ll+1)) = p^(ll)*((1-p)^(k-ll))*nchoosek(k,ll);
    ProbCoeff1(k,(ll+1)) = p^(ll)*((1-p)^(k-ll));
    end
    ll=[];
end
Prob_Coeff = ProbCoeff(:,2:end);
Prob_Coeff1 = ProbCoeff1(:,2:end);