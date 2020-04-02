# Delay-Optimization
Delay optimization compared with Delay and routing Optimization


1===> In order to Run Monte Carlos simulation, "MainMONTECARLOS.m" should run.

1.1===> "MainMONTECARLOS.m" is responsible for running the single objective function that minimises the delay and 
the multi objective function that minimises both the delay and routing cost.

1.2===> The main objective of the Monte Carlo simulation is to show that the average delay increases, when the number of requests
increases. Also, the delay difference between when considering only minimizing delay and we have a joint objective optimization. 
The gap increases rapidly when the number of requests increases.

2===> To observe the delay when arrival rate increases, "MainRequestsChangingResults.m" should be run 

2.1===>In "MainRequestsChangingResults.m" at every iteration arrival Rate increases runs  the single objective optimization model that minimises the delay and the multi objective optimization model that minimises both the delay and routing cost. 
        
2.2===>The main objective of this simulation is to show that as the requested rate increases, the number of common links increases between chosen paths to ensure a lower routing cost. Therefore, the delay value increases faster for joint delay and routing cost optimization solution compared to single delay optimization solution.

#Note That Results might change everytime the simulation runs due to some random input.
