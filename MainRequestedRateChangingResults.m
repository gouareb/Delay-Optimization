tic

jj=1;

results=zeros();


    numberOfRequests=10;
    requestedRateRangeA=50;
    requestedRateRangeB=50;
    for it = 1:5
       
        %Run RequestedRateChangingResults function at every iteration with different increased Rate 
        %RequestedRateChangingResults function runs  the single objective
        %that minimises the delay and the multi objective functions
        %that minimises both the delay and routing cost
        [OverallMinDelay,OverallMinRoutingCostAndDelay,OverallMinDelayinMOO,sumRrateReq]=RequestedRateChangingResults( numberOfRequests,requestedRateRangeA,requestedRateRangeB);
        results(jj,1)=requestedRateRangeA;
        results(jj,2)=requestedRateRangeB;
        results(jj,3)=OverallMinDelay;
        results(jj,4)=OverallMinDelayinMOO;

         requestedRateRangeA=requestedRateRangeA+100;
         requestedRateRangeB=requestedRateRangeB+100;
         jj=jj+1;
        
    end
    
  %Display the results in a figure to show how the delay changes with the
  %increased requested rate.
  x=results(:,2);
  y=results(:,3);
  y2=results(:,4);
plot(x,y);
hold on
plot(x,y2,':');
legend('Routing and Delay Optimization','Delay Optimization','Location','northwest','Orientation','horizontal');
xlabel('Requested Rate') 
ylabel('Delay in seconds') 
runTime = toc
