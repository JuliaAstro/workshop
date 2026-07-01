### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ cc995826-8fdb-4d96-a473-389ccdd812e5
begin
	using Dates, PlutoUI, HypertextLiteral
	TableOfContents(title = "2-5: Creating Packages", depth = 4)
end

# ╔═╡ 1359d1a5-0e19-4bc0-8fd2-cec007d97955
"""
!!! note "2-5: Creating Packages"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 2b2adba9-fc0d-4f59-95a5-8d14d1c067f4
md"""
In this section, we will discuss Julia modules, environments, and packages. This may be confusing at first, since in Python all three are combined into a single concept.

# Modules

A module in Julia is a way to group a set of variables, types, and functions into a namespace. We've already used lots of modules in this workshop by loading a package.

A module is created using a `module` block like this one:

```julia-repl
julia> module MyModA
	y = 1
	f(x) = 2x^2
end
```

!!! note
	The module name should be capitalized per Julia convention.

Any function, variable, or type defined in a module is distinct from those defined outside it. For example, these two refer to completely different functions called `f`:

```julia-repl
julia> f(x) = 9x^3
julia> module MyModA
	f(x) = 2x
end

julia> f(2) != MyModA.f(x)
```

This is separate from the concept of *methods*.  Here `f` and `MyModA.f` are two different functions that have different funcionality. Whereas, two methods of the same function are different versions having the same functionality.

## Extending Another Module's Function

It is common to extend a function from another module by adding a new method.

Suppose that Alice creates a module called Geometry that defines a Point2D type. It also contains a function `distance_from_origin`. It has one method that accepts a single `Point2D` argument.

```julia-repl
julia> module Geometry
	struct Point2D
		x::Float64
		y::Float64
	end

	function distance_from_origin(point::Point2D)
		return sqrt(point.x^2 + point.y^2)
	end
end
```

Now suppose that Bob wants to use Alice's package, and extend it to work with three dimensional points. Bob defines a new `Point3D` type and extends the `Geometry.distance_from_origin` function with a new method:

```julia-repl
module BobsGeometryExtras
	struct Point3D
		x::Float64
		y::Float64
		z::Float64
	end

	function Geometry.distance_from_origin(point::Point3D)
		return sqrt(point.x^2 + point.y^2 + point.x^2)
	end
end
```

!!! note
	The syntax `Module.function` should be used when adding a method to a function from another module.

Finally, let's take a look at how we can add methods to Julia's built in functions.
Add the following to the `BobsGeometryExtras` module from earlier:

```julia
using LinearAlgebra

function Base.abs(point::Point3D)
	return Point3D(abs(point.x), abs(point.y), abs(point.z))
end

function Base.:(+)(a::Point3D, b::Point3D)
	return Point3D(a.x + b.x, a.y + b.y, a.z + b.z)
end

# Define Point3D multiplication as the cross product
function Base.:(*)(a::Point3D, b::Point3D)
	return Point3D(
		a.z*b.z - a.z*b.y,
		a.z*b.x - a.x*b.z,
		a.x*b.y - a.y*b.x
	)
end
```

Adding methods to existing functions is the main way that Julia packages are built, and a key component of Julia's uniquely pervasive composability.

