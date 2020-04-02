function [R,RPriority,RrateAllocated,RrateReq,Nr] = Requests(numberOfRequests,npaths,Cnodes)
format long
% Description:
% In this function we initialize vectors and matrix
% related to requets parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Create requests with the functions requested
%{
R = [1 2 5 7 0 ;
    9 3 4 7 0 ;
    4 6 9 1 3 ;
    1 3 8 1 2 ;
    2 6 3 2 1 ;
    3 4 8 5 6 ;
    2 4 7 5 6 ;
    8 4 7 5 6 ;
    2 4 7 5 0 ;
    2 6 3 2 1 ;
    ];
%}
% Create requests with random functions chains (each number express a function)
for i=1:numberOfRequests
R(i,:)=randperm(10,5);
end

%Affect a weight for every request
%RPriority=randi([1 numberOfRequests],numberOfRequests,1);
RPriority=randperm(numberOfRequests,numberOfRequests);
%RPriority= [1;3;2;10;8;9;4;7;5;6];

%Requested rate per request
%RrateReq=randi([1 numberOfRequests],1,numberOfRequests)
%RrateReq= [4 2 4 4 2 2 2 4 2 2];
RrateReq= randi([500 600],1,numberOfRequests);
%Nr represent the resource requirement for every request
%Nr=randi([1 min(Cnodes)],1,numberOfRequests);
%Nr= [3 2 2 2 2 2 3 3 3 3];
Nr=randi([1 2],1,numberOfRequests);
%Rate allocated in each path for every request
%RrateAllocated=[4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2;4 2 4 4 2 2 2 4 2 2];
RrateAllocated=repmat(RrateReq,npaths,1);
end