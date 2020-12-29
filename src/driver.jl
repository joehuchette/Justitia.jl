"""
The entrypoint to run a set of experiments.

    function run_experiments!(
        record_table::AbstractResultTable,
        instances::Vector,
        approaches::Vector,
        config::Dict{String,Any}=Dict(),
    )

This will consider every pair of `AbstractInstance` from `instances` with
`AbstractApproach` from `approaches`, build the corresponding `AbstractModel`,
solve it, and record the resulting `AbstractResult` in `record_table`.
"""
function run_experiments!(
    record_table::AbstractResultTable,
    instances::Vector,
    approaches::Vector,
    config::Dict{String,Any} = Dict(),
)
    for instance in instances
        prep_instance!(instance)
        for approach in approaches
            model = build_model(approach, instance, config)
            optimize!(model)
            result = tear_down(approach, model)
            record_result!(results_table, result)
        end
    end
    return nothing
end
