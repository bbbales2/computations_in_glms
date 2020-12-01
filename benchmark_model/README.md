The models here are built from the models in this case study: https://bookdown.org/jl5522/MRP-case-studies/introduction-to-mrp.html (https://github.com/JuanLopezMartin/MRPCaseStudy)

There are three data sets. One is has 500 responses (files start with `mrp_500`), one has 5000 responses (files start with `mrp_5k`), and one has 59810 responses (files start with `mrp_all`).

`mrp_ref.stan` is a benchmark model generated using brms and has been manually modified to incorporate the rstanarm default priors. All the data files ending in `_ref.json` should be used by it.

`mrp.stan` is a benchmark model adapted directly from the brms code that should be easier to read. It uses the data files that do not end in `_ref.json`.

The parameters have different names between the two models, but they are defined in the same order, so to check if `mrp.stan` is working relative to the reference just run the two and look at the summary in the default order.

Or really if you trust `mrp.stan`, then you could reference an older version of that directly.

`mrp.stan` takes three arguments via data that the reference doesn't, `prior_scale_sd`, `prior_scale_b`, and `prior_scale_Intercept`. These are scale parameters for the priors on the standard deviation parameters, the coefficients of the population level parameters, and the population level intercept.

`mrp_varmat.stan` is a model written to take advantage of the new varmat types in Stan Math. It uses the data files not ending in `_ref.json`.

This model will eventually go into [posteriordb](https://github.com/MansMeg/posteriordb)