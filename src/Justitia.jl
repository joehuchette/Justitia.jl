module Justitia

import GZip
import MathOptInterface
const MOI = MathOptInterface

include("interface.jl")

include("implementations/csv_record.jl")
include("implementations/milp_result.jl")
include("implementations/moi_model.jl")
include("implementations/moi_backed_instance.jl")
include("implementations/moi_based_approach.jl")
include("implementations/miplib_instance.jl")

include("driver.jl")

end  # module
