### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ fd7dfb64-279e-415d-9fa7-09ac2229e38a
begin
	using Dates, PlutoUI, HypertextLiteral
	TableOfContents(title = "2-1: Calling Python", depth = 4)
end

# ╔═╡ 24a6f370-224b-4cb4-8350-f60c99300b35
"""
!!! note "2-1: Calling Python"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 4c788b44-77e1-11ed-0ce7-5914857ba421
md"""
# Calling Python from Julia

Julia has two packages for calling Python code from Julia: PyCall & PythonCall. PyCall has an easier learning curve, but has a few limitations. Whereas, PythonCall has better performance, because it is more complete and allows for more control.

Both packages have symmetric interfaces, so the user can call Python from Julia and Julia from Python. This session will only focus on calling Python from Julia.
"""

# ╔═╡ f0c6b09d-8b64-4175-aacd-6b3ac72078f6
md"""
# PyCall & PyJulia

This session assumes that the PyCall package has already been added using the package manager and invoked using the `using` statement.

## PyCall String Macros

The easiest way to call Python from Julia is to use string macros. There are two variations: the single-line, single-quote variation `py"..."` and the multi-line triple-quote vatiation `py\"""...\"""`.

For example:

```julia-repl
julia> py"x = arange(1,100)"

julia> py"y = sin(3 * x + 4 * cos(2 * x))"

```

Or

```julia-repl
julia> py\"""
x = arange(1,100)
y = sin(3 * x + 4 * cos(2 * x))
\"""
```

## Built-In Python Packages

Like Python, built-in Python packages are required to be imported: 

```julia-repl
julia> math = pyimport("math")
```

They can then be used to perform calculations using more complex functions:

```julia-repl
julia> math.sin(math.pi /4)
```

## Python Site Packages

Site packages, such as the `matplotlib.pyplot` package, also require importing the package. This can be done using the `pyimport_conda` function.

In the following example, the `x` and `y` values are calculated using Julia and are plotted using Python.

```julia-repl
julia> let
	plt = pyimport_conda("matplotlib.pyplot", "matplotlib")
	x = range(0; stop=2pi, length=1000)
	y = sin.(3 .* x + 4 .* cos.(2. * x))
	plt.plot(x, y, color="red", linewidth=2.0, linestyle="--")
	plt.savefig("plt_example.png")
	LocalResource("plt_example.png")
end
```
!!! note
	If `matplotlib.pyplot` fails because `matplotlib` hasn't been installed, then it will automatically install `matplotlib`, which may take a few minutes. It may also be necessary to retry importing the package a second time.
"""

# ╔═╡ ac1d7b07-27b7-4d81-90f0-73d43fb1285f
md"""
# PythonCall & JuliaCall

The section also assumes that PythonCall has been added and invoked using the package manager and the `using` statement.

## Python Macros

PythonCall has a similar feature to PyCall's Python string. It has the Python macro that can be used to evaluate Python expressions and return them as Python objects.

For Example:

```julia-repl
julia> @py x = 1
```

!!! note
	PythonCall macros are considered experimental and may possibly be removed in a future version.

## Python Objects

The usual syntax for interacting with Python is via Python objects, which are Julia types that represent Python objects. In the following example, `re`, `words`, and `sentence` are Python objects and the execution is done in Python. Only in the last `pyconvert` statement is the Python string converted to a Julia String.

```julia-repl
julia> begin
	re = PythonCall.pyimport("re")
	words = re.findall("[a-zA-Z]+", "PythonCall.jl is great")
	sentence = Py(" ").join(words)
	pyconvert(String, sentence)  # convert Python string to Julia string
end
```

## Wrapper Types

A wrapper is a Julia type that wraps a Python object, but gives it Julia semantics. For example, the PyList type wraps Python's list object. In the following example, all of the execution is in Julia. Compare to the previous example.

```julia-repl
julia> begin
	x = pylist([3,4,5])
	y = PyList{Union{Nothing, Int64}}(x)
	push!(y, nothing)
	append!(y, 1:2)
	x
end
```

There are wrappers for other container types, such as PyDict and PySet.

```julia-repl
julia> let
	x = PythonCall.pyimport("array").array("i", [3,4,5])
	y = PythonCall.PyArray(x)
	println(sum(y))
	y[1] = 0
	x
end
```

