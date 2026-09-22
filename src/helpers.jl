"""
    bootstrap(samplesize::Integer, b::Integer, blocksize::Integer=1)
Generate indices for `b` bootstrap resamples of a sample containing `n` observations.

Set `blocksize > 1` to use a moving-block bootstrap.

Return an `n × b` matrix of indices, where each column represents one bootstrap resample.
"""
function bootstrap(n::Integer, b::Integer, blocksize::Integer=1)::Matrix{Int}
    @assert n > 0 && b > 0 && blocksize > 0
    bootstrapinds = Matrix{Int}(undef, n, b)
	if blocksize == 1
	   @views foreach(i->rand!(bootstrapinds[:, i], 1:n), 1:b)
	else
	    blockinds = Vector(undef, cld(n, blocksize))
		for i in 1:b
		    newinds = @view bootstrapinds[:, i]
		    rand!(blockinds, 1:(n-blocksize+1))
			for j in eachindex(blockinds)
			    start = (j-1)*blocksize + 1
			    len = min(blocksize, n-start+1)
			    newinds[start : (start+len-1)] .= blockinds[j] : (blockinds[j]+len-1)
			end
		end
	end
	return bootstrapinds
end