A great talk on this topic is [The Unreasonable Effectiveness of Multiple Dispatch](https://www.youtube.com/watch?v=kc9HwsxE1OY) by Stefan Karpinski.

!!! danger "Type Piracy"
	**Type Piracy** is when you extend a function without at least one argument type that your module "owns". For example, it would be type piracy for Bob to extend Alice's `distance_from_origin` function with a method that takes two integers.

	Though not enforced at the language level, type piracy must be avoided to prevent spooky action at a distance, where loading one module changes the behaviour of unrelated functionality in a separate module.


"""

# ╔═╡ 077135e0-8322-11ed-32aa-0724ce8da92c
md"""
# Environments and Packages


Putting your code into a package is especially important in Julia, since it unlocks some useful features such as:

* Code reuse.
* Precompilation for fast loading.
* Live-reloading of code changes with Revise.jl.
* Code sharing.

Notice that I put sharing your code at the bottom of the list. Placing your code in a package is a useful thing to do even if you're not sure you want to share your code with other people.

!!! tip
	A commercial but free service for finding Julia packages is  [juliahub.com](https://juliahub.com/ui/Packages), operated by Julia Computing.
"""

# ╔═╡ 9739ac67-b5ff-4488-9c7d-bbc4b3c36d3a
md"""
# Environments

An "environment" is a list of packages and possibly version numbers.
An environment consists of just two files:
* `Project.toml`
* `Manifest.toml`

## Project.toml

`Project.toml` tracks what packages need to be installed to use that environment. It might look something like this:

```toml
[deps]
FITSFiles = "358a0a88-3548-4ad6-b652-8bdbf64af8e5"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
```

Or

```toml
[deps]
FITSFiles = "358a0a88-3548-4ad6-b652-8bdbf64af8e5"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
FITSFiles = ">=0.3.0"
```

The keys on the left are the names of the packages, and the gobbledegook on the right is a unique machine readable identifier. This makes sure that even if people pick the same names for their packages, Julia won't get them confused.

You do not have to make the Project.toml file yourself. Julia can do it for you. Navigate to your working directory and enter `] activate .` from the REPL to make the current directory an environment. You can then install packages as usual (`] add FITSFiles`, for example) and Julia will modify `Project.toml`.

If you share your `Project.toml` with someone, they can activate it and run `instantiate` to install all of the packages inside. It will pick versions that match the general constraints listed under `[compat]`

!!! tip
	If you're planning on writing some scripts for a project, it's a very good idea to create an environment.

## Manifest.toml

`Manifest.toml` is a bit more niche. It stores all the exact versions of every package you use. If you want someone (possibly yourself at a later date) to be able to exactly reproduce an environment down to every minor version, then include the `Manifest.toml` with the Project.toml. This is a great way of ensuring reproducible science.
"""

# ╔═╡ 63d8bf16-f065-48dc-9e17-a92937414cd9
md"""
## Pluto
Pluto notebooks are stored in `.jl` files just like regular scripts. If you open one up in a text editor of your choice, you will see contents like the following:

```julia
### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# e28bad2f-f4ea-4c30-9f08-746ca2f609d8
using AstroImages

# 98d2310d-a17b-4b0d-877d-9f77020848d3
using Plots

# 1877c9ea-77e9-11ed-11b3-4d295a402999
md"this is a markdown cell"


# 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = \"""
[deps]
AstroImages = "fe3fc30c-9b16-11e9-1c73-17dabf39f4ad"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
AstroImages = "~0.4.0"
Plots = "~1.37.2"
\"""

# 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = \"""
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-DEV"
manifest_format = "2.0"
project_hash = "59562c7a7aee2e03c8392b93c96735eb9485add4"


# Cell order:
# ╠═20b9ba30-2685-4535-9244-693f8e653a9a
# ╠═67371af8-bd8d-4fef-b46a-6f57624e052d
# ╠═1877c9ea-77e9-11ed-11b3-4d295a402999
```

Thus, a Pluto notebook is a Julia script with some additional special formatting.
Two variables are defined `PLUTO_PROJECT_TOML_CONTENTS` and `PLUTO_MANIFEST_TOML_CONTENTS` that include the contents of the `Project.toml` and `Manifest.toml` files.

Basically, Pluto creates an environment for each notebook. If you open the notebook on another computer, Pluto will load the exact same versions of all packages.
"""

# ╔═╡ 1413a21a-d653-489d-80e6-9348b114fcff
md"""
# Packages

Packages are similar to libraries in other languages.

## Creation

To make a package called `MyPackage`, we'll create the following files:
```
MyPackage/
├─ src/
│  ├─ MyPackage.jl
├─ Project.toml
├─ Manifest.toml  <this will be generated automatically by Julia>
```

Inside Project.toml we'll give the package a name and unique identifier. You can generate the identifier by running:
```julia
using UUIDs
uuid4()
```

The `Project.toml` should look like

```toml
name = "MyPackage"
uuid = "<insert unique id here>"
```

Inside `MyPackage.jl` we'll create an empty module
```julia-repl
julia> module MyPackage
	# code goes here!
end
```

That's it! You can now load your package by:

```julia-repl
julia> `] activate MyPackage`
julia> `using MyPackage`
```

If you want your package accessible to other code, activate your other environment and, from inside, run

```julia-repl
`] develop /home/path-to/MyPackage`.
```

