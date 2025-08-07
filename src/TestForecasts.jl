module TestForecasts

using Distributions
using Statistics
include("dieboldmariano.jl") 

export
    dieboldmariano,
    pnorm
end
