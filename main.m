% Developed in MATLAB R2020b
% Source codes demo version 1.0
% _____________________________________________________
%  Author, inventor and programmer of CMOMPA: Long Chen,
%  Email: chenlong@zjnu.edu.cn
%  Co-authors:Yingying Xu, Fangyi Xu, Qian Hu, Zhenzhou Tang
% _____________________________________________________
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
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning('off')
clear, clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      ZDT
%Parameters      numObj      dim	     lb & ub
%ZDT1-ZDT3	       2	     30	    xi∈[0,1],1≤i≤dim
%                                   final_lb = 0;
%                                   final_ub = 1;
%ZDT4              2	     10	    x1∈[0,1],xi∈[-5,5],2≤i≤dim
%                                   final_lb = [0 -5*ones(1,9)];
%                                   final_ub = [1 5*ones(1,9)];
%ZDT6              2	     10	    xi∈[0,1],1≤i≤dim
%                                   final_lb = 0;
%                                   final_ub = 1;
%%                      DTLZ
%Parameters      numObj      dim	     lb & ub
%DTLZ1             3	     7	    xi∈[0,1],1≤i≤dim
%                                   final_lb = 0;
%                                   final_ub = 1;
%DTLZ2-DTLZ6	   3	     12	    xi∈[0,1],1≤i≤dim
%                                   final_lb = 0;
%                                   final_ub = 1;
%DTLZ7             3	     22	    xi∈[0,1],1≤i≤dim
%                                   final_lb = 0;
%                                   final_ub = 1;
%%                       WFG
%Parameters      numObj      dim	     lb & ub
%WFG3-WFG9         3         12	    xi∈[0,2i],1≤i≤dim
%                                   final_lb = zeros(1,12);
%                                   final_ub = 2 : 2 : 2*12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a_mompa=[];
for i=1:1
        final_lb = 0;      %Different test functions choose different parameters
        final_ub = 1;      %Different test functions choose different parameters
        [fit,IGD,P] = cmompa('DTLZ1', ...  %test function name
        'Max_iter', 3000, ...  
        'SearchAgents_no',100,... 
        'minmax', 'min', ...      
        'plotFlag', 1, ...        
        'dim', 7, ...      %  Different test functions choose different parameters      
        'numObj', 3, ...    %  Different test functions choose different parameters  
        'numgroup', 1, ...        
        'lb', final_lb, ...       
        'ub', final_ub);         
    i
    a_cmompa(i) = IGD(end);
end
a_cmompa
b1=mean(a_cmompa);
b2=std(a_cmompa);

if size(P,2)==3
    scatter3(P(:, 1), P(:, 2),P(:,3));
else 
    scatter(P(:, 1), P(:, 2));
end