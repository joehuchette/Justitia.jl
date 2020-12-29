"""
Records solution information from a mixed-integer linear programming (MILP)
problem.

    MILP(;
        termination_status::MOI.TerminationStatusCode,
        primal_status::MOI.ResultStatusCode,
        x::Union{Nothing,Vector{Float64}} = nothing,
        primal_bound::Float64,
        dual_bound::Float64,
        solve_time_sec::Float64;
        node_count::Int = -1,
        simplex_iters::Int = -1
    )

Records why the solver terminated (`termination_status`), if it had a feasible
primal solution (`primal_status`), what that solution was if available (`x`),
what the best primal cost was (`primal_bound`), the best available dual bound
(`dual_bound`), elapsed solve time in seconds (`solve_time_sec`), and
optionally the number of enumerated nodes (`node_count`) and total simplex
iterations (`simplex_iters`).

Some pieces of the [functional interface](@ref functional_interface) are
implemented:

    record_result(table::CSVRecord, result::MILPResult)

Additionally, there is a helper function for creating a `CSVRecord` with the
correct headers:

    CSVRecord(filename::String, ::Type{MILPResult})
"""
Base.@kwdef struct MILPResult <: AbstractResult
    termination_status::MOI.TerminationStatusCode
    primal_status::MOI.ResultStatusCode
    x::Union{Nothing,Vector{Float64}} = nothing
    primal_bound::Float64
    dual_bound::Float64
    solve_time_sec::Float64
    node_count::Int = -1
    simplex_iters::Int = -1
end

# Drop :x as we don't want to record that in a CSVRecord
const _MILP_CSV_RESULT_FIELDS = [
    :termination_status,
    :primal_status,
    :primal_bound,
    :dual_bound,
    :solve_time_sec,
    :node_count,
    :simplex_iters,
]

function CSVRecord(filename::String, ::Type{MILPResult})
    # Don't write feasible solution to CSV
    return CSVRecord(
        filename,
        [string(field) for field in _MILP_CSV_RESULT_FIELDS],
    )
end

function record_result!(table::CSVRecord, result::MILPResult)
    println(
        table.fp,
        join(
            [getfield(result, field) for field in _MILP_CSV_RESULT_FIELDS],
            ",",
        ),
    )
    return flush(table.fp)
end
