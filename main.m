warning('off')
clear, clc
a_cmompa=[];
 for i=1:1
%%
    %ZDT系列
        %           M    D	Range                   
        %ZDT1-ZDT3	2	30	xi∈[0,1],1≤i≤D	
        %ZDT4       2	10	x1∈[0,1],xi∈[-5,5],2≤i≤D	'lb', [0 -5*ones(1,9)], 'ub', [1 5*ones(1,9)]
        %ZDT6       2	10	xi∈[0,1],1≤i≤D	
    %DTLZ系列
        %              M   D	Range  
        %DTLZ1          3	7	xi∈[0,1],1≤i≤D	
        %DTLZ2-DTLZ6	3	12	xi∈[0,1],1≤i≤D	
        %DTLZ7          3	22	xi∈[0,1],1≤i≤D	

%     [fit,HV,P] = cmompa('ZDT6', 'Max_iter', 3000, 'SearchAgents_no',100,...
%             'minmax', 'min', 'plotFlag', 0, 'dim', 10, 'numObj', 2, ...
%             'numgroup', 1, 'lb', 0, 'ub', 1);
%         %i
%         a_cmompa(i) = HV(end);

%%
    %WFG系列
    %          M   D	Range  
    %WFG3-WFG9 3  12	zi∈[0,2i],1≤i≤D	

    final_lb =zeros(1,12);
    final_ub =2 : 2 : 2*12;%
    [fit,HV,P] = cmompa('WFG2', 'Max_iter', 3000, 'SearchAgents_no',100,...
            'minmax', 'min', 'plotFlag', 0, 'dim', 12, 'numObj', 3, ...
            'numgroup', 1, 'lb', final_lb, 'ub', final_ub);
         %i
         a_cmompa(i) = HV(end);
 end
b1_avg_cmompa=mean(a_cmompa);
b2_std_cmompa=std(a_cmompa);


%scatter3(P(:, 1), P(:, 2),P(:,3));
 %scatter(P(:, 1), P(:, 2));
% grid on;  