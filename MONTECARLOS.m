tic

jj=1;
jjj=1;
results=zeros();
ttime1=zeros();
ti=zeros();
SumReqRatePerFixedNumReq=zeros();
p = randperm(5,5);
T= sort(p)+5;

for ii = 1 : 2
    numberOfRequests=T(ii);
    var=0;
    for it = 1:2
        [OverallMinDelay,OverallMinRoutingCostAndDelay,OverallMinDelayinMOO,sumRrateReq]=montecarlosfunc(numberOfRequests);
        %if OverallMinDelay && OverallMinDelayinMOO
        ttime1(jj)=OverallMinDelay;
        ti(jj)=numberOfRequests;
        results(jj,1)=OverallMinDelay;
        results(jj,2)=numberOfRequests;
        results(jj,3)=sumRrateReq;
        jj=jj+1;
        
        ttime1(jj)=OverallMinDelayinMOO;
        ti(jj)=numberOfRequests+0.5;
        results(jj,1)=OverallMinDelayinMOO;
        results(jj,2)=numberOfRequests+0.5;
        results(jj,3)=sumRrateReq;
        jj=jj+1;
        %end
        var=var+sumRrateReq;
        
        
    end
    SumReqRatePerFixedNumReq(jjj,1)=numberOfRequests;
    SumReqRatePerFixedNumReq(jjj,2)=var;
    jjj=jjj+1;
end
%boxplot
nreq=zeros();
cmp=1;
for i=1:length(T)
    if T(i) ~= 0
        nreq(cmp)=T(i);
        cmp=cmp+1;
    end
end
t=0;
color=zeros(length(T)*2,1);
for i=1:length(T)*2
    if t==0
        color(i) = 'y';
        t=1;
    else
        color(i) = 'c';
        t=0;
    end
    nreq=sort(nreq);
    
end


boxplot(ttime1,ti)
title('Delay optimization compared with both delay and routing cost optimization (changing number of requests)')
xlabel('Number of requests') % x-axis label
ylabel('Delay') % y-axis label
h = findobj(gca,'Tag','Box');

for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),color(j));
end

j=1;
for i=1:length(nreq)
    labels(j) = nreq(i);
    labels(j+1)= nreq(i);
    j=j+2;
end

set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
legend('Routing and Delay Optimization','Delay Optimization','Location','northwest','Orientation','horizontal'); % Add a legend
runTime = toc