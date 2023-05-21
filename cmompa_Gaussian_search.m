% Please refer to the main paper:
% Balancing the trade-off between cost and reliability for wireless sensor networks: a multi-objective optimized deployment method
% Long Chen, Yingying Xu, Fangyi Xu, Qian Hu, Zhenzhou Tang
% Applied Intelligence
% DOI: https://doi.org/10.1007/s10489-022-03875-9
%        AND
% Marine Predators Algorithm: A nature-inspired metaheuristic
% Afshin Faramarzi, Mohammad Heidarinejad, Seyedali Mirjalili, Amir H. Gandomi
% Expert Systems with Applications
% DOI: https://doi.org/10.1016/j.eswa.2020.113377
% _____________________________________________________
function Prey = cmompa_Gaussian_search(Prey,SearchAgents_no,dim,ub,lb)
    for i=1:SearchAgents_no
        d=randperm(dim,1);
        Prey(i,d)=Prey(i,d)+(ub(d)-lb(d))*randn;
    end

    for i=1:size(Prey,1)  
            Flag4ub=Prey(i,:)>ub;
            Flag4lb=Prey(i,:)<lb;    
            Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;  
    end 

end