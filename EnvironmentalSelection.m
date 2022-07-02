function [Population,FrontNo]= EnvironmentalSelection(FUN,Population,N,M,Z,Zmin)
% The environmental selection of NSGA-III

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    if isempty(Zmin)
        Zmin = ones(1,size(Z,2));
    end

    %% Non-dominated sorting
    [Population_objs,~ ]= cmompa_getMOFcn(FUN, Population, M);
    if ~(isreal(Population_objs))
        1
    end
    [FrontNo,MaxFNo] = NDSort(Population_objs,N);
    Next = FrontNo < MaxFNo;%������һ��
    %% Select the solutions in the last front
    Last   = find(FrontNo==MaxFNo);%==���һ����±�
    if ~(isreal(Population_objs(Last,:)))
        1
    end
    Choose = LastSelection(Population_objs(Next,:),Population_objs(Last,:),N-sum(Next),Z,Zmin);%���ڲο�������һ��ѡ��k�� �߼�ֵ0��1
    Next(Last(Choose)) = true;%
    % Population for next generation
    Population = Population(Next,:);
%     Population_objs = getMOFcn(FUN, Population, M);
%     [FrontNo,~] = NDSort(Population_objs,N);
%     sort_No_y=sortrows([FrontNo',Population_objs ,Population],[1,2]);
    
end

function Choose = LastSelection(PopObj1,PopObj2,K,Z,Zmin)
% Select part of the solutions in the last front
    
    PopObj = [PopObj1;PopObj2] - repmat(Zmin,size(PopObj1,1)+size(PopObj2,1),1);%��ȥ�����
    if ~(isreal(PopObj))
        1
    end
    [N,M]  = size(PopObj);
    N1     = size(PopObj1,1);
    N2     = size(PopObj2,1);
    NZ     = size(Z,1);

    %% Normalization
    % Detect the extreme points
    Extreme = zeros(1,M);
    w       = zeros(M)+1e-6+eye(M);
    for i = 1 : M
        [~,Extreme(i)] = min(max(PopObj./repmat(w(i,:),N,1),[],2));
    end
    % Calculate the intercepts of the hyperplane constructed by the extreme
    % points and the axes
    Hyperplane = PopObj(Extreme,:)\ones(M,1);%A��������� A1���� B/A = B*A1��A\B = A1*B
    a = 1./Hyperplane;
    if any(isnan(a))%��a��Ԫ��ΪNaN������ֵ�����ڶ�Ӧλ���Ϸ����߼�1���棩�����򷵻��߼�0���٣�
        a = max(PopObj,[],1)';
    end
    % Normalization
    %a = a-Zmin';
    PopObj = PopObj./repmat(a',N,1);%���a��b�Ǿ���a./b����a��b�ж�Ӧ��ÿ��Ԫ��������õ�һ���µľ���

    %% Associate each solution with one reference point
    % Calculate the distance of each solution to each reference vector
    if ~(isreal(PopObj))
        1
    end
    Cosine   = 1 - pdist2(PopObj,Z,'cosine');%cosine�� �������,�н����Ҿ���Cosine distance(��cosine��)�������ƶ�= 1-���Ҿ���

    %�ܿ��¾���Jaccard distance(��jaccard��)Jaccard���볣��������������ǶԳƵĶ�Ԫ(0-1)���ԵĶ��󡣺���Ȼ��Jaccard���벻����0-0ƥ��[1]��
    %�н����Ҿ���Cosine distance(��cosine��)��Jaccard������ȣ�Cosine���벻������0-0ƥ�䣬�����ܹ�����Ƕ�Ԫ�����������ǵ�����ֵ�Ĵ�С��
    %�������ߣ����������ƶȺ�Ϊһ��
    %https://www.cnblogs.com/chaosimple/archive/2013/06/28/3160839.html

    Distance = repmat(sqrt(sum(PopObj.^2,2)),1,NZ).*sqrt(1-Cosine.^2);
%     Distance = pdist2(PopObj,Z,'euclidean');%����ע�͵��������Ҳ����Ŷ
    % Associate each solution with its nearest reference point
    [d,pi] = min(Distance',[],1);

    %% Calculate the number of associated solutions except for the last front of each reference point
    rho = hist(pi(1:N1),1:NZ);%�������front��ÿһ���ο��㣬���������ĸ���

    %% Environmental selection
    Choose  = false(1,N2);
    Zchoose = true(1,NZ);
    % Select K solutions one by one
    while sum(Choose) < K
        % Select the least crowded reference point
        Temp = find(Zchoose);
        Jmin = find(rho(Temp)==min(rho(Temp)));%���вο�������֮�����������ٵ��Ǹ��ο���
        j    = Temp(Jmin(randi(length(Jmin))));
        I    = find(Choose==0 & pi(N1+1:end)==j);
        % Then select one solution associated with this reference point
        if ~isempty(I)
            if rho(j) == 0
                [~,s] = min(d(N1+I));
            else
                s = randi(length(I));
            end
            Choose(I(s)) = true;
            rho(j) = rho(j) + 1;
        else
            Zchoose(j) = false;
        end
    end
end