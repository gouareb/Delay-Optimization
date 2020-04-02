function [b,beq,C,Aeq,A,x,fval,exitflag,output]= minofRoutingCostANDdelay( w1,w2,Spl,Nr,RrateReq,n,nrequest,npaths,nnode,shortestPaths,totalCosts,RrateAllocated,Xl,linksCapacity,linksRealCapacity,Cnodes,Wkp)
format long
%link is the number of links
%nBp is the number of breaking points
[nlink,nBp]=size(n);

%number of variables in the function
numVariables=(nBp*nlink)+(nrequest*npaths)+(nrequest*nnode)+(nrequest*nnode*npaths);
%intcon=numVariables;
j=1;
for i=(nBp*nlink)+1:numVariables
    intcon(j)=i;
    j=j+1;
end
%Number of slopes for all the links
numZ=0;
for i= 1:size(n)
    numZ=numZ+n(i)-1;
end

%lower bund
lb=zeros(numVariables,1);
%upper bund
ub=Inf(numVariables,1);
for i= (nBp*nlink)+1:numVariables
    ub(i)=1;
end

%Coefficient vector
C=zeros(numVariables,1);
j=1;
for i = 1:nlink
    for y = 1:nBp
        %loop on breaking points to compare
        C(j,:)=w1./(linksRealCapacity(i)-n(i,y));
        j=j+1;
    end
end
j=(nlink*nBp)+1;
for i = 1:nrequest
    for y = 1:npaths
        %loop on breaking points to compare
        C(j,:)=w2*totalCosts(y);
        j=j+1;
    end
end
j2=j;
%{
for i = 1:nrequest
    for y = 1:npaths
        S=0;
        for j = 1:nlink
        S=S+Spl(y,j)*1./(linksRealCapacity(j)-RrateReq(i));
        end
        C(j2,:)=S;
        j2=j2+1;
    end
    
end
%}
%Create inequality constraint matrix A
A = zeros((nlink*2)+(nnode)+(nnode*nrequest)+(nrequest*npaths)+(nnode*nrequest*npaths),numVariables);
size(A);
%constraint1

j2=nlink;
for j = j2+ 1:(nlink*2)
    compteur=(nlink*nBp)+1;
    REQ=1;
    for i=1:nrequest
        
        for ii=1:2
            A(j,compteur)=RrateReq(i)*Spl(REQ,j-j2);
            
            compteur=compteur+1;
            REQ=REQ+1;
        end
    end
    j3=j;
end
%constraint2 normally done tested
%constraint2

for j = j3+1:(nlink*2)+nnode
    
    compteur=(nlink*nBp)+(nrequest*npaths)+(nrequest*nnode)+1;
    REQ=1;
    for i=1:nrequest
        for ii=1:2
            for iii=1:nnode
                if(iii==j-j3)
                    A(j,compteur)=Nr(i)*Wkp(REQ,j-j3);
                end
                compteur=compteur+1;
            end
            REQ=REQ+1;
        end
    end
    j4=j;
end
%constraint3
%done
i=1;
ii=1;
for j = j4+1:(nlink*2)+nnode+(nrequest*nnode)
    %for decision variable Vrk
    compteur1=(nlink*nBp)+(nrequest*npaths)+1;
    for jj = 1:nrequest*nnode
        if(jj==j-j4)
            A(j,compteur1)=-1;
        end
        compteur1=compteur1+1;
        if(ii==nnode)
            i=i+1;
            ii=0;
        end
        ii=ii+1;
    end
    j5=j;
end

comp21=j4+1;

%for decision variable Zrpk
%for Z1p1:for the same req and node in one line summation of the paths so 3
%1 per line justo
for j=1:nrequest
    for jj=1:nnode
        comp22=(nlink*nBp)+(nrequest*npaths)+(nrequest*nnode)+1;
        for i=1:nrequest
            for ii=1:npaths
                for iii=1:nnode
                    if(j==i && jj==iii)
                        A(comp21,comp22)=1;
                    end
                    comp22=comp22+1;
                end
            end
            
        end
        comp21=comp21+1;
    end
end
%constraint4
%done
i=1;
ii=1;
for j = j5+1:(nlink*2)+nnode+(nrequest*nnode)+(nrequest*npaths)
    %for decision variable PSIrk
    compteur1=(nlink*nBp)+1;
    for jj = 1:nrequest*npaths
        if(jj==j-j5)
            A(j,compteur1)=-1;
        end
        compteur1=compteur1+1;
        if(ii==npaths)
            i=i+1;
            ii=0;
        end
        ii=ii+1;
    end
    j6=j;
end

comp21=j5+1;

%for decision variable Zrpk
%for Z11K:for the same req and path in one line summation of the node so 6
%1 per line justo
for j=1:nrequest
    for jj=1:npaths
        comp22=(nlink*nBp)+(nrequest*npaths)+(nrequest*nnode)+1;
        for i=1:nrequest
            for ii=1:npaths
                for iii=1:nnode
                    if(j==i && jj==ii)
                        A(comp21,comp22)=1;
                    end
                    comp22=comp22+1;
                end
            end
            
        end
        comp21=comp21+1;
    end
end
%constraint5

comp1=j6+1;
%for the three decision variables at once
for j=1:nrequest
    for jj=1:npaths
        for jjj=1:nnode
            %Psi rp compteur
            comp21=(nlink*nBp)+1;
            for i=1:nrequest
                for ii=1:npaths
                    if(j==i && jj==ii)
                        A(comp1,comp21)=1;
                    end
                    comp21=comp21+1;
                end
            end
            %Vrk compteur
            comp22=(nlink*nBp)+(nrequest*npaths)+1;
            for i=1:nrequest
                for ii=1:nnode
                    if(j==i && jjj==ii)
                        A(comp1,comp22)=1;
                    end
                    comp22=comp22+1;
                end
            end
            %Zrpk compteur
            comp23=(nlink*nBp)+(nrequest*npaths)+(nrequest*nnode)+1;
            for i=1:nrequest
                for ii=1:npaths
                    for iii=1:nnode
                        if(j==i && jj==ii && jjj==iii)
                            A(comp1,comp23)=-1;
                        end
                        comp23=comp23+1;
                    end
                end
            end
            comp1=comp1+1;
        end
    end
end

%Create inequality constraint matrix b
b = zeros((nlink*2)+(nnode)+(nnode*nrequest)+(nrequest*npaths)+(nnode*nrequest*npaths),1);

%constraint1
j2=nlink;
for j = j2+1:nlink*2
    b(j,1)=linksCapacity(j-j2)-Xl(1,j-j2);
    j3=j;
end

%constraint2
c=1;
for j = j3+1:(nlink*2)+nnode
    b(j,1)=Cnodes(1,c);
    c=c+1;
    j4=j;
end
%constraint3
for j = j4+1:(nlink*2)+nnode+(nnode*nrequest)
    %b(j,1)=Cnodes(1,c);
    j5=j;
end
%constraint4
c=1;
for j = j5+1:(nlink*2)+nnode+(nnode*nrequest)+(nrequest*npaths)
    %b(j,1)=Cnodes(1,c);
    j6=j;
end
%constraint5

for j = j6+1:(nlink*2)+nnode+(nnode*nrequest)+(nrequest*npaths)+(nrequest*npaths*nnode)
    b(j,1)=1;
end

%Create equality constraint matrix Aeq
Aeq = zeros((nlink*2)+(nrequest*4),numVariables);

%constraint1

compteur=1;
for j = 1:nlink
    
    for i = 1:nBp
        Aeq(j,compteur)=n(j,i);
        compteur=compteur+1;
    end
    
 compteur2=nlink*nBp+1;
 REQ=1;
    for ii = 1:nrequest
        for iii = 1:2
            Aeq(j,compteur2)=-Spl(REQ,j)*RrateReq(1,ii);
            compteur2=compteur2+1;
             REQ=REQ+1;
        end
    end
      
    j2=j;
end

%constraint2
compteur=1;
for j = j2+1:nlink*2
    for i = 1:nBp
        Aeq(j,compteur)=1;
        compteur=compteur+1;
    end
    j3=j;
end

%constraint3
compteur=nlink*nBp+1;
for j=j3+1:(nlink*2)+nrequest
    for i=1:npaths
        %Rate Allocated For Request In total Paths
        Aeq(j,compteur)=RrateAllocated(i,j-j3);
        compteur=compteur+1;
    end
    
    j4=j;
end

%constraint4
compteur=nlink*nBp+1;
for j = j4+1:(nlink*2)+(nrequest*2)
    for i = 1:npaths
        Aeq(j,compteur)=1;
        compteur=compteur+1;
    end
    j5=j;
end

%constraint5
compteur=(nlink*nBp)+(nrequest*npaths)+1;
for j = j5+1:(nlink*2)+(nrequest*3)
    for i = 1:nnode
        Aeq(j,compteur)=1;
        compteur=compteur+1;
    end
    j6=j;
end
%constraint6
compteur=(nlink*nBp)+(nrequest*npaths)+(nrequest*nnode)+1;
REQ=1;
for j = j6+1:(nlink*2)+(nrequest*4)
    for ii = 1:2
        for iii = 1:nnode
            
            Aeq(j,compteur)=Wkp(REQ,iii);
            
            compteur=compteur+1;
        end
        REQ=REQ+1;
    end
end

%Create equality constraint matrix beq
beq = zeros((nlink*2)+(nrequest*4),1);

%constraint1
for j = 1:nlink
    beq(j)=Xl(j);
    j2=j;
end

%constraint2
for j = j2+1:nlink*2
    beq(j)=1;
    j3=j;
end

%constraint3
y=1;
RrateReq=RrateReq';
for j=j3+1:(nlink*2)+nrequest
    %{
        RAllReq=0;
        for i=1:npaths
            %Rate Allocated For Request In total Paths
            RAllReq=RAllReq+RrateAllocated(i,y);
        end
        beq(j)=RrateReq(y)-RAllReq;
    %}
    beq(j)=RrateReq(y);
    y=y+1;
    j4=j;
end

%constraint4
for j = j4+1:(nlink*2)+(nrequest*2)
    beq(j)=1;
    j5=j;
end

%constraint5
for j = j5+1:(nlink*2)+(nrequest*3)
    beq(j)=1;
    j6=j;
end

%constraint6
for j = j6+1:(nlink*2)+(nrequest*4)
    beq(j)=1;
end


%Mixed-integer linear programming solver using intlinprog
Asize=size(A);
AEQsize=size(Aeq);
Fsize=size(C);
options = optimoptions('intlinprog','CutGeneration','basic','MaxNodes',22);
[x,fval,exitflag,output]=intlinprog(C,intcon,A,b,Aeq,beq,lb,ub,options);

end