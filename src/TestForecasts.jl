module TestForecasts

using Distributions, LinearAlgebra

include("losses.jl")

include("dieboldmariano.jl")
include("giacominiwhite.jl")
include("kupiec.jl")
#TODO: include("mcs.jl") 

export
    # losses
    pnorm,
    squared,
    absolute,
    pinball,
    crps,
    aps,
    
    # tests
    dieboldmariano,
    giacominiwhite,
    kupiec
    #TODO: mcs
end
