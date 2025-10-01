function pnorm(x, p=2)
    return sum(abs.(x).^p)^(1/p)
end

function dieboldmariano(obs::AbstractMatrix{<:AbstractFloat},
            baseforecast::AbstractMatrix{<:AbstractFloat}, 
            forecast::AbstractMatrix{<:AbstractFloat};
            lossfun::Function = (y, ŷ) -> pnorm(y-ŷ, 2))
    
    Δ = [lossfun(@view(obs[:, i]), @view(baseforecast[:, i])) for i in 1:size(obs, 2)]
    for i in 1:size(obs, 2)
        Δ[i] -= lossfun(@view(obs[:, i]), @view(forecast[:, i])) 
    end
    μ = mean(Δ)
    σ = std(Δ)
    return 1-cdf(Normal(0, 1), sqrt(length(Δ))*μ/σ)
end
