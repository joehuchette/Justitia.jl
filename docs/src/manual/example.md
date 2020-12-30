```@meta
CurrentModule = Justitia
```

# [An example: Comparing two MILP solvers on MIPLIB instances]

We offer a simple example showcasing how you can use Justitia. We will compare
two MILP solvers (CPLEX and Gurobi) on a small selection of "easy" MIPLIB 2017
instances. You can do this with only a dozen lines of code:

```jl
using CPLEX, Gurobi, Justitia

instances = Dict(
    "10teams" => Justitia.MIPLIBInstance("10teams"),
    "22433" => Justitia.MIPLIBInstance("22433"),
)
approaches = Dict(
    "Gurobi" => Justitia.MOIBasedApproach{Gurobi.Optimizer}(),
    "CPLEX" => Justitia.MOIBasedApproach{CPLEX.Optimizer}(),
)

result_table = Justitia.CSVRecord("results.csv", Justitia.MILPResult)

Justitia.run_experiments!(result_table, instances, approaches, Justitia.MILPResult)
```

If all the packages are installed correctly, running this code will leave you
with a file `results.csv` with contents that look something like:

```
instance,approach,termination_status,primal_status,primal_bound,dual_bound,solve_time_sec,node_count,simplex_iters
10teams,Gurobi,OPTIMAL,FEASIBLE_POINT,924.0,924.0,0.6151671409606934,1,9157
10teams,CPLEX,OPTIMAL,FEASIBLE_POINT,924.0,924.0,2.1778600215911865,273,0
22433,Gurobi,OPTIMAL,FEASIBLE_POINT,21477.0,21476.0,0.10126018524169922,1,446
22433,CPLEX,OPTIMAL,FEASIBLE_POINT,21477.0,21477.0,0.09111189842224121,0,0
```
