function [linksNodes,linksCapacity,linksRealCapacity] = Llinks(graph,numNodes)
%UNTITLED8 Summary of this function goes here
% Define and intialise Links parameters
format long
k=1;
linksNodes=0;

for i=1:numNodes
    for j=1:numNodes
        test=0;
        if(graph(i,j)~=inf)
                %Create a Matrix describing each link by two nodes
                linksNodes(k,1)=i;
                linksNodes(k,2)=j;
                
                %By links Capacity we mean availible capacity
                linksCapacity(k)=2000;
                %By links Real Capacity we mean the real total capacity of the link
                linksRealCapacity(k)=linksCapacity(k)*100/99.99;
                k=k+1;
           % end
        end
        
    end
end
linksCapacity=linksCapacity';
end

