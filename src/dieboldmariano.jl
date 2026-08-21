"""
    dieboldmariano(obs::AbstractVecOrMat{<:Real}, benchmark::AbstractArray{<:Real}, forecast::AbstractArray{<:Real}; loss::Function)
"""
function dieboldmariano(obs::AbstractVecOrMat{<:Real},
            benchmark::AbstractVecOrMat{<:Real}, 
            forecast::AbstractVecOrMat{<:Real};
            loss::Function=(y, ŷ)->squared(y, ŷ))
    n = size(obs, 1)
    @assert n == size(benchmark, 1)
    @assert n == size(forecast, 1)
    @assert size(obs, 2) == size(benchmark, 2)
    diff = zeros(n)  
    for i in eachindex(diff)
        diff[i] = loss(@view(obs[i, :]), @view(benchmark[i, :])) - loss(@view(obs[i, :]), @view(forecast[i, :])) 
    end
    μ = sum(diff)/n
    diff .= diff .- μ
    σ = sqrt(sum(abs2, diff)/(n-1))
    return 1 - cdf(Normal(0, 1), sqrt(n)*μ/σ)
end

function dieboldmariano(obs::AbstractVecOrMat{<:Real},
            benchmark::AbstractArray{<:Real}, 
            forecast::AbstractArray{<:Real};
            loss::Function=(y, ŷ)->crps(y, ŷ, size(forecast, 3)))
    n = size(obs, 1)
    @assert n == size(benchmark, 1)
    @assert n == size(forecast, 1)
    @assert size(obs, 2) == size(benchmark, 2)
    diff = zeros(n)  
    for i in eachindex(diff)
        diff[i] = loss(@view(obs[i, :]), @view(benchmark[i, :, :])) - loss(@view(obs[i, :]), @view(forecast[i, :, :])) 
    end
    μ = sum(diff)/n
    diff .= diff .- μ
    σ = sqrt(sum(abs2, diff)/(n-1))
    return 1 - cdf(Normal(0, 1), sqrt(n)*μ/σ)
end
