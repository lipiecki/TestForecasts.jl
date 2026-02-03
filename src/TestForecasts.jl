module TestForecasts

using Distributions, LinearAlgebra

include("losses.jl")

include("dieboldmariano.jl")
include("giacominiwhite.jl")
include("kupiec.jl")

export
    pnorm,
    squared,
    absolute,
    pinball,
    
    dieboldmariano,
    giacominiwhite,
    kupiec
end
