"""
    kupiec(obs::AbstractVecOrMat{<:Real}, forecast::AbstractVecOrMat{<:Real}, level::AbstractFloat)
"""
function kupiec(obs::AbstractVecOrMat{<:Real}, forecast::AbstractVecOrMat{<:Real}, level::AbstractFloat)
    @assert size(obs) == size(forecast)
    @assert size(obs) == size(forecast)
    @assert level > 0 && level < 1
    n = length(obs)
    nhits = sum(obs .< forecast)
    test_statistic = (n-nhits)*log(1-nhits/n) + nhits*log(nhits/n) - (n-nhits)*log(1-level) - nhits*log(level)
    test_statistic *= 2
    return 1-cdf(Chisq(1), test_statistic)
end
