"""
A "simple" model that merely wraps around an underlying `MathOptInterface`
model.

    struct MOIModel{T <: MOI.AbstractOptimizer} <: AbstractModel
        opt::T
    end

Some pieces of the [functional interface](@ref functional_interface) are
implemented:

    optimize!(model::MOIModel)
    tear_down(model::MOIModel, instance::AbstractInstance, ::Type{MILPResult})
"""
struct MOIModel{T<:MOI.AbstractOptimizer} <: AbstractModel
    opt::T
end

function optimize!(model::MOIModel)
    MOI.optimize!(model.opt)
    return nothing
end

function tear_down(model::MOIModel, instance::AbstractInstance, ::Type{MILPResult})
    opt = model.opt
    result = MILPResult(
        termination_status = MOI.get(opt, MOI.TerminationStatus()),
        primal_status = MOI.get(opt, MOI.PrimalStatus()),
        solve_time_sec = MOI.get(opt, MOI.SolveTime()),
    )
    if result.primal_status == MOI.FEASIBLE_POINT
        num_vars = MOI.get(opt, MOI.NumberOfVariables())
        result.x = [
            MOI.get(opt, MOI.VariablePrimal(), MOI.VariableIndex(i)) for
            i in 1:num_vars
        ]
    end
    try
        primal_bound = MOI.get(opt, MOI.ObjectiveValue())
        result.primal_bound = primal_bound
    catch ArgumentError
        @warn "Primal bound not available; proceeding anyway."
    end
    try
        dual_bound = MOI.get(opt, MOI.ObjectiveBound())
        result.dual_bound = dual_bound
    catch ArgumentError
        @warn "Dual bound not available; proceeding anyway."
    end
    try
        node_count = MOI.get(opt, MOI.NodeCount())
        result.node_count = node_count
    catch ArgumentError
        @warn "Node count not available; proceeding anyway."
    end
    try
        simplex_iters = MOI.get(opt, MOI.SimplexIterations())
        result.simplex_iters = simplex_iters
    catch ArgumentError
        @warn "Simplex iteration count not available; proceeding anyway."
    end
    return result
end