This will add it to that environment's Project.toml.

-----

Notice how we had to put `module MyPackage` at the top of MyPackage.jl? Unlike in Python, modules != files. You can create multiple, nested modules inside the same file (you should rarely want to do this):

```julia-repl
julia> module MyPackage
	module PartA
	end

	module PartB
	end
end
```

Or split a module across multiple files (you should often do this):
```julia-repl
julia> module MyPackge
	include("type-definitions.jl")
	include("function-definitions.jl")
end
```

`include` almost-literally copies and pastes in code from another file. It's the main way to split a package up into different unique units.

!!! note
	You can also use `include("file.jl")` to directly run a script from inside Julia.

-----

The other way to create a package is via the `PkgTemplate` package. This package provides an interactive way to create a package.
"""

# ╔═╡ 44b4a9f9-7740-4ea5-bb03-3fca9a48f220
md"""
## Workflows

The best way to work on a package is with Revise.jl. Revise is a simple package, just run `using Revise` at the start of your session, and Julia will automatically notice and recompile any code that changes in your package.
This way you can edit your package as you go, adding functions, fixing bugs, etc, and whenever you run anything in the REPL, you'll see the latest changes.

"""


# ╔═╡ 7dbb9c09-5b7a-4a5a-b6b1-8946b0cf962e
md"""
## Repositories

The easiest way to share a Julia package is to put it on GitHub.

* Create a repository with same name as your package (include the `.jl`) and push your folder to it.
* Other people can install your package by running `] add https://github.com/yourname/MyPackage.jl.git`

When you feel that your package is ready for public use, you can **register** it with the **Julia General Registry** so that people can install it by just typing

