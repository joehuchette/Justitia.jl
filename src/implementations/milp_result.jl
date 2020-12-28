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
    return CSVRecord(filename, [string(field) for field in _MILP_CSV_RESULT_FIELDS])
end

function record_result!(table::CSVRecord, result::MILPResult)
    println(table.fp, join([getfield(result, field) for field in _MILP_CSV_RESULT_FIELDS], ","))
    flush(table.fp)
end
