abstract type AbstractApproach end
abstract type AbstractInstance end
abstract type AbstractModel end
abstract type AbstractResult end
abstract type AbstractResultTable end

function prep_instance! end
prep_instance!(::AbstractInstance) = nothing

function build_model end

function optimize! end

function tear_down end

function record_result! end
