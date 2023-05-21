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
%function [fit,sub_HV,P_1] =cmompa(FUN, varargin)
function [fit,sub_IGD,P_1] =cmompa(FUN, varargin)

if ~mod(nargin, 2)
    error('MATLAB:narginchk:notEnoughInputs', ...
        'I have no idea about this, you can guess it');
end
%% Parameter processing
for ind = 1:2:nargin-1
    switch lower(varargin{ind})
        case 'lb'
            lb = varargin{ind + 1};
        case 'ub'
            ub = varargin{ind + 1};
        case 'numobj'
            numObj = varargin{ind + 1};
        case 'max_iter'
            Max_iter = varargin{ind + 1};
        case 'searchagents_no'
            SearchAgents_no = varargin{ind + 1};
        case 'dim'
            dim = varargin{ind + 1};
        case 'numgroup'
            numGroup = varargin{ind + 1};
        case 'minmax'
            if strcmp(varargin{ind + 1}, 'min')
                flagMinMax = 0;
            else
                flagMinMax = 1;
            end
        case 'plotflag'
            plotFlag = varargin{ind + 1};
        otherwise
            error('The function don''t support this parameter');
    end
end
%% Initialization
Iter=0;
P=0.5;
sub_IGD=[];
sub_HV=[];
if flagMinMax
    fit = -inf*ones(SearchAgents_no, numObj);
else
    fit = inf*ones(SearchAgents_no, numObj);
end
%% interative optimization start
if (plotFlag)
    figure(1); hold on;
    h = animatedline;
    h.LineStyle = 'none'; h.Marker = '.'; h.Color = 'r';
    title(FUN)
end

while Iter<Max_iter

    %------------------------------------------------------------
    if Iter==0
        Prey=cmompa_initialization(SearchAgents_no,dim,ub,lb);

        [Z,SearchAgents_no] = UniformPoint(SearchAgents_no,numObj);
        [subfit, ~,~] = cmompa_getMOFcn(FUN, Prey, numObj);
        Zmin  = min(subfit,[],1);
        [Prey,FrontNo]=EnvironmentalSelection(FUN,Prey,SearchAgents_no,numObj,Z,Zmin);
        Prey_old=Prey;
        if any(find(FrontNo==1)>SearchAgents_no)
            FrontNo=FrontNo(1:SearchAgents_no);
        end
    end

    temp = find(FrontNo==1);

    temp_1 =  Prey(temp,:);
    temp_index=ceil(SearchAgents_no/length(temp));
    Elite_1=repmat(temp_1,temp_index,1);
    Elite= Elite_1(1:SearchAgents_no,:);
    %------------------------------------------------------------

    CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
    RL=0.05*cmompa_levy(SearchAgents_no,dim,1.5);   %Levy random number vector
    RB=randn(SearchAgents_no,dim);          %Brownian random number vector
    stepsize=zeros(SearchAgents_no,dim);
    for i=1:size(Prey,1)
        for j=1:size(Prey,2)
            R=rand();
            %------------------ Phase 1 (Eq.12) -------------------
            if Iter<Max_iter/3
                stepsize(i,j)=RB(i,j)*(Elite(i,j)-RB(i,j)*Prey(i,j));
                Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j);

                %--------------- Phase 2 (Eqs. 13 & 14)----------------
            elseif Iter>Max_iter/3 && Iter<2*Max_iter/3

                if i>size(Prey,1)/2
                    stepsize(i,j)=RB(i,j)*(RB(i,j)*Elite(i,j)-Prey(i,j));
                    Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j);
                else
                    stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*Prey(i,j));
                    Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j);
                end

                %----------------- Phase 3 (Eq. 15)-------------------
            else

                stepsize(i,j)=RL(i,j)*(RL(i,j)*Elite(i,j)-Prey(i,j));
                Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j);

            end
        end
    end

    %------------------------------------------------------------
    for i=1:size(Prey,1)

        Flag4ub=Prey(i,:)>ub;
        Flag4lb=Prey(i,:)<lb;
        Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

    end
    Prey_evo=Prey;

    %%
    Prey_gau = cmompa_Gaussian_search(Prey,SearchAgents_no,dim,ones(1,dim).*ub,ones(1,dim).*lb);

    %%

    Offspring=[];
    % %
    [Population_objs_evo,~ ]= cmompa_getMOFcn(FUN, Prey_evo, numObj);
    [Population_objs_gau,~ ]= cmompa_getMOFcn(FUN, Prey_gau, numObj);

    total_objs=[Population_objs_evo;Population_objs_gau];
    fit_total_objs=calFitness(total_objs);
    fit_Population_objs_evo=fit_total_objs(1:SearchAgents_no);
    fit_Population_objs_gau=fit_total_objs(SearchAgents_no+1:end);

    rank1=randperm(SearchAgents_no);
    fit_Population_objs_evo= fit_Population_objs_evo(rank1);
    Prey_evo= Prey_evo(rank1,:);
    rank2=randperm(SearchAgents_no);
    fit_Population_objs_gau=fit_Population_objs_gau(rank2);
    Prey_gau=Prey_gau(rank2,:);
    for i=1:SearchAgents_no
        if fit_Population_objs_evo >= fit_Population_objs_gau

            Offspring      = [Offspring;Operator(Prey_gau(i,:),Prey_evo(i,:),lb,ub,dim)];
        else

            Offspring     = [Offspring;Operator(Prey_evo(i,:),Prey_gau(i,:),lb,ub,dim)];
        end
    end
    if(sum(any(Offspring<0,2)) >=1 )
        delet=find(any( Offspring<0,2)==1);
        Offspring(delet,:)=[];
    end
    %%
    two_Prey = [Prey_old;Prey_evo;Prey_gau;Offspring];
    two_loc=unique(two_Prey,'rows');
    [subfit,~ ,P_1] = cmompa_getMOFcn(FUN, two_loc, numObj);
    Zmin       = min([Zmin;subfit],[],1);
    Prey=EnvironmentalSelection(FUN,two_loc,SearchAgents_no,numObj,Z,Zmin);
    [fit, ~,~] = cmompa_getMOFcn(FUN, Prey, numObj);
    Prey_old=Prey;
    sub_IGD(Iter+1)=cmompa_IGD(fit,P_1); 
    %sub_HV(Iter+1)=cmompa_HV(fit,P_1);   
    if (plotFlag && mod(Iter, 1)==0)
        clearpoints(h);
        if numObj==3
            addpoints(h, fit(:, 1), fit(:, 2), fit(:, 3));
        elseif numObj==2
            addpoints(h, fit(:, 1), fit(:, 2));
        end
        drawnow
        %         pause()
    end

    Iter=Iter+1;
    if  Iter==Max_iter
        sub_HV(Iter+1)=cmompa_HV(fit,P_1);
    end
    Iter
end
end

function Fitness = calFitness(PopObj)
% Calculate the fitness by shift-based density

N      = size(PopObj,1);
fmax   = max(PopObj,[],1);
fmin   = min(PopObj,[],1);
PopObj = (PopObj-repmat(fmin,N,1))./repmat(fmax-fmin,N,1);
Dis    = inf(N);
for i = 1 : N
    SPopObj = max(PopObj,repmat(PopObj(i,:),N,1));
    for j = [1:i-1,i+1:N]
        Dis(i,j) = norm(PopObj(i,:)-SPopObj(j,:));
    end
end
Fitness = min(Dis,[],2);
end




