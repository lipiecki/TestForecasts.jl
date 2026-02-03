"""
    dieboldmariano(obs::AbstractVecOrMat{<:Real}, benchmark::AbstractVecOrMat{<:Real}, forecast::AbstractVecOrMat{<:Real}; loss::Function)
"""
function dieboldmariano(obs::AbstractVecOrMat{<:Real},
            benchmark::AbstractVecOrMat{<:Real}, 
            forecast::AbstractVecOrMat{<:Real};
            loss::Function=(y, ŷ)->pnorm(y, ŷ, 2))
    n = size(obs, 1)
    @assert n == size(benchmark, 1)
    @assert n == size(forecast, 1)
    diff = zeros(n)  
    for i in eachindex(diff)
        diff[i] = loss(@view(obs[i, :]), @view(benchmark[i, :])) - loss(@view(obs[i, :]), @view(forecast[i, :])) 
    end
    μ = sum(diff)/n
    diff .= diff .- μ
    σ = sqrt(sum(abs2, diff)/(n-1))
    return 1 - cdf(Normal(0, 1), sqrt(n)*μ/σ)
end
