struct MOIModel{T<:MOI.AbstractOptimizer} <: AbstractModel
    opt::T
end

function optimize!(model::MOIModel)
    optimize!(model.opt)
    return nothing
end

function tear_down(model::MOIModel, ::Type{MILPResult})
    primal_status = MOI.get(model, MOI.PrimalStatus())
    num_vars = MOI.get(model, MOI.NumberOfVariables())
    feas_point = (
        if primal_status == MOI.FEASIBLE_POINT
            [
                MOI.get(model, MOI.VariablePrimal(), MOI.VariableIndex(i))
                for i in 1:num_vars
            ]
        else
            nothing
        end
    )
    return MILPResult(
        termination_status = MOI.get(model, MOI.TerminationStatus()),
        primal_status = primal_status,
        feas_point,
        primal_bound = MOI.get(model, MOI.ObjectiveValue()),
        dual_bound = MOI.get(model, MOI.ObjectiveBound()),
        solve_time_sec = MOI.get(model, MOI.SolveTimeSec()),
        node_count = MOI.get(model, MOI.NodeCount()),
        simplex_iters = MOI.get(model, MOI.SimplexIterations()),
    )
end
