"""
A "simple" model that merely wraps around an underlying `MathOptInterface`
model.

    struct MOIModel{T <: MOI.AbstractOptimizer} <: AbstractModel
        opt::T
    end

Some pieces of the [functional interface](@ref functional_interface) are
implemented:

    optimize!(model::MOIModel)
    tear_down(model::MOIModel, ::Type{MILPResult})
"""
struct MOIModel{T<:MOI.AbstractOptimizer} <: AbstractModel
    opt::T
end

function optimize!(model::MOIModel)
    MOI.optimize!(model.opt)
    return nothing
end

function tear_down(model::MOIModel, ::Type{MILPResult})
    opt = model.opt
    primal_status = MOI.get(opt, MOI.PrimalStatus())
    num_vars = MOI.get(opt, MOI.NumberOfVariables())
    feas_point = (
        if primal_status == MOI.FEASIBLE_POINT
            [
                MOI.get(opt, MOI.VariablePrimal(), MOI.VariableIndex(i)) for
                i in 1:num_vars
            ]
        else
            nothing
        end
    )
    result = MILPResult(
        termination_status = MOI.get(opt, MOI.TerminationStatus()),
        primal_status = primal_status,
        x = feas_point,
        primal_bound = MOI.get(opt, MOI.ObjectiveValue()),
        solve_time_sec = MOI.get(opt, MOI.SolveTime()),
    )
    try
        dual_bound = MOI.get(opt, MOI.ObjectiveBound())
        result.dual_bound = dual_bound
    catch ArgumentError
    end
    try
        node_count = MOI.get(opt, MOI.NodeCount())
        result.node_count = node_count
    catch ArgumentError
    end
    try
        simplex_iters = MOI.get(opt, MOI.SimplexIterations())
        result.simplex_iters = simplex_iters
    catch ArgumentError
    end
    return result
end
