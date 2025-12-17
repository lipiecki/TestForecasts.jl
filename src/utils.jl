function pnorm(x::AbstractVector{<:Real}, p::AbstractFloat=2)
    return sum(abs.(x).^p)^(1/p)
end
