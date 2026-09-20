"""
    mcs(obs::AbstractVecOrMat{<:Real}, forecasts::Vector{<:AbstractVecOrMat{<:Real}}; loss::Function)
Perform the Model Confidence Set test, based on the loss differentials computed with `loss`.
"""
function mcs(obs::AbstractVecOrMat{<:Real},
            forecasts::Vector{<:AbstractVecOrMat{<:Real}};
            loss::Function=(y, x)->squared(y, x))
    n, m = size(obs)
	for forecast in forecasts
    	@assert n, m .== size(forecast)
	end
    
	# diff[i] = loss(@view(obs[i, :]), @view(benchmark[i, :])) - loss(@view(obs[i, :]), @view(forecast[i, :])) 
    
end
