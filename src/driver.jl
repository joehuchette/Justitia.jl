"""
The entrypoint to run a set of experiments.

    function run_experiments!(
        results_table::AbstractResultTable,
        instances::Dict{String},
        approaches::Dict{String},
        result_type::Type{<:AbstractResult},
        config::Dict{String,Any}=Dict(),
    )

This will consider every pair of `AbstractInstance` from `keys(instances)`
with each `AbstractApproach` from `keys(approaches)`, build the corresponding
 `AbstractModel`, solve it, and record the resulting result of type
`result_type` in `record_table`. The keys of the dicts `instances` and
`approaches` are String names used to identify each in `results_table`.
"""
function run_experiments!(
    results_table::AbstractResultTable,
    instances::Dict{String},
    approaches::Dict{String},
    result_type::Type{<:AbstractResult},
    config::Dict{String,Any} = Dict{String,Any}(),
)
    for (instance_name, instance) in instances
        prep_instance!(instance)
        for (approach_name, approach) in approaches
            model = build_model(approach, instance, config)
            optimize!(model)
            result = tear_down(model, result_type)
            record_result!(results_table, result, instance_name, approach_name)
        end
    end
    return nothing
end