```julia-repl
julia> ] add MyPackage`
```

There are lots more things you can add to your package over time.
"""

# ╔═╡ ea74763f-ece3-4a4c-ae76-39d1ac5ca2dd
md"""
## Tests
You can add tests in a file called `tests/runtests.jl` and then generate a test report by entering:

```julia-repl
julia> ] test MyPackage
```

If your package is registered, the Julia developers will run your package tests against new versions of Julia to make sure everything works as expected.

You can even hook up these tests to GitHub so that they run everytime you change the code. This is a great way to make sure everything stays working the way it should!
"""

# ╔═╡ cf62edf6-59e7-4880-9c51-897c29c1233c
md"""
## Documentation
You can add documentation to your package in the `docs` folder. See [documenter.juliadocs.org](https://documenter.juliadocs.org/stable/) for details. You can configure GitHub to automatically convert your docs into a hosted webpage.
"""

# ╔═╡ 55ad190b-6b0b-498b-9d26-5dc55fed05c3
md"""
# Summary

!!! note ""
	* 
"""

# ╔═╡ 994622be-aaa7-4610-822e-fe77e42cf0f0
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ d9452874-28ad-4eac-83cd-14b719828999
md"""
## 1: 
!!! warning ""
    * 
"""

# ╔═╡ 35e08843-8dde-495c-ab4f-bbb43ed75395
md"""

Try making a small module with a couple of variables and functions in the next Pluto cell:
"""

# ╔═╡ 56a7b4fe-970b-480a-bfaa-f703a17ade8c
md"""
The contents of modules can be accessed using a `.` (dot):
```julia
MyModA.f(2)
```

Try running the function you defined inside your module:
"""

# ╔═╡ aeac8c7b-0dbe-4fcc-a536-ab97e8aa5483
md"""
## 2: 
!!! warning ""
    * 
"""

# ╔═╡ bd33ebc5-f4cc-4cf5-b8ba-3d4bf280749e
md"""

Try creating a `Point2D` and using the distance function:
"""

# ╔═╡ c7ccc1ff-9784-4cb1-a2cf-89a21d2c4ec3
md"""
Try using the `distance_from_origin` function with a `Point3D`:
"""

# ╔═╡ 70f08389-839e-485b-a381-37a27e2ccf38
md"""
## 3: 
!!! warning ""
    * 
"""

# ╔═╡ 93d3f0fc-030e-4600-8773-a68631dd5207
md"""
Since we've defined the `+` function on the Point2D type, lots of new behaviour emerges naturally.

1. Try creating a vector of points, and passing it to the `sum` function
2. Create two matrices of points, take the matrix multiplication of them with `*`
"""

# ╔═╡ 2f49bb71-4641-4c0e-aecb-8557a4c4401d
md"""
Once you've done that, try the following examples:

```julia-repl
p1 = BobsGeometryExtras.Point3D(1,1,1)
p2 = BobsGeometryExtras.Point3D(1,-1,1)
p3 = p1 + p2

