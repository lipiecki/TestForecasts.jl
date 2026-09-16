
function pnorm(y::AbstractVector{<:Real}, x::AbstractVector{<:Real}, p::AbstractFloat=2)
    return norm(y .- x, p)
end

function squared(y::AbstractVector{<:Real}, x::AbstractVector{<:Real})
    return sum(abs2, y .- x) / length(y)
end

function absolute(y::AbstractVector{<:Real}, x::AbstractVector{<:Real})
    return sum(abs, y .- x) / length(y)
end

function pinball(y::AbstractVector{<:Real}, x::AbstractVector{<:Real}, level::AbstractFloat)
    loss = 0.0
    for i in eachindex(y)
        diff = y[i] - x[i]
        loss += (level - (diff < 0 ? 1.0 : 0.0)) * diff
    end
    return loss / length(y)
end

function crps(y::AbstractVector{<:Real}, x::AbstractMatrix{<:Real}, nlevels::Int=99)
    loss = 0.0
    for i in eachindex(y)
        for j in 1:nlevels
            tau = j/(nlevels+1)
            diff = y[i] - x[i, j]
            loss += (tau - (diff < 0 ? 1.0 : 0.0)) * diff
        end
    end
    return 2 * loss / length(y) / nlevels
end

function aps(y::AbstractVector{<:Real}, x::AbstractMatrix{<:Real}, levels::AbstractVector{<:Real})
    loss = 0.0
    for i in eachindex(y)
        for j in 1:length(levels)
            tau = levels[j]
            diff = y[i] - x[i, j]
            loss += (tau - (diff < 0 ? 1.0 : 0.0)) * diff
        end
    end
    return loss / length(y) / length(levels)
end
