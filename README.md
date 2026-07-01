# Materials for JuliaAstro Workshops

[![Rendered Pluto.jl notebooks](https://img.shields.io/badge/Rendered_Pluto.jl_notebooks-blue)](https://juliaastro.org/workshop/notebooks)

_Most recently used for the [247th Meeting of the AAS](https://aas.org/meetings/aas247/workshops) in Phoenix, AZ, USA_

SSID: AAS 247 Winter \
Password: AAS247Winter

This code base is using the [Julia Language](https://julialang.org/) and
[DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/)
to make a reproducible scientific project named AAS247Julia.

To (locally) reproduce this project, do the following:

1. Download this code base. Notice that raw data are typically not included in the
   git-history and may need to be downloaded independently.
1. Open a Julia console and do:

   ```julia-repl
   julia> using Pkg
   julia> Pkg.add("DrWatson") # install globally, for using `quickactivate`
   julia> Pkg.activate("path/to/this/project")
   julia> Pkg.instantiate()
   ```

   Alternatively, you can navigate to the root of your local copy of this repository,
   open a terminal, and run:

   ```sh
   julia -e 'import Pkg; Pkg.add("DrWatson")'
   julia --project -e 'import Pkg; Pkg.instantiate()'
   ```

This will install all necessary packages for you to be able to run the scripts and
everything should work out of the box, including correctly finding local paths.

You may notice that most scripts start with the commands:

```julia
using DrWatson
@quickactivate "AAS247Julia"
```

which auto-activate the project and enable local path handling from DrWatson.