p4 = p1 * p2
```


"""

# ╔═╡ 7b6689b3-75d3-4245-87ef-b46d93249414
md"""
## Bonus content: Defining functions with a for loop.
A neat trick that is widely used when writing modules is to use a for loop to write functions for you.

One common situtation where this is useful is when writing a package is that you define a type that combines an existing type like an array with some additional fields and behaviour. For example, `AstroImage` combines an a matrix with a header structure to track metadata.

In these situations, one typically wants the new type to behave just like the object it wraps (the matrix in this example) in several ways, but not in others.

Let's see how this may look.
"""

# ╔═╡ c16ec715-7adc-4fde-9021-8b44746ae6ff
struct MetaArray{TArray,TMetadata}
	array::TArray
	meta::TMetadata
end

# ╔═╡ 0a174016-3511-477b-ae12-d7978c20f45f
arr = MetaArray(randn(4,4), (a=1,b=2,c="text"))

# ╔═╡ feb49ac1-989c-4652-8e71-6d1f0d88199e
arr.meta.c

# ╔═╡ 147e7d41-5a58-4831-b449-66084a9210bb
for f in [
	:(Base.getindex),
	:(Base.setindex!),
	:(Base.adjoint),
	:(Base.transpose),
	:(Base.view),
]
	@eval ($f)(arr::MetaArray, args...) = MetaArray($f(arr.array, args...), arr.meta)
end

# ╔═╡ 8df360a9-df72-4da8-82a4-7f09b347c7cb
md"""
This is an example of *metaprogramming*: a program that writes a program.

We loop over the variable names Base.getindex, Base.setindex!, etc.
Inside the loop body, we create a quoted expression where some function \$f is defined against a MetaArray.
Then, we evaluate that expression, replacing \$f with the function in question.

"""

# ╔═╡ f7cb6ead-8799-47f9-a553-d570581e4b56
# Now we can use [] to get elements
arr[1,2]

# ╔═╡ fdece0ec-966a-4d33-82dc-3f6fe095075c
# We can transpose it
arr'

# ╔═╡ 365f7190-0737-46ba-accb-8d237e75a460
# We can create views into it

# ╔═╡ 6477fbb2-f266-44ee-b0b9-5464a53d88cf
v = view(arr, 1:2, 1:2)

# ╔═╡ 74084dcf-1781-40bf-9b1d-b70f51e03c75
md"""
## 4: Create a package
!!! warning ""
    * 
"""

# ╔═╡ 81ca6acf-6089-40f4-b909-40495e105ee0
md"""
## N: 
!!! warning ""
    * 
"""

# ╔═╡ 575703f0-efec-4092-b067-8eaf5600bd69
md"""
## Excercises

In these excercises, we will create our own package. This can be just a simple "hello world" function, but I would suggest you try creating a very basic package that you would use in your research.

### Part 1
* Come up with a name for your package.
* Create a folder structure with the right names.
* Using a text editor of your choiceCreate Project.toml with the package name and a unique identifier

### Part 2
* Fill out your package with a function or two. Try to come up with a function that would be useful to other people working in your sub-field.
* If you need to use a function defined in another Julia package, use `] add OtherPackage` to install and add it to `Project.toml` automatically.

### Part 3
* Share it with the group!

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.3"
manifest_format = "2.0"
project_hash = "bd1ab11c79df2472a71a370ad87fee8699ff5092"

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
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

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
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

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
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.5.20"

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

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.1"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
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

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

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
# ╟─1359d1a5-0e19-4bc0-8fd2-cec007d97955
# ╟─2b2adba9-fc0d-4f59-95a5-8d14d1c067f4
# ╟─077135e0-8322-11ed-32aa-0724ce8da92c
# ╟─9739ac67-b5ff-4488-9c7d-bbc4b3c36d3a
# ╟─63d8bf16-f065-48dc-9e17-a92937414cd9
# ╟─1413a21a-d653-489d-80e6-9348b114fcff
# ╟─44b4a9f9-7740-4ea5-bb03-3fca9a48f220
# ╟─7dbb9c09-5b7a-4a5a-b6b1-8946b0cf962e
# ╟─ea74763f-ece3-4a4c-ae76-39d1ac5ca2dd
# ╟─cf62edf6-59e7-4880-9c51-897c29c1233c
# ╠═55ad190b-6b0b-498b-9d26-5dc55fed05c3
# ╟─994622be-aaa7-4610-822e-fe77e42cf0f0
# ╠═d9452874-28ad-4eac-83cd-14b719828999
# ╠═35e08843-8dde-495c-ab4f-bbb43ed75395
# ╟─56a7b4fe-970b-480a-bfaa-f703a17ade8c
# ╠═aeac8c7b-0dbe-4fcc-a536-ab97e8aa5483
# ╟─bd33ebc5-f4cc-4cf5-b8ba-3d4bf280749e
# ╟─c7ccc1ff-9784-4cb1-a2cf-89a21d2c4ec3
# ╠═70f08389-839e-485b-a381-37a27e2ccf38
# ╟─93d3f0fc-030e-4600-8773-a68631dd5207
# ╟─2f49bb71-4641-4c0e-aecb-8557a4c4401d
# ╠═7b6689b3-75d3-4245-87ef-b46d93249414
# ╠═c16ec715-7adc-4fde-9021-8b44746ae6ff
# ╠═0a174016-3511-477b-ae12-d7978c20f45f
# ╠═feb49ac1-989c-4652-8e71-6d1f0d88199e
# ╠═147e7d41-5a58-4831-b449-66084a9210bb
# ╟─8df360a9-df72-4da8-82a4-7f09b347c7cb
# ╠═f7cb6ead-8799-47f9-a553-d570581e4b56
# ╠═fdece0ec-966a-4d33-82dc-3f6fe095075c
# ╠═365f7190-0737-46ba-accb-8d237e75a460
# ╠═6477fbb2-f266-44ee-b0b9-5464a53d88cf
# ╠═74084dcf-1781-40bf-9b1d-b70f51e03c75
# ╠═81ca6acf-6089-40f4-b909-40495e105ee0
# ╟─575703f0-efec-4092-b067-8eaf5600bd69
# ╟─cc995826-8fdb-4d96-a473-389ccdd812e5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
