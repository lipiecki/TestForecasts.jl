# TestForecasts.jl

**Package is under construction and currently offers limited functionality**

**TestForecasts.jl** implements statistical tests for rigorous evaluation of both point and probabilistic forecasts

## Installation
Install the package with:
```julia
using Pkg
Pkg.add(url="https://github.com/lipiecki/TestForecasts.jl")
```
and load it into the namespace:
```julia
using TestForecasts
```

## Features
### Tests on loss differentials
- `dieboldmariano(obs, benchmark, forecast; loss=squared)` see [Diebold & Mariano (1995)](https://doi.org/10.1080/07350015.1995.10524599)
- `giacominiwhite(obs, benchmark, forecast; loss=squared)` see [Giacomini and White (2006)](https://doi.org/10.1111/j.1468-0262.2006.00718.x)

#### Arguments
For both tests, `obs` has to be either an $N \times M$ matrix or an $N$-element vector, where $N$ is the sample size and $M$ is the number of variables. The first dimension(s) of `benchmark` and `forecast` must match the dimension(s) of `obs`. The latter dimensions can be arbitrary, but have to be compatible with the provided `loss` function. For example, if `loss(y, x)=crps(y, x, 99)`, then `benchmark` and `forecast` must be $N \times M \times 99$ arrays.

The keword argument `loss` must be a function that transform the slice of `obs` and `forecasts` along the first dimension (`y = obs[i, :]` and `x = forecasts[i, :]`) into a scalar. Loss functions implemented in the package include:
- `pnorm(y, x, p=2)` the p-norm of the error vector
- `squared(y, x)` mean squared error
- `absolute(y, x)` mean absolute error
- `pinball(y, x, level)` mean pinball (quantile) loss for the specified quantile
- `crps(y, x, nlevels=99)` continuous ranked probability score appromixated as the average pinball loss across equally spaced quantile levels (the average is multiplied by a factor of 2)
- `aps(y, x, levels)` average pinball score across the provided vector of quantile levels

However, any user-defined function can be passed as `loss`.

#### Technical details
`dieboldmariano` uses the sample standard deviation of the loss differences and performs a one-sided test with $H_0$ stating that the loss differential of `benchmark` is higher or equal than that of `forecast`

`giacominiwhite` fixes the instrument lag at one and performs a one-sided test with $H_0$ stating that the loss differential of `benchmark` is higher or equal than that of `forecast`

### Calibration tests
- `kupiec(obs, forecast, level)` see [Kupiec (1995)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=6697)

#### Arguments
Both `obs` and `forecast` have to be either $N \times M$ matrices or $N$-element vectors, where $N$ is the sample size and $M$ is the number of variables. The quantile `level` must be a floating point number between 0 and 1.
