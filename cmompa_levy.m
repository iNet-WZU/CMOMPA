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
% Input parameters
% n     -> Number of steps 
% m     -> Number of Dimensions 
% beta  -> Power law index  % Note: 1 < beta < 2
% Output 
% z     -> 'n' levy steps in 'm' dimension
%_________________________________________________________________________

function [z] = cmompa_levy(n,m,beta)

    num = gamma(1+beta)*sin(pi*beta/2); % used for Numerator 
    
    den = gamma((1+beta)/2)*beta*2^((beta-1)/2); % used for Denominator

    sigma_u = (num/den)^(1/beta);% Standard deviation

    u = random('Normal',0,sigma_u,n,m); 
    
    v = random('Normal',0,1,n,m);

    z =u./(abs(v).^(1/beta));

  
  end

