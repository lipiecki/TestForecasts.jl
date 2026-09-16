
"""
    giacominiwhite(obs::AbstractVecOrMat{<:Real}, benchmark::AbstractArray{<:Real}, forecast::AbstractArray{<:Real}; loss::Function)
Perform the conditial predictive ability test of Giacomini and White, based on the loss differentials computed with `loss`. Tests whether `forecasts` are significantly more accurate than `benchmark`.
"""
function giacominiwhite(obs::AbstractVecOrMat{<:Real},
            benchmark::AbstractVecOrMat{<:Real}, 
            forecast::AbstractVecOrMat{<:Real};
            loss::Function=(y, x)->squared(y, x))
    n = size(obs, 1)
    @assert n == size(benchmark, 1)
    @assert n == size(forecast, 1)

    diff = zeros(n)
    for i in eachindex(diff)
        diff[i] = loss(@view(obs[i, :]), @view(benchmark[i, :])) - loss(@view(obs[i, :]), @view(forecast[i, :])) 
    end
    lag = 1
    
    regressors = zeros(n-lag, 2)
    regressors[:, 1] .= @view(diff[1+lag:end])
    regressors[:, 2] .= @view(diff[1:end-lag]) .* @view(regressors[:, 1])
    
    response = ones(n-lag)
    
    betas = regressors \ response
    sse = sum(abs2, response .- regressors * betas)

    teststat = n - lag - sse
    teststat *= sign(sum(@view(diff[lag:end])))

    return 1 - cdf(Chisq(1), teststat)
end

function giacominiwhite(obs::AbstractVecOrMat{<:Real},
            benchmark::AbstractArray{<:Real}, 
            forecast::AbstractArray{<:Real};
            loss::Function=(y, x)->crps(y, x, size(forecast, 3)))
    n = size(obs, 1)
    @assert n == size(benchmark, 1)
    @assert n == size(forecast, 1)

    diff = zeros(n)
    for i in eachindex(diff)
        diff[i] = loss(@view(obs[i, :]), @view(benchmark[i, :, :])) - loss(@view(obs[i, :]), @view(forecast[i, :, :])) 
    end
    lag = 1
    
    regressors = zeros(n-lag, 2)
    regressors[:, 1] .= @view(diff[1+lag:end])
    regressors[:, 2] .= @view(diff[1:end-lag]) .* @view(regressors[:, 1])
    
    response = ones(n-lag)
    
    betas = regressors \ response
    sse = sum(abs2, response .- regressors * betas)

    teststat = n - lag - sse
    teststat *= sign(sum(@view(diff[lag:end])))

    return 1 - cdf(Chisq(1), teststat)
end
