module TestForecasts

using Distributions, LinearAlgebra, Statistics
include("losses.jl")
include("dieboldmariano.jl") 
include("kupiec.jl")

export
    dieboldmariano,
    kupiec,
    pnorm
end
