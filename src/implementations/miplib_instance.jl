mutable struct MIPLIBInstance <: AbstractMOIBackedInstance
    instance_name::String
    tmp_file::String
    model::MOI.FileFormats.MPS.Model

    function MIPLIBInstance(name::String)
        return new(name, tempname())
    end
end

function get_moi_model(inst::MIPLIBInstance)
    @assert isdefined(inst, :model)
    return inst.model
end

const MIPLIB_URL_PREFIX = "http://miplib.zib.de/WebData/instances/"

function prep_instance!(inst::MIPLIBInstance)
    @show miplib_url = string(MIPLIB_URL_PREFIX, inst.instance_name, ".mps.gz")
    run(`curl $(miplib_url) -o $(inst.tmp_file)`)
    io = GZip.open(inst.tmp_file)
    model_mps = MOI.FileFormats.MPS.Model()
    read!(io, model_mps)
    inst.model = model_mps
    return nothing
end
