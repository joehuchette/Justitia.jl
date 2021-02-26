"""
Subtypes are different approaches for solving an optimization problem. We use
"approach" to mean a configured algorithm: that is, the algorithm (e.g.
simplex), along with fixed values for all the algorithm hyperparemeters.
"""
abstract type AbstractApproach end

"""
Subtypes contain all the information for an individual instance of an
optimization problem. They either contain all of the requisite data themselves,
or a mechanism to somehow retreive it from, e.g., a website.
"""
abstract type AbstractInstance end

"""
Subtypes encapsulate an single approach applied to a single instance. Callers
can ask to optimize a model and then query the results, but the workings of the
approach are otherwise treated as a black box.
"""
abstract type AbstractModel end

"""
Subtypes contain all the useful information needed for understanding how a
particular approach performed on a particular instance. Typical fields stored
may include solve time, or node count for a MIP-based approach.
"""
abstract type AbstractResult end

"""
Subtypes store the results for experiments across multiple approaches and
multiple instances. Backends could be as simple as a CSV file, or something
more complex like HDF5.
"""
abstract type AbstractResultTable end

"""
    prep_instance!(instance::AbstractInstance)::Nothing

Prepare an instance for experimentation. This is useful if there is a
lightweight way to represent an instance (e.g. a string name in an instance
library), but collecting the data is relatively costly (e.g. download something
from the web and converting it to the right file format). Additionally, this
prep work can do more complex pre-processing: if you are evaluating methods for
dual bounds, this function could run a set of heuristics to produce a good
primal solution. This method is only called once per instance, meaning that the
resulting computations can be shared across all approaches run on the
particular instance.

!!! note
    Implementing this method is optional. If you don't need to do any prep work
    as all the requisite data is already available, simply defer to the
    available fallback method.
"""
function prep_instance! end
prep_instance!(::AbstractInstance) = nothing

"""
    build_model(
        approach::AbstractApproach,
        instance::AbstractInstance,
        config::Dict{String,Any}=Dict{String,Any}()
    )::AbstractModel

Given a particular `approach` and a particular `instance`, build a model that
encapsulates the two. The optional `config` argument contains parameters that
are shared across all approaches and instances in a experiment run: for
example, a time limit, a node limit, a constraint violation tolerance, etc.
"""
function build_model end

"""
    optimize!(model::AbstractModel)

Solve the instance using the approach specified by `model`.
"""
function optimize! end

"""
    tear_down(model::AbstractModel, instance::AbstractInstance, T::Type{<:AbstractResult}))

Record the results of in individual experiment of a particular approach on a
particular instance. The results will be stored in an object of type `T`.

!!! note
    This function should only be called after `optimize!(model)` has been
    called.
"""
function tear_down end

"""
    record_result!(table::AbstractResultTable, result::AbstractResult)

Given the results from an individual experiment, record it in `table`.
"""
function record_result! end
