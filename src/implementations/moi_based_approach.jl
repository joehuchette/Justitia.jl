# Contract for optimizer_factory:
# (instance::AbstractInstance, config::Dict{String,Any}) --> MOI.AbstractOptimzer
struct MOIBasedApproach{T<:MOI.AbstractOptimizer} <: AbstractApproach
    optimizer_factory::Any
end

function build_model(
    approach::MOIBasedApproach{T},
    inst::AbstractMOIBackedInstance,
    config::Dict{String,Any},
) where {T<:MOI.AbstractOptimizer}
    factory = () -> approach.optimizer_factory(inst, config)
    model = MOI.instantiate(factory)
    MOI.copy_to(model, get_moi_model(inst), copy_names = false)
    return MOIModel(model)
end
