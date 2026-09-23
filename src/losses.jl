const AbstractZeroDimOrVec{T} = Union{AbstractArray{T,0}, AbstractVector{T}}

function pnorm(y::AbstractArray{<:Real,0}, x::AbstractArray{<:Real,0}, ::AbstractFloat=2.0)
    return abs(y[begin] - x[begin])
end

function pnorm(y::AbstractVector{<:Real}, x::AbstractVector{<:Real}, p::AbstractFloat=2.0)
    return norm(y .- x, p)
end

function squared(y::AbstractArray{<:Real,0}, x::AbstractArray{<:Real,0})
    return abs2(y[begin] - x[begin])
end

function squared(y::AbstractVector{<:Real}, x::AbstractVector{<:Real})
    return sum(abs2, y .- x) / length(y)
end

function absolute(y::AbstractArray{<:Real,0}, x::AbstractArray{<:Real,0})
    return abs(y[begin] - x[begin])
end

function absolute(y::AbstractVector{<:Real}, x::AbstractVector{<:Real})
    return sum(abs, y .- x) / length(y)
end

function pinball(y::AbstractArray{<:Real, 0}, x::AbstractArray{<:Real, 0}, level::AbstractFloat)
    loss = 0.0
    diff = y[begin] - x[begin]
    loss += (level - (diff < 0 ? 1.0 : 0.0)) * diff
    return loss / length(y)
end

function pinball(y::AbstractVector{<:Real}, x::AbstractVector{<:Real}, level::AbstractFloat)
    loss = 0.0
    for i in eachindex(y)
        diff = y[i] - x[i]
        loss += (level - (diff < 0 ? 1.0 : 0.0)) * diff
    end
    return loss / length(y)
end

function crps(y::AbstractArray{<:Real, 0}, x::AbstractVector{<:Real}, nlevels::Int=99)
    @assert length(x) = nlevels
    loss = 0.0
    for j in 1:nlevels
        tau = j/(nlevels+1)
        diff = y[begin] - x[i, j]
        loss += (tau - (diff < 0 ? 1.0 : 0.0)) * diff
    end
    return 2 * loss / nlevels
end

function crps(y::AbstractVector{<:Real}, x::AbstractMatrix{<:Real}, nlevels::Int=99)
    @assert size(x, 2) == nlevels
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

function aps(y::AbstractArray{<:Real, 0}, x::AbstractVector{<:Real}, levels::AbstractVector{<:Real})
    @assert length(x) = length(levels)
    loss = 0.0
    for j in eachindex(levels)
        diff = y[begin] - x[j]
        loss += (levels[j] - (diff < 0 ? 1.0 : 0.0)) * diff
    end
    return loss / length(levels)
end

function aps(y::AbstractVector{<:Real}, x::AbstractMatrix{<:Real}, levels::AbstractVector{<:Real})
    @assert size(x, 2) == length(levels)
    loss = 0.0
    for i in eachindex(y)
        for j in eachindex(levels)
            diff = y[i] - x[i, j]
            loss += (levels[j] - (diff < 0 ? 1.0 : 0.0)) * diff
        end
    end
    return loss / length(y) / length(levels)
end
