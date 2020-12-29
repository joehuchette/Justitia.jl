"""
An approach that, given an instance, will merely convert that instance into a
`MathOptInterface.ModelLike`. For instance, this could encapsulate a
`AbstractOptimizer`, which ingests an instance and passes that instance to the
underlying solver through the `MathOptInterface` API.

    MOIBasedApproach{T}() where {T <: MOI.AbstractOptimizer}
    MOIBasedApproach{T}(factory::Function) where {T <: MOI.AbstractOptimizer}

The underlying `MathOptInterface` will either be inferred from `T`, or you can
optionally pass a `factory` function to the constructor. This `factory` must
respect the signature

    (instance::AbstractInstance, config::Dict{String,Any}) --> MathOptInterface.AbstractOptimizer.

Some pieces of the [functional interface](@ref functional_interface) are
implemented:

    function build_model(
        approach::MOIBasedApproach{T},
        inst::AbstractMOIBackedInstance,
        config::Dict{String,Any} = Dict{String,Any}(),
    ) where {T <: MathOptInterface.AbstractOptimizer}
"""
struct MOIBasedApproach{T <: MOI.AbstractOptimizer} <: AbstractApproach
    optimizer_factory::Union{Nothing,Function}
end
MOIBasedApproach{T}() where {T <: MOI.AbstractOptimizer} = MOIBasedApproach{T}(nothing)

_get_factory(::Nothing, ::Type{T}) where {T <: MOI.AbstractOptimizer} = T
_get_factory(f::Function, ::Type{T}) where {T <: MOI.AbstractOptimizer} = f

function get_factory(approach::MOIBasedApproach{T}) where {T <: MOI.AbstractOptimizer}
    return _get_factory(approach.optimizer_factory, T)
end

function build_model(
    approach::MOIBasedApproach{T},
    inst::AbstractMOIBackedInstance,
    config::Dict{String,Any}=Dict{String,Any}(),
) where {T <: MOI.AbstractOptimizer}
    factory = get_factory(approach)
    # factory = () -> approach.optimizer_factory(inst, config)
    model = MOI.instantiate(factory)
    @assert model isa T
    MOI.copy_to(model, get_moi_model(inst), copy_names=false)
    return MOIModel(model)
end