PyArray directly wraps the underlying data buffer, so array operations such as indexing are about as fast as an ordinary Array.
"""

# ╔═╡ 7535b82b-67f2-4ef2-9b91-d8151e0bce16
md"""
# Configuration

PyCall and PythonCall can be used in the same Julia session on Unix (Linux, OS X, etc.) as long as the same interpreter is used for both. On Windows, it appears separate interpreters can be used.

To use the same interpreter for PyCall and PythonCall, several environment variables must be set before adding the package. Otherwise, the package will need to be rebuilt.

## Configuring PythonCall

By default importing the module will initialize a conda environment in your Julia environment, install Python into it, load the corresponding Python library, and initialize an interpreter.

## Using your current Python installation

```julia-repl
julia> ENV["JULIA_CONDAPKG_BACKEND"] = "Null"
julia> ENV["JULIA_PYTHONCALL_EXE"] = "/path/to/python"   # optional
julia> ENV["JULIA_PYTHONCALL_EXE"] = "@PyCall"   # optional
```

By setting the CondaPkg backend to Null, no Conda packages will be installed. PythonCall will use your current Python installation.

If Python is not in your `PATH`, you will need to set the `JULIA_PYHTHONCALL_EXE` environment variable to include it in your path.

If you also use PyCall, you can set the `JULIA_PYTHONCALL_EXE` environment variable to use the same interpreter.

## Using your current Conda environment

```julia-repl
julia> ENV["JULIA_CONDAPKG_BACKEND"] = "Current"
julia> ENV["JULIA_CONDAPKG_EXE"] = "/path/to/conda"   # optional
```

Note that this configuration will still install any required Conda packages into your Conda envirnment.

If `conda`, `mamba`, and `micromamba` are not in your `PATH` you will need to set `JULIA_CONDAPKG_EXE` to include them.

## Using your current Conda, Mamba, and MicroMamba environment

```julia-repl
julia> ENV["JULIA_CONDAPKG_BACKEND"] = "System"
julia> ENV["JULIA_CONDAPKG_EXE"] = "/path/to/conda"   # optional
```

The System backend will use your preinstalled Conda environment.

## Installing Python packages

Assuming you are using `CondaPkg.jl`, PythonCall uses it to automatically install any Python packages. For example,

```julia-repl
julia> using CondaPkg

julia> ] # enter package manager

pkg> conda add some_package
```
"""

# ╔═╡ ab31c637-f1fd-4e7d-981a-5d06319c1314
md"""
# Summary
!!! note ""
	* Two packages are available for calling Python from Julia and Julia from Python.
	* PyCall provides an easy way to call Python.
	* PythonCall provides more features and greater performance.
	* Both packages use `CondaPkg.jl` to install and maintain Python packages.
    * Calling Python from Julia can provide functionality not currently available in Julia.
    * Calling Julia from Python can provide a way to improve the performance of critical Python code.
	* Calling Julia from Python can provide a way to incrementally migrate Python to Julia.
"""

# ╔═╡ 6d943185-2305-4d44-9007-3fc63a84f987
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ 68a1de02-8b0f-4b83-9f7d-965508791e94
md"""
## 1: Install PythonCall
!!! warning ""
	* Install the PythonCall package.
	* 
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.77"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.3"
manifest_format = "2.0"
project_hash = "f749cd606c6cd84ecc39dc356399db0dd53ab1ce"

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
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

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

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.1"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "6ed167db158c7c1031abf3bd67f8e689c8bdf2b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.77"

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
# ╟─24a6f370-224b-4cb4-8350-f60c99300b35
# ╟─4c788b44-77e1-11ed-0ce7-5914857ba421
# ╟─f0c6b09d-8b64-4175-aacd-6b3ac72078f6
# ╟─ac1d7b07-27b7-4d81-90f0-73d43fb1285f
# ╟─7535b82b-67f2-4ef2-9b91-d8151e0bce16
# ╟─ab31c637-f1fd-4e7d-981a-5d06319c1314
# ╟─6d943185-2305-4d44-9007-3fc63a84f987
# ╠═68a1de02-8b0f-4b83-9f7d-965508791e94
# ╟─fd7dfb64-279e-415d-9fa7-09ac2229e38a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
