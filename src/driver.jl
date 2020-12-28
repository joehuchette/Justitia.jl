function run_experiment!(record_table::AbstractResultTable, instances::Vector, approaches::Vector, config::Dict{String,Any}=Dict())
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
