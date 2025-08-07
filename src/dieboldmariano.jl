function pnorm(x, p=2)
    return sum(abs.(x).^p).^(1/p)
end

function dieboldmariano(obs::AbstractMatrix{<:AbstractFloat},
            baseforecast::AbstractMatrix{<:AbstractFloat}, 
            forecast::AbstractMatrix{<:AbstractFloat};
            lossfun::Function = (y, ŷ) -> pnorm(y-ŷ, 2))
    
    Δ = [lossfun(obs[i], @view(baseforecast[i, :])) for i in axis(baseforecast, 1)]
    for i in axis(forecast, 1)
        Δ[i] -= lossfun(obs[i], @view(forecast[i, :])) 
    end
    μ = mean(Δ)
    σ = std(Δ)
    return cdf(Normal(0, 1), sqrt(length(Δ))*μ/σ)
end