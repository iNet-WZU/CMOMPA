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
function Positions=cmompa_initialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end
end
end