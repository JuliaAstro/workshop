### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 04cc37cd-ecf9-4dd5-b14d-4d4fe1f0992d
begin
	using Markdown, Dates, PlutoUI, InteractiveUtils
	TableOfContents(; title = "1-6: Functions and Types", depth = 4)
end

# ╔═╡ 70c42e39-490a-4fc2-acfc-c4c0553a4e1e
"""
!!! note "1-6: Functions and Types"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 2614efc4-c4a5-11f0-b6f8-5fb2b6ceb0de
md"""
# Let Julia Do It

Let's assume that we have to write a function `myfunc` to do some data analysis. The function has one argument `a`. It has the same implementation for all floating point data types.

* For statically compiled languages such as C, each argument type must have its own version of the function, i.e., `myfunc(a::Float32)`, `myfunc(a::Float64)`, etc.

* For interpreted languages such as Python, only one version is needed, but performance suffers because the interpreter must determine the type of the argument.

* For Julia, only one version of the function is needed, assuming the argument type is an `AbstractFloat`, i.e., `myfunc(a::AbstractFloat)`

`AbstractFloat` tells Julia to only allow floating point types for the argument. `Integer`s or `String`s are not allowed. A new version or method of the function is compiled for each new data type. Thus, the user only needs to write **one version** of the function. Julia will create new versions of the function for each new argument type when needed.

This feature makes Julia a very productive language by reducing the number of lines of code that need to be written. Julia is typically twice as productive as Python and ten times as productive as C/C++ with similar or better performance.

!!! note
	Productivity is inversely proportional to the number of lines of code. Fewer lines of code result in greater productivity.
"""

# ╔═╡ dbf2d122-5751-447e-9a6b-6997fe9a07fc
md"""
# Constructor Functions

Functions can be constructors for composite types. Assume a composite type `MyType` has two fields `a` and `b`:

```julia
struct MyType
    a::Integer
    b::Integer
end
```

Julia automatically creates a default constructor function:

```julia
function MyType(a::Integer, b::Integer)
    new(a, b)
end
```

with usage of:

```julia
MyType(1, 3)
```

Now assume the second argument `b` is often `0`, then we can define a function of the same name with the second argument having a default value of `0`.

```julia
function MyType(a::Integer, b::Integer=0)
    MyType(a, b)
end
```

with usage of:

```julia
MyType(1)
```
"""

# ╔═╡ bcc0cb23-ea14-477c-8e3c-2c04d7fd00d8
md"""
# Object-Oriented Behaviour

Object-oriented languages tightly couple the class (or composite type) and the method (or function). This is achieved via **single dispatch**, which means that only the first argument is used to detemine which function to call or execute. Python is a good example of a single dispatch language.

* For Python, the method may look like the following, where `self` is the class (composite type):
  ```python
  def mymethod(self, a, b):
  ```
  The method is usually invoked using the dot notation:
  ```python
  self.mymethod(a, b)
  ```

Julia loosely couples composite types (classes) and functions (methods) because of **multiple dispatach**, which means that all positional arguments, or type signature, are used to determine which function to call or execute. Therefore, Julia is not an object-oriented language.

* For Julia, the function may look like the following, where `mytype` is the composite type (class):

  ```julia
  mymethod(mytype, a, b)
  ```
"""

# ╔═╡ 74314d5e-64d6-46a1-88ee-cd5fc84972e3
md"""
# Functors

Functors are nameless functions. They are defined by their argument type, usually a composite type. A good example of this behaviour is the polynomial.

* Construct the polynomial type:

  ```julia
  struct Polynomial{R}
      coef::Vector{R}
  end
  ```

* Construct the function to evaluate the polynomial:

  ```julia
  function (p::Polynomial)(x)
      ...
  end
  ```

* Create the polynomial:

  ```julia
  p = Polynomial([1, 2, 3])
  ```

* Evaluate the polynomial

  ```julia
  p(3)
  ```
"""

# ╔═╡ 0c5d2b23-fb2b-4ce0-a7fc-e706eafd7751
md"""
# Summary
!!! note ""
    * Abstract types allow you to write functions for a specific set of types.
    * Julia creates a new version of the function based on the argument types.
    * Functions can be used to simplify composite type constructors.
    * Julia is not an object-oriented language, but is behaves like one.
    * Functors are nameless functions that use the composite type for dispatch.
"""

# ╔═╡ 666f9c05-4801-4be5-8fa0-7eb8a882517b
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ 2d156a39-9fa7-4c16-9fcb-beccfd318c03
md"""
## 1: A function with one abstract type
!!! warning ""
    * Create a function having one argument being an abstract float type.
    * Use the function with a `Float64` (double precision) type, e.g., `1.0` or `1.0e0`.
    * Use the function with a `Float32` (single precision) type, e.g., `1.0f0`.
      * Note: the `f` means Float32, whereas `e` means Float64.
    * How many methods does it have?
      * Hint: use the `methods()` function, e.g., `methods(myfunc)`.
    * Use the function with a `BigFloat` type.
    * How many methods are there now?
"""

# ╔═╡ c43d1c95-e003-4580-9057-ac59970f17c2
md"""
## 2: A function with two abstract types
!!! warning ""
    * Create a `add` function having two arguments, the first being an abstract float and the second an abstract integer.
    * Use the function with float and integer arguments.
    * Use the function with integer and float arguments.
"""

# ╔═╡ 5588e7ba-1f51-441b-bdc2-fe63023e42e6
md"""
## 3: A constructor function
!!! warning ""
    * Create a composite type with two fields.
    * Instantiate the type, e.g., `a = MyType(1, 2)`.
    * Create a function of the same name having a default second argument.
    * Use the function with one and two arguments.
"""

# ╔═╡ 092154d4-5072-4855-bba6-69500c2dcf31
md"""
## 4: Object-oriented behaviour
!!! warning ""
    * Overload the add operator by executing `import Base.+` .
    * Create a 2D point type.
      * Hint: `struct Point{R} x::R, y::R end`.
    * Create a variable using the Point type.
    * Create add function for the Point type.
      * Hint: `function +(a::Point, b::Point)`.
	* How many methods does the `Base.+` function have?
    * Add the two points together, e.g., `Point(1, 2) + Point(3, 4)`.
    * Create a norm function for the Point type.
    * Evaluate the norm for a point.
"""

# ╔═╡ 36360e9c-a3fa-463d-b3ed-fef4f4851007
md"""
## 5: Functors
!!! warning ""
    * Create a polynomial type.
    * Create a function to evaluate the polynomial at a value `x`.
      * Hint: use the `sum()` function and an array comprehension.
    * Create the polynomial.
    * Evaluate the polynomial.
"""

# ╔═╡ 5c195e5e-3929-4448-9b6e-f3b989f2e297
md"""
----
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.77"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.3"
manifest_format = "2.0"
project_hash = "97fd6d5108c03ab30fcf42eda928f7525bf6da7f"

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
# ╟─70c42e39-490a-4fc2-acfc-c4c0553a4e1e
# ╟─2614efc4-c4a5-11f0-b6f8-5fb2b6ceb0de
# ╟─dbf2d122-5751-447e-9a6b-6997fe9a07fc
# ╟─bcc0cb23-ea14-477c-8e3c-2c04d7fd00d8
# ╟─74314d5e-64d6-46a1-88ee-cd5fc84972e3
# ╟─0c5d2b23-fb2b-4ce0-a7fc-e706eafd7751
# ╟─666f9c05-4801-4be5-8fa0-7eb8a882517b
# ╟─2d156a39-9fa7-4c16-9fcb-beccfd318c03
# ╟─c43d1c95-e003-4580-9057-ac59970f17c2
# ╟─5588e7ba-1f51-441b-bdc2-fe63023e42e6
# ╟─092154d4-5072-4855-bba6-69500c2dcf31
# ╟─36360e9c-a3fa-463d-b3ed-fef4f4851007
# ╟─5c195e5e-3929-4448-9b6e-f3b989f2e297
# ╟─04cc37cd-ecf9-4dd5-b14d-4d4fe1f0992d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
