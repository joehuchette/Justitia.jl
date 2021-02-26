"""
The entrypoint to run a set of experiments.

    function run_experiments!(
        results_table::AbstractResultTable,
        instances::Dict{String},
        approaches::Dict{String},
        result_type::Type{<:AbstractResult};
        config::Dict{String,Any}=Dict();
        parallelize::Bool = true,
    )

This will consider every pair of `AbstractInstance` from `keys(instances)`
with each `AbstractApproach` from `keys(approaches)`, build the corresponding
 `AbstractModel`, solve it, and record the resulting result of type
`result_type` in `record_table`. The keys of the dicts `instances` and
`approaches` are String names used to identify each in `results_table`. If
`parallize=true`, the experiments will be parallelized across the available
threads, as determined by the `threads` flag used to launch Julia.
"""
function run_experiments!(
    results_table::AbstractResultTable,
    instances::Dict{String},
    approaches::Dict{String},
    result_type::Type{<:AbstractResult};
    config::Dict{String} = Dict{String,Any}();
    parallelize::Bool = true,
)
    approach_keys = collect(keys(approaches))
    for (instance_name, instance) in instances
        @info "Prepping instance $instance_name"
        prep_instance!(instance)
        if parallelize
            Threads.@threads for approach_name in approach_keys
                @info "Current experiment: $instance_name with $approach_name"
                approach = approaches[approach_name]
                model = build_model(approach, instance, config)
                optimize!(model)
                result = tear_down(model, instance, result_type)
                record_result!(results_table, result, instance_name, approach_name)
            end
        else
            @info "Current experiment: $instance_name with $approach_name"
            approach = approaches[approach_name]
            model = build_model(approach, instance, config)
            optimize!(model)
            result = tear_down(model, instance, result_type)
            record_result!(results_table, result, instance_name, approach_name)
        end
    end
    return nothing
end
