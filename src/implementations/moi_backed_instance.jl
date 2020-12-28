abstract type AbstractMOIBackedInstance <: AbstractInstance end

function get_moi_model end

struct SimpleMOIBackedInstance{T <: MOI.ModelLike} <: AbstractInstance
    model::T
end

get_moi_model(inst::SimpleMOIBackedInstance) = inst.model
