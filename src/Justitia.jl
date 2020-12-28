module Justitia

import MathOptInterface
const MOI = MathOptInterface

include("interface.jl")

include("implementations/csv_record.jl")
include("implementations/milp_result.jl")
include("implementations/moi_model.jl")

include("driver.jl")

include("analysis.jl")

end # module
