module TestForecasts

using Distributions, LinearAlgebra, Random

include("helpers.jl")
include("losses.jl")
include("dieboldmariano.jl")
include("giacominiwhite.jl")
include("kupiec.jl")
include("mcs.jl")

export
    # helpers
    bootstrap,

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
    kupiec,
    mcs
end
