function pnorm(observations::AbstractVector{<:Real}, forecasts::AbstractVector{<:Real}, p::AbstractFloat=2)
    return norm(observations .- forecasts, p)
end

function squared(observations::AbstractVector{<:Real}, forecasts::AbstractVector{<:Real})
    return sum(abs2, observations .- forecasts) / length(observations)
end

function absolute(observations::AbstractVector{<:Real}, forecasts::AbstractVector{<:Real})
    return sum(abs, observations .- forecasts) / length(observations)
end

function pinball(observations::AbstractVector{<:Real}, forecasts::AbstractVector{<:Real}, τ::AbstractFloat)
    loss = 0.0
    for i in eachindex(observations)
        diff = observations[i] - forecasts[i]
        loss += (τ - (diff < 0 ? 1.0 : 0.0)) * diff
    end
    return loss / length(observations)
end
