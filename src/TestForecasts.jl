module TestForecasts

using Distributions
include("utils.jl")
include("dieboldmariano.jl") 
include("kupiec.jl")

export
    dieboldmariano,
    kupiec,
    pnorm
end
