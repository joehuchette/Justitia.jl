"""
A [MIPLIB 2017](http://miplib.zib.de/index.html) instance stored in a
`MathOptInterface` backing model.

    MIPLIBInstance(instance_name::String)

Pulls down the MIPLIB instance named `instance_name` from the official
MIPLIB website using `curl`.

Some pieces of the [functional interface](@ref functional_interface) are
implemented:

    prep_instance!(instance::MIPLIBInstance)

!!! note
    You must call `prep_instance!` on a `MIPLIBInstance` to populate the
    internal MathOptInterface model backing it.
"""
mutable struct MIPLIBInstance <: AbstractMOIBackedInstance
    instance_name::String
    tmp_file::String
    model::MOI.FileFormats.MPS.Model

    function MIPLIBInstance(instance_name::String)
        return new(instance_name, tempname())
    end
end

function get_moi_model(inst::MIPLIBInstance)
    @assert isdefined(inst, :model)
    return inst.model
end

const MIPLIB_URL_PREFIX = "http://miplib.zib.de/WebData/instances/"

function prep_instance!(instance::MIPLIBInstance)
    miplib_url = string(MIPLIB_URL_PREFIX, instance.instance_name, ".mps.gz")
    run(`curl $(miplib_url) -o $(inst.tmp_file)`)
    io = GZip.open(inst.tmp_file)
    model_mps = MOI.FileFormats.MPS.Model()
    read!(io, model_mps)
    instance.model = model_mps
    return nothing
end
