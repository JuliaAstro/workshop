### A Pluto.jl notebook ###
# v0.20.21

#> [frontmatter]
#> title = "01: Intro"
#> description = "Notebook 1 in the AAS 247 JuliaAstro workshop series."

using Markdown
using InteractiveUtils

# ╔═╡ 7c4ebc32-9b8e-4b2a-8f39-f4c351283843
begin
	using Dates, LaTeXStrings, PlutoUI, Term
	TableOfContents(; title = "1-1: Introduction", depth = 4)
end

# ╔═╡ 6001288a-7a9d-4020-bf7d-02a0fa250c04
"""
!!! note "1-1: Introduction"
    **$(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 38ead816-0375-4605-a833-6464485aa0d6
md"""
# Historical Context

Nearly thirty years ago at the Astronomical Data Analysis Software and Systems (ADASS) VI meeting (1996), Harrington and Barrett hosted a Birds-of-a-Feather session entitled [Interactive Data Analysis Environments](https://www.cv.nrao.edu/adass/adassVI/harringtonj.html). Based on their review of [21 interpreted programming languages](https://htmlpreview.github.io/?https://github.com/barrettp/AAS245Julia/blob/main/Interactive%20Data%20Analysis%20Environments.html) such as Glish, GUILE, IDL, IRAF, Matlab, Perl, Python, and Tcl; they recommended that Python be considered the primary language for astronomical data analysis. The primary reasons were that the language was simple to learn, yet powerful; well supported by the programming community; and had FORTRAN-like arrays. However, for good performance, the multi-dimensional arrays needed to be written in a compiled language, namely C. So Numerical or Scientific Python suffers from the **two language problem**: an interpreted language for interactive use and a compiled language for performance.
"""

# ╔═╡ 95cfbabc-5e7c-481b-853c-6d06baa577b6
md"""
## Why Julia?

In 2009, four faculty and staff members[^1] at MIT, who were not satisfied with the state of scientific computing, decided to develop a general purpose, high performance, scientific programming language. After ten years of development, they release Julia Version 1.0 on August 8, 2018. Their aim was to create an open-source interpreted language that was concise, extensible, and high performance.

!!! info "Jeff Bezanson, 2012"
	We are greedy.
	
	We want a language that's open source, with a liberal license. We want the speed of C with the dynamism of Ruby. We want a language that's homoiconic, with true macros like Lisp, but with obvious, familiar mathematical notation like Matlab. We want something as usable for general programming as Python, as easy for statistics as R, as natural for string processing as Perl, as powerful for linear algebra as Matlab, as good at gluing programs together as the shell. Something that is dirt simple to learn yet, keeps the most serious hackers happy. We want it interactive and we want it compiled.

[^1]: [Alan Edelman](https://math.mit.edu/~edelman/), Professor of Applied Mathematics and Computer Science, MIT; [Viral B. Shah](https://en.wikipedia.org/wiki/Viral_B._Shah), Co-Founder, Chief Executive Officer (CEO), JuliaHub; [Jeff Bezanson](https://en.wikipedia.org/wiki/Jeff_Bezanson), Co-Founder, Chief Technology Officer (CTO), JuliaHub; [Stefen Karpinski](https://karpinski.org/), Co-Founder, Chief Product Officer (CPO), JuliaHub
"""

# ╔═╡ 8e597a38-6e41-499f-af06-f9223b8827de
md"""
## What Differentiates Julia From Other Languages?

* Julia is **composable**.
* Julia is **concise**.
* Julia is **highly performant**.
* Julia is **productive**.
* Julia is **easy to maintain**.
* Julia is **free and open-source**.
"""

# ╔═╡ 1cc401a1-6d3a-40e5-a4fc-012caa913369
md"""
## Why Have I migrated to Julia?

Although an early advocate and developer of Numerical Python (now NumPy), Matplotlib, and PyFits (now astropy.io.fits), I knew its limitations, namely, the **two language problem**. Therefore, once a better scientific programming language came along, I was prepared to migrate to that language. I believe that **Julia is that language.** It is the language that I envisioned thirty years ago.
"""

# ╔═╡ b1ed2c4e-f5fa-4e5e-87d8-7af6f80a83ca
md"""
# Getting Started

---
"""

# ╔═╡ 7f3357bc-4103-4a35-af21-9c86f5a0ec2f
md"""
## Starting Julia

Enter `julia` at the terminal prompt. Set the number of threads to `auto`. Threads will be discussed later in Parallel Computing.

```julia-repl
> julia --threads=auto
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.12.3 (2025-12-15)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org release
|__/                   |

julia>
```

!!! tip
    The command line option "`-q`" can be used to remove the start-up banner.

---
"""

# ╔═╡ 7475c896-d1b1-4429-9ba8-8e78de41e0b0
md"""
## Stopping Julia

To exit Julia, enter `<Ctrl-D>`, like Python, or `exit()`

```julia-repl
julia> <Ctrl-D>
```

!!! tip
    Don't do this now!

---
"""

# ╔═╡ 5df8264e-6e37-4674-abdf-2b05c530787f
md"""
## The command line  or  REPL (Read-Eval-Print-Loop)

Our first command:

```julia-repl
julia> println("Hello World")
```
"""

# ╔═╡ 4a404280-2845-4deb-8eee-2dcdcb9aed27


# ╔═╡ 7813824a-cae9-4b97-ac90-e542fbd630d5
md"""
!!! note
    Unlike Jupyter and the REPL, Pluto prints the result above the line, not below.

Our first calculation

```julia-repl
julia> a = 4
```
"""

# ╔═╡ 6ac51e87-87a2-4ccc-9f08-0028700b3cda


# ╔═╡ 27208179-35c3-43c1-9548-3620c8aa7680
md"""```julia-repl
julia> b = 2
```"""

# ╔═╡ 40d8d18c-3713-4e77-812d-9d77a4e1ac50


# ╔═╡ aa3e9db7-49d1-40f8-b745-6c4faa2197e1
md"""```julia-repl
julia> a + b
```"""

# ╔═╡ 8eb9630a-44b2-4ac8-b243-0c2ce5b16f50


# ╔═╡ 419a6dec-1db0-477f-911f-049223b5674f
md"""
# Other REPL Modes

The Julia REPL supports several different modes, outlined below, accessible by a keystroke. Hit the `delete` or `backspace` key to return to the REPL.

---
"""

# ╔═╡ 85f2bec3-0095-4bbc-93ef-48ab97094244
md"""
## Help: `?`

For help mode:

```julia-repl
julia> ?

help?> println
search: println printstyled print sprint isprint

println([io::IO], xs...)

Print (using print) xs to io followed by a newline. If io is not supplied, prints to the default output stream stdout.

See also printstyled to add colors etc

Examples
≡≡≡≡≡≡≡≡≡≡

julia> println("Hello, world")
Hello, world

julia> io = IOBuffer();

julia> println(io, "Hello", ',', " world.")

julia> String(take!(io))
"Hello, world.\n"
```

!!! note
    Pluto has a **Live docs** tab in the lower right corner that will display the current Julia function or command. The **Help**, **Shell**, and **Package Manager** examples require the REPL, i.e., running Julia in a terminal.

---
"""

# ╔═╡ 8ee7f43d-bf75-4975-ac64-54c2d5a0174a
md"""
## Shell: `;`

For shell mode:

```julia-repl
julia> ;

shell> pwd
/Users/myhomedir
```

---
"""

# ╔═╡ d1e9c51c-efb9-4dcb-9d28-8c54a235fbb4
md"""
## Package Manager: `]`

For package mode:

```julia-repl
julia> ]

pkg>
```

For package manager help,

```julia-repl
pkg> ? <return>
```

returns a brief summary of package commands.

To add a package:

```julia-repl
pkg> add <package>

pkg> add <package1>, <package2>
```

When adding a package, the Julia online repository (aka the "registry" or "General Registry") will be searched. The package and its dependencies will then be downloaded, compiled, and installed. This may take anywhere from a few seconds to a few minutes depending on the size of the package and its dependencies.

To use or load a package (after it has been added), return to the REPL:

```julia-repl
julia> using <package>

julia> using <package1>, <package2>
```

!!! note
	A feature of the `using` command is that it will add the package, if it hasn't already been added.
"""

# ╔═╡ b27578b2-f5f5-4e46-82e6-0007be187ba6
md"""
To check the manifest:

```julia-repl
pkg> status
```
or
```julia-repl
pkg> st
```
"""

# ╔═╡ 065265a5-c9ad-4a39-b14d-f4e2e49d3f7a
md"""
To update a package in the manifest:

```julia-repl
pkg> update <package>
```

or

```julia-repl
pkg> up <package>
```

To update all packages in the manifest:

```julia-repl
pkg> up
```

To garbage collect packages not used for a significant time:

```julia-repl
pkg> gc
```
"""

# ╔═╡ 563f07ad-6aed-495e-85fb-bae4a1755ac2
md"""
# Some simple programming examples

---
"""

# ╔═╡ 0f94b21c-364f-488e-aff3-28c4b39a3844
md"""
## Measurements and Unicode

The [Measurements.jl](https://juliaphysics.github.io/Measurements.jl/stable/) package enables variables to have both values and errors. Let's add Measurements using the `using` statement:

```julia-repl
julia> using Measurements
```
"""

# ╔═╡ 40abc83f-b4bd-479f-8671-189cc712d792


# ╔═╡ 297cd86c-5e9d-4f70-b11a-cbae8fa96d1e
md"""
Let's do some calculations.

```julia-repl
julia> m1 = measurement(4.5, 0.1)
```
"""

# ╔═╡ 8f016c75-7768-4418-8c57-100db3073c85


# ╔═╡ 094b6f30-cbd6-46b1-8e0c-3fdb1ef18261
md"""Typing `measurements` is rather awkward. There must be a better way. How about the following?

```julia-repl
julia> m2 = 15 ± 0.3
```

where the plus-minus character is entered using LaTeX syntax followed by tab, i.e., `\pm<tab>`.
"""


# ╔═╡ 7ba8dc19-e0ca-40de-a778-7583ca70978d


# ╔═╡ 668abc35-fdc3-430f-8c90-de3c2c2cd77b
md"""
One of the features of Julia is that it understands unicode. For example, expressions in a printed document that contain greek characters can be entered as greek characters in your code, e.g., `\alpha<tab>`. Let's calculate the following expression:

```julia-repl
julia> α = m1 + m2
```
"""

# ╔═╡ 0e42f7fd-955e-4679-8d90-0cb46c9a12dc


# ╔═╡ d2a2d0bc-e883-439f-8e34-166e2369caef
md"""
!!! note

    Notice that the error of the result `α` has been propogated correctly.

---
"""

# ╔═╡ 750acbf6-bc04-43ea-b123-14753cab597a
md"""
## Units

Let's add another package called [Unitful.jl](https://juliaphysics.github.io/Unitful.jl/stable/), which enables attaching units to variables:

```julia-repl
julia> using Unitful
```
"""

# ╔═╡ 88ca2a73-6203-447c-afcc-9e370a82076b


# ╔═╡ c24f1ddd-5e31-4073-a627-86cedb1d44c2
md"""
Now let's create a velocity `m3` with attached units:

```julia-repl
julia> m3 = (32 ± 0.1)u"m/s"
```
"""

# ╔═╡ 63a4b27a-5361-4d95-8787-ae31ca7987fe


# ╔═╡ d65a2638-54c0-4eb5-a870-44d7ab35400c
md"""
Let's create a duration `m4` with attached units:

```julia-repl
julia> m4 = (9.8 ± 0.3)u"s"
```
"""

# ╔═╡ 15674bb0-2fe1-40b1-a6c0-3a5a64a6a5c3


# ╔═╡ c07f9493-b867-485b-87f2-50348bb9eaa6
md"""
Let's calculate `β` by multiplying `m3` and `m4`:

```julia-repl
julia> β = m3 * m4
```
"""

# ╔═╡ 70f08712-002c-4adc-84b1-73a8655d8a44


# ╔═╡ 6cc63679-6352-4ffa-ae6a-3066431cfd10
md"""

The variable β's value now has an associated error and unit.

!!! note
    Some care must be taken when using Greek characters to not override their predefined values. For example, π is the predefined constant π, ie., 3.1415926... .

```julia-repl
julia> π
```

And 2π is the constant 2π:

```julia-repl
julia> 2π
```

!!! note
    As in the case of `2π`, the multiplication operator is inferred from the context and is not necessary. There cannot be a space between the number and variable.

---
"""

# ╔═╡ cf4a0e8f-9210-4f1e-84d4-ee7ff09aaf61
md"""
## Arrays

Let's see if this works with one dimensional arrays or vectors:

```julia-repl
julia> γ = [10 ± 0.1, 20 ± 0.2, 30 ± 0.3]u"m/s" .* [15 ± 0.01, 25 ± 0.02, 25 ± 0.03]u"s"
```

Note the dot '`.`' before the multiplication character '`*`'.  This means element-wise multiplication, whereas the multiplication character '`*`' by itself means matrix multiplication. If you are coming from Python, this difference may take a little time to get used to.
"""

# ╔═╡ fdba7211-e480-4948-8435-76a7608e7e63


# ╔═╡ 1f90de4b-790b-41f8-9a7b-3a54e9fff472
md"""
See the [dot syntax](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) section of the Julia manual for more.

---

## Symbolics

Julia can also do symbolic manipulation. We will need the [Symbolics.jl](https://docs.sciml.ai/Symbolics/stable/) package for this and [Latexify.jl](https://korsbo.github.io/Latexify.jl/stable) for optional pretty printing in the notebook:

```julia-repl
julia> using Symbolics, Latexify
```
"""

# ╔═╡ 94d323b9-554f-4620-8900-da7c89ad338d


# ╔═╡ 746e3dae-4bbb-410b-899f-ef95c8afb1b0
md"""
We will use rotation matrices as an example, where `Rx`, `Ry`, and `Rz` are rotations about the ``x``, ``y``, and ``z``-axes:

```julia-repl
julia> Rx(θ) = [1. 0. 0.; 0. cos(θ) sin(θ); 0. -sin(θ) cos(θ)]

julia> Ry(θ) = [cos(θ) 0. -sin(θ); 0. 1. 0.; sin(θ) 0. cos(θ)]

julia> Rz(θ) = [cos(θ) sin(θ) 0.; -sin(θ) cos(θ) 0.; 0. 0. 1.]
```
"""

# ╔═╡ d7169595-d401-4fab-8554-d25e3b367583


# ╔═╡ 80335b0c-de35-4133-a32d-c0ccb826a4b3
md"""
Now create symbolic variables for the three equatorial precession angles: `z`, `θ`, and `ζ` defined by *Lieske et al. (1977)*:

```julia-repl
julia> @variables z, θ, ζ
```
"""

# ╔═╡ 8f5f7d12-38eb-49c9-90c6-81d27eda13fe


# ╔═╡ 1b9553dd-149c-4e48-aacf-10d6ca4756c2
md"""
Let's see what the rotation matrix looks like for the three-angle formulation of the precession matrix:

```julia-repl
julia> Rz(-z)Ry(θ)Rz(-ζ)
```
"""

# ╔═╡ 856a6279-6354-48de-85ca-c5638be68c9e


# ╔═╡ 481ffbf7-d2b9-44cd-9f18-834e1344f977
md"""
Replacing the symbolic variables, `z`, `θ`, and `ζ` with numerical values in the above precession formula will return a numerical result.  The rotation matrices work without needing any changes for both numerical and symbolic variables.
"""

# ╔═╡ 5767f17a-a101-4e02-b4f6-b11ee777882b
md"""
---
"""

# ╔═╡ f80f1bdd-5147-4a6c-8280-09329ed6dba1
md"""
## GPU Programming

Depending on the GPU that your laptop has, you will need to load one of the following packages:

```julia-repl
julia> using CUDA                 # for NVIDIA

julia> using oneAPI               # for Intel (linux only)

julia> using AMDGPU               # for AMD

julia> using Metal                # Apple Silicon, i.e., M1-4 Mac
```
"""

# ╔═╡ d308df6b-14ec-49ec-8270-a3b9efd88517


# ╔═╡ cfc57dc3-bb97-4bf2-99e8-241e3f552f1e
md"""
Create three large arrays.

```julia-repl
julia> xlarge = rand(2^20)

julia> ylarge = rand(2^20)

julia> outlarge = zero(xlarge)
```

"""

# ╔═╡ d7ecfac4-8b9b-4b4b-b258-429f417380cc


# ╔═╡ b186c2fa-0ce2-4941-a9fa-a055de7f4ebf
md"""
Let's load our array onto the GPU. For CUDA:
```julia-repl

julia> xlarge_gpu   = cu(xlarge)

julia> ylarge_gpu   = cu(ylarge)

julia> outlarge_gpu = cu(outlarge)
```

For other GPU providers replace `cu` with:
```julia-repl
julia> ROCArray(xlarge)              # AMD

julia> oneArray(xlarge)              # Intel

julia> MtlArray(xlarge)              # Apple Silicon
```

And add them together.

```julia-repl
julia> outlarge_gpu .= xlarge_gpu .+ ylarge_gpu
```
"""

# ╔═╡ ec8dbfe4-15f2-41f6-93be-48486c2bf8fb


# ╔═╡ 61e2fed6-b5e1-4a13-b8af-441ae3484cbb
md"""
Then tranfer the result back to RAM.

```julia-repl
julia> outlarge .= Array(outlarge_gpu)
```
"""

# ╔═╡ 73c36af8-cf09-4058-bac2-b6394dcc555b


# ╔═╡ da2c5d76-2dd3-4f1c-834e-11189793c56f
md"""
For more information about GPU programming in Julia, see session *2-4: Parallel-Computing* and the [JuliaGPU website](https://juliagpu.org/).
"""

# ╔═╡ 8401d5df-ccb5-4c98-a952-6d71b7a74fa8
md"""
# Summary

!!! note

    What have we learned about the Julia command line and features?

    * Julia has four command line modes: **REPL**, **help**, **shell**, and **package manager**.

    * Julia understands **unicode**.

	* Julia is a **concise** language and therefore very **productive**.

    * Julia packages are **composable**.
	  - I.e., independent packages are compatible and work together without modification.

    * Julia can perform **symbolic manipulation**.

    * Julia can perform **GPU calculations** without resorting to C/C++.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Term = "22787eb5-b846-44ae-b979-8e399b8463ab"

[compat]
LaTeXStrings = "~1.4.0"
PlutoUI = "~0.7.76"
Term = "~1.0.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.3"
manifest_format = "2.0"
project_hash = "d02345fba3fea7429354d32108657c78c7f53616"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"
weakdeps = ["StyledStrings"]

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Highlights]]
deps = ["DocStringExtensions", "InteractiveUtils", "REPL"]
git-tree-sha1 = "9e13b8d8b1367d9692a90ea4711b4278e4755c32"
uuid = "eafb193a-b7ab-5a9e-9068-77385905fa72"
version = "0.5.3"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.15.0+0"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.5.20"

[[deps.MyterialColors]]
git-tree-sha1 = "01d8466fb449436348999d7c6ad740f8f853a579"
uuid = "1c23619d-4212-4747-83aa-717207fae70f"
version = "0.3.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.1"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "0d751d4ceb9dbd402646886332c2f99169dc1cfd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.76"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "f0803bc1171e455a04124affa9c21bba5ac4db32"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.6"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "f2c1efbc8f3a609aadf318094f8fc5204bdaf344"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Term]]
deps = ["Dates", "Highlights", "InteractiveUtils", "Logging", "Markdown", "MyterialColors", "OrderedCollections", "Parameters", "ProgressLogging", "Tables", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "e4ccdfbdc073f71109c5fe0af7239c43714997d3"
uuid = "22787eb5-b846-44ae-b979-8e399b8463ab"
version = "1.0.2"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.7.0+0"
"""

# ╔═╡ Cell order:
# ╟─6001288a-7a9d-4020-bf7d-02a0fa250c04
# ╟─38ead816-0375-4605-a833-6464485aa0d6
# ╟─95cfbabc-5e7c-481b-853c-6d06baa577b6
# ╟─8e597a38-6e41-499f-af06-f9223b8827de
# ╟─1cc401a1-6d3a-40e5-a4fc-012caa913369
# ╟─b1ed2c4e-f5fa-4e5e-87d8-7af6f80a83ca
# ╟─7f3357bc-4103-4a35-af21-9c86f5a0ec2f
# ╟─7475c896-d1b1-4429-9ba8-8e78de41e0b0
# ╟─5df8264e-6e37-4674-abdf-2b05c530787f
# ╠═4a404280-2845-4deb-8eee-2dcdcb9aed27
# ╟─7813824a-cae9-4b97-ac90-e542fbd630d5
# ╠═6ac51e87-87a2-4ccc-9f08-0028700b3cda
# ╟─27208179-35c3-43c1-9548-3620c8aa7680
# ╠═40d8d18c-3713-4e77-812d-9d77a4e1ac50
# ╟─aa3e9db7-49d1-40f8-b745-6c4faa2197e1
# ╠═8eb9630a-44b2-4ac8-b243-0c2ce5b16f50
# ╟─419a6dec-1db0-477f-911f-049223b5674f
# ╟─85f2bec3-0095-4bbc-93ef-48ab97094244
# ╟─8ee7f43d-bf75-4975-ac64-54c2d5a0174a
# ╟─d1e9c51c-efb9-4dcb-9d28-8c54a235fbb4
# ╟─b27578b2-f5f5-4e46-82e6-0007be187ba6
# ╟─065265a5-c9ad-4a39-b14d-f4e2e49d3f7a
# ╟─563f07ad-6aed-495e-85fb-bae4a1755ac2
# ╟─0f94b21c-364f-488e-aff3-28c4b39a3844
# ╠═40abc83f-b4bd-479f-8671-189cc712d792
# ╟─297cd86c-5e9d-4f70-b11a-cbae8fa96d1e
# ╠═8f016c75-7768-4418-8c57-100db3073c85
# ╟─094b6f30-cbd6-46b1-8e0c-3fdb1ef18261
# ╠═7ba8dc19-e0ca-40de-a778-7583ca70978d
# ╟─668abc35-fdc3-430f-8c90-de3c2c2cd77b
# ╠═0e42f7fd-955e-4679-8d90-0cb46c9a12dc
# ╟─d2a2d0bc-e883-439f-8e34-166e2369caef
# ╟─750acbf6-bc04-43ea-b123-14753cab597a
# ╠═88ca2a73-6203-447c-afcc-9e370a82076b
# ╟─c24f1ddd-5e31-4073-a627-86cedb1d44c2
# ╠═63a4b27a-5361-4d95-8787-ae31ca7987fe
# ╟─d65a2638-54c0-4eb5-a870-44d7ab35400c
# ╠═15674bb0-2fe1-40b1-a6c0-3a5a64a6a5c3
# ╟─c07f9493-b867-485b-87f2-50348bb9eaa6
# ╠═70f08712-002c-4adc-84b1-73a8655d8a44
# ╟─6cc63679-6352-4ffa-ae6a-3066431cfd10
# ╟─cf4a0e8f-9210-4f1e-84d4-ee7ff09aaf61
# ╠═fdba7211-e480-4948-8435-76a7608e7e63
# ╟─1f90de4b-790b-41f8-9a7b-3a54e9fff472
# ╠═94d323b9-554f-4620-8900-da7c89ad338d
# ╟─746e3dae-4bbb-410b-899f-ef95c8afb1b0
# ╠═d7169595-d401-4fab-8554-d25e3b367583
# ╟─80335b0c-de35-4133-a32d-c0ccb826a4b3
# ╠═8f5f7d12-38eb-49c9-90c6-81d27eda13fe
# ╟─1b9553dd-149c-4e48-aacf-10d6ca4756c2
# ╠═856a6279-6354-48de-85ca-c5638be68c9e
# ╟─481ffbf7-d2b9-44cd-9f18-834e1344f977
# ╟─5767f17a-a101-4e02-b4f6-b11ee777882b
# ╟─f80f1bdd-5147-4a6c-8280-09329ed6dba1
# ╠═d308df6b-14ec-49ec-8270-a3b9efd88517
# ╟─cfc57dc3-bb97-4bf2-99e8-241e3f552f1e
# ╠═d7ecfac4-8b9b-4b4b-b258-429f417380cc
# ╠═b186c2fa-0ce2-4941-a9fa-a055de7f4ebf
# ╠═ec8dbfe4-15f2-41f6-93be-48486c2bf8fb
# ╟─61e2fed6-b5e1-4a13-b8af-441ae3484cbb
# ╠═73c36af8-cf09-4058-bac2-b6394dcc555b
# ╟─da2c5d76-2dd3-4f1c-834e-11189793c56f
# ╟─8401d5df-ccb5-4c98-a952-6d71b7a74fa8
# ╟─7c4ebc32-9b8e-4b2a-8f39-f4c351283843
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
