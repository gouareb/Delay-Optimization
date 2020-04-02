function [ OverallMinDelay,OverallMinRoutingCostAndDelay,OverallMinDelayinMOO,sumRrateReq] = montecarlosfunc( numberOfRequests )
% Description:
%In this function we initialize all the parameters
%We run first optimization model(Minimizing delay only)==> minofx function
%We run multi objective optimization (MOO) model (Mminimizing delay and
%routing cost at the same time ) ==> minofRoutingCostANDdelay
% The Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format long


%Matrix G define the Graph
%GENERATE MATRIX

G = [inf inf inf inf inf inf randi([2 4],1,1) inf randi([2 4],1,1) randi([2 4],1,1) inf inf inf inf inf inf randi([2 4],1,1) inf inf randi([2 4],1,1) inf inf;
     inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf inf inf inf inf inf inf inf inf inf randi([2 4],1,1) randi([2 4],1,1) inf inf randi([2 4],1,1) inf inf randi([2 4],1,1) randi([2 4],1,1) randi([2 4],1,1) inf;
     inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf randi([2 4],1,1) inf randi([2 4],1,1) randi([2 4],1,1) inf inf inf inf inf randi([2 4],1,1) inf inf inf randi([2 4],1,1) randi([2 4],1,1) inf randi([2 4],1,1) randi([2 4],1,1) randi([2 4],1,1) randi([2 4],1,1);
     inf inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf inf inf inf inf inf inf inf inf inf randi([2 4],1,1) inf inf randi([2 4],1,1) inf inf inf inf inf inf inf;
     inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf inf inf inf randi([2 4],1,1) randi([2 4],1,1) inf randi([2 4],1,1) inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf inf randi([2 4],1,1) inf inf inf inf randi([2 4],1,1) randi([2 4],1,1) randi([2 4],1,1) inf inf inf inf randi([2 4],1,1) randi([2 4],1,1) inf inf inf inf randi([2 4],1,1);
     inf inf randi([2 4],1,1) inf inf inf inf inf inf inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf;
     inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf randi([2 4],1,1) inf inf inf inf;
     inf inf inf inf inf inf inf inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf inf inf;
     inf inf inf inf randi([2 4],1,1) inf inf inf randi([2 4],1,1) inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf;
     inf inf randi([2 4],1,1) inf inf inf randi([2 4],1,1) inf randi([2 4],1,1) inf inf inf inf inf inf inf inf inf inf inf inf inf;
     inf inf inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf inf inf inf inf inf inf inf;
     randi([2 4],1,1) inf inf inf inf inf randi([2 4],1,1) inf randi([2 4],1,1) inf inf randi([2 4],1,1) inf randi([2 4],1,1) inf inf inf randi([2 4],1,1) inf randi([2 4],1,1) inf randi([2 4],1,1);
     randi([2 4],1,1) inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf randi([2 4],1,1) randi([2 4],1,1) inf randi([2 4],1,1) inf inf inf inf;
     inf inf inf inf inf inf inf inf inf inf inf inf inf inf randi([2 4],1,1) randi([2 4],1,1) inf inf inf inf inf inf;
     randi([2 4],1,1) inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf inf inf randi([2 4],1,1) inf inf inf inf inf inf;
     
    ];



%Number of node are define in the variable numNodes
numNodes=size(G,1);
%defining number of links in variable link
[linksNodes,linksCapacity,linksRealCapacity]=Llinks(G,numNodes);
links=size(linksCapacity);
links=links(1);



%defining the number of shortest paths in variable k, S define the start edge

S=1;

p = randperm(12,numberOfRequests);
%T define the destination edge
T= p'+10;
% K number of shortest paths: 2
k=2;

for i=1:numberOfRequests
    %Precalculation n shortest path from a node S to a node T with Dijkstra
    [shortestPaths(i,:), totalCosts(i,:)] = kShortestPath(G, S, T(i), k);
    [m(i,:),sizSP(i,:)]=size(shortestPaths(i,:));
end


%Create a matrix of binary defining if a link belong to a path first
%lines for shortest path of first request
npaths=0;
for i=1:numberOfRequests
    npaths=npaths+sizSP(i,:);
end

Spl = zeros(sizSP(1,:)*numberOfRequests,links);
cmpt=1;
for t=1:numberOfRequests
    for i=1:sizSP(t,:)
        SP=shortestPaths{t,i};
        for j=1:links
            siz=size(SP);
            for y=1:(siz(2)-1)
                if (SP(y)==linksNodes(j,1) && SP(y+1)==linksNodes(j,2))
                    Spl(cmpt,j)=1;
                end
            end
        end
        cmpt=cmpt+1;
    end
end
%%%%%%%%%%%%%A continuer
%Create a matrix of binary defining if a node belong to a path
Wkp = zeros(sizSP(1,:),numNodes);
cmpt=1;
for t=1:numberOfRequests
    for i=1:sizSP(t,:)
        SP=shortestPaths{1,i};
        for j=1:links
            nodes=zeros(1,2);
            
            if (Spl(cmpt,j)==1)
                
                nodes=linksNodes(j,:);
            end
            if (nodes(1,1)~=0 && nodes(1,2)~=0)
                Wkp(cmpt,nodes(1,1))=1;
                Wkp(cmpt,nodes(1,2))=1;
            end
            
        end
        cmpt=cmpt+1;
    end
end

%Create node capacity
Cnodes=zeros(numNodes : 1);
%Create different capacities for each node randomely
for i= 1:numNodes
    if(sum(Wkp(:,i))~=0)
        %Cnodes(i)=randi([2 4],1,1);
        Cnodes(i)=4;
    else
        Cnodes(i)=0;
    end
end



%Create list of Breaking Points for every link
for i= 1:links
    [BreakingPointsList(i,:)]=piecewiseFunction(linksCapacity(i));
end

%total traffic in links
Xl=zeros(links : 1);
for i=1:links
    Xl(i) = 2;
end



%Create n requests in R
numberOfFunctions=10;
VNFs= VNF(numberOfFunctions);
[R,RPriority,RrateAllocated,RrateReq,Nr]=Requests(numberOfRequests,k,Cnodes);

%Create matrix of VNFS related to requests
for i=1:numberOfRequests
    for j=1:numberOfFunctions
        RVNF(i,j)=ismember(VNFs(j), R(i,:));
    end
end


%Minimizing The objective function
%Minimizing Objective function1 Min delay
[b,beq,C,Aeq,A,x,fval,exitflag,output]= minofx(Spl,Nr,RrateReq,BreakingPointsList,numberOfRequests,k,numNodes,shortestPaths,totalCosts,RrateAllocated,Xl,linksCapacity,linksRealCapacity,Cnodes,Wkp);
OverallMinDelay=fval;

%Minimizing Multi Objective functions Min delay + routing cost
compt=1;
MOO=zeros(10,4);
for i=0:0.01:1
    if (i~=0 && i~=1)
        weigh1=i;
        weigh2=1-i;
        [b,beq,C,Aeq,A,x2,fval2,exitflag,output]= minofRoutingCostANDdelay(weigh1,weigh2,Spl,Nr,RrateReq,BreakingPointsList,numberOfRequests,k,numNodes,shortestPaths,totalCosts,RrateAllocated,Xl,linksCapacity,linksRealCapacity,Cnodes,Wkp);
        
        
        cmp=1;
        RoutingCostOptCheck1=0;
        for ii=1:links
            [m,n] = size(BreakingPointsList);
            for j =1:n
                RoutingCostOptCheck1=RoutingCostOptCheck1+(x2(cmp)*(1/(linksRealCapacity(ii)-BreakingPointsList(ii,j))));
                cmp=cmp+1;
                
            end
        end
        format long
        
        MOO(compt,1)=RoutingCostOptCheck1;
        MOO(compt,2)=fval2;
        MOO(compt,3)=weigh1;
        MOO(compt,4)=weigh2;
        compt=compt+1;
    end
end
[OverallMinRoutingCostAndDelay,index ] = min(MOO(:,2));
OverallMinDelayinMOO=MOO(index,1);
%Weight for objective function 1: delay
weigh1=MOO(index,3);
%Weight for objective function 2: Routing cost
weigh2=MOO(index,4);

sumRrateReq=sum(RrateReq);



end

