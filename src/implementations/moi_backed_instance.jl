"""
Instance that is internally stored as an `MathOptInterface` model.

    abstract type AbstractMOIBackedInstance <: AbstractInstance end

To interact with the underlying `MathOptInterface` model, use:

    get_moi_model(model::AbstractMOIBackedInstance)::MOI.ModelLike
"""
abstract type AbstractMOIBackedInstance <: AbstractInstance end

function get_moi_model end

"""
A "simple" `AbstractMOIBackedInstance` where the underlying `MathOptInterface`
model is stored in a field.

    struct SimpleMOIBackedInstance{T <: MOI.ModelLike} <: AbstractInstance
        model::T
    end
"""
struct SimpleMOIBackedInstance{T<:MOI.ModelLike} <: AbstractInstance
    model::T
end

get_moi_model(inst::SimpleMOIBackedInstance) = inst.model
