"""
    mcs(obs::AbstractVecOrMat{<:Real}, forecasts::Vector{<:AbstractVecOrMat{<:Real}}; loss=(y, x)->squared(y, x), alpha=0.01, bootstraps=1_000, blocksize=1)
Perform the Model Confidence Set test, based on the provided `loss` function. Return the indices of models that cannot be rejected as equally predictive at significance level `alpha`.

## Arguments
- `obs`: observations as an `n`-element vector or `n × m` matrix, where `n` is the sample size
- `forecasts`: forecasts as an array with first dimension(s) equal to the dimension(s) of `obs` and the last dimension indexing the models
## Keyword arguments
- `loss`: function returning the loss for one observation and forecast (defaults to squared error)
- `alpha`: significance level used in the sequential tests (defaults to `0.01`)
- `bootstraps`: number of bootstrap samples (defaults to `1_000`)
- `blocksize`: bootstrap block length (defaults to `1`)
"""
function mcs(obs::AbstractVecOrMat{<:Real},
            forecasts::AbstractArray{<:Real};
            loss::Function=(y, x)->squared(y, x),
            alpha::AbstractFloat=0.01,
            bootstraps::Integer=1_000,
            blocksize::Integer=1)

    n = size(obs, 1)
    nmodels = last(size(forecasts))
    @assert n == size(forecasts, 1)
    @assert nmodels > 1
    @assert alpha > 0.0 && alpha < 1.0

	bootstrapinds = bootstrap(n, bootstraps, blocksize)
	outerslice = ntuple(_ -> Colon(), ndims(obs)-1)

	sample_loss = zeros(nmodels)                # raw loss
	bootstrap_loss = zeros(bootstraps, nmodels) # loss relative to sample

	# loss computation
	for m in 1:nmodels
	    fview = selectdim(forecasts, ndims(forecasts), m)
	    for i in 1:n
	        @views sample_loss[m] += loss((obs[i, outerslice...]), fview[i, outerslice...])/n
        end
        for b in 1:bootstraps
            inds = @view bootstrapinds[:, b]
            for i in 1:n
                @views bootstrap_loss[b, m] += loss((obs[inds[i], outerslice...]), fview[inds[i], outerslice...])/n
            end
            bootstrap_loss[b, m] -= sample_loss[m]
        end
	end

	# sequential testing
    observed_tstat = Vector{Float64}(undef, nmodels)
    bootstrap_tstat = Matrix{Float64}(undef, bootstraps, nmodels)
    modelsetmask = trues(nmodels)
    while sum(modelsetmask) > 1
        observed_tstat .= sample_loss .- mean(sample_loss[modelsetmask])
        bootstrap_tstat .= bootstrap_loss .- mean(bootstrap_loss[:, modelsetmask], dims=2)

        se = mean(bootstrap_tstat .|> abs2, dims=1) .|> sqrt |> vec
        observed_tstat ./= se
        bootstrap_tstat ./= se'

        observed_tstat[.!modelsetmask] .= -Inf
        bootstrap_tstat[:, .!modelsetmask] .= -Inf

    	tmax, imax = findmax(observed_tstat)
    	pval = mean(maximum(bootstrap_tstat, dims=2) .> tmax)
        if pval < alpha
            modelsetmask[imax] = false
        else
            break
        end
    end

    return [i for i in 1:nmodels if modelsetmask[i]]
end
