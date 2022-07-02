function [Offspring, OffVel] = Operator(Loser,Winner,lb,ub,dim)
% The competitive swarm optimizer

% Copyright (c) 2020-2021 Cheng He

    %% Parameter setting
    LoserDec  = Loser;
    WinnerDec = Winner;
    [N,D]     = size(LoserDec);
%     if isempty(OffVel)
	    LoserVel  = zeros(N,D);
        WinnerVel = zeros(N,D);
%     end
    
    %% Competitive swarm optimizer
    r1     = repmat(rand(N,1),1,D);
    r2     = repmat(rand(N,1),1,D);
    OffVel = r1.*LoserVel + r2.*(WinnerDec-LoserDec);
    OffDec = LoserDec + OffVel + r1.*(OffVel-LoserVel);
    %OffDec = LoserDec + OffVel ;
	%% Add the winners
	OffDec = [OffDec;WinnerDec];
	OffVel = [OffVel;WinnerVel];
	N = size(OffDec,1);
    a=OffDec;
    %% Polynomial mutation
    lb=ones(1,dim).*lb;
    ub=ones(1,dim).*ub;
    Lower = repmat(lb,N,1);
    Upper = repmat(ub,N,1);
    disM  = 20;
    Site  = rand(N,D) < 1/D;
    mu    = rand(N,D);
    temp  = Site & mu<=0.5;
    OffDec       = max(min(OffDec,Upper),Lower);
    OffDec(temp) = OffDec(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                   (1-(OffDec(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
    temp  = Site & mu>0.5; 
    OffDec(temp) = OffDec(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                   (1-(Upper(temp)-OffDec(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
	Offspring = OffDec;
    
end