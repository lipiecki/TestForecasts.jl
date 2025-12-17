module TestForecasts

using Distributions
include("utils.jl")
include("dieboldmariano.jl") 

export
    dieboldmariano,
    pnorm
end
