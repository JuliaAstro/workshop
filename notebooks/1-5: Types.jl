### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ d5c060c2-f0eb-4829-baa2-abf595983adf
begin
	using Markdown, Dates, PlutoUI
	TableOfContents(title = "1-5: Types"; depth = 4)
end

# ╔═╡ 520278e3-1521-438a-bdbd-088956a4cc42
"""
!!! note "1-5: Types"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ c8a117d7-790b-433f-9993-9e2f09357b25
md"""
# Type Declarations

Similar to Python, Julia will infer the type of a variable based on its value. For example, `1.0` is a 64-bit floating pointing value (of type Float64), `"hello!"` is a string (of type String), and `[1, 2, 3]` is a one-dimensional integer array (of type Vector{Int64}). If Julia cannot infer the type, then it will be assigned a type of `Any`.

In many cases, such as simple data analysis, letting Julia infer the type is fine. However, in cases where high performance is needed, such as the analysis of large datasets or complex numerical simulations, using type annotations is preferable, because it ensures that the compiler has sufficient information to know the types of all variables and therefore, generate highly optimized machine code.

To annotate a variable, the `::` operator is appended to the variable or function. For example, `a::Int32` or `myfunc()::Float32`.
"""

# ╔═╡ 33a3c28c-7b98-4fa9-8603-d9f8848a523b
md"""
# Type Hierarchy

Julia uses a type hierarchy that defines the relations between different types.

* For example, the `Signed` type has the **subtypes**: `Int8`, `Int16`, Int32`, Int64`, `Int128`, and `BigInt`.
* Alternatively, the `Signed` type is the **supertype** of `Int8`, `Int16`, `Int32`, ...

Julia's type hierarchy is similar to the concept of inheritance in object-oriented (OO) languages. However, it is only associated with types, not with methods or functions of an OO language.
"""

# ╔═╡ 97ba81c9-bb21-4cb6-94a8-99f52e6535ca
md"""
# The Types

Julia has various classes of types, namely:

## Concrete
* Are types that can be instantiated or created.
* Concrete types cannot have subtypes.
* E.g., `Float64`, `Int32`

## Non-concrete
* Are types that cannot be instantiated.
* E.g., `Integer`, `AbstractArray`

---

## Primitive
* Are associated with the machine type (e.g., CPU or GPU).
* Are concrete types.
* E.g., `Int32`, `Int64`, `Float32`, `Float64`, ...

## Abstract
* Are nodes in a graph.
* Are supertypes.
* Are non-concrete types.
* E.g., `Integer`, `AbstractFloat`, `AbstractArray`, ...

## Parametric
* Are qualified types.
* Can be concrete types.
* E.g., `Vector{Int32}`, `Array{Int64, 3}`, `MyType{Float32}`, ...

## Composite
* Are heterogeneous types.
* Are called records, structs, or objects in various languages.
* Are concrete types.
* The fields can be annotated.
* Can be parametric types.
* E.g.,
```julia
	struct Foo
		bar
		baz::Int
		qux::Float64
	end
```

Or

```julia
	struct Bar{R} where R<:Real
		barb::R
		bazb::R
		qux::String
```

## Singleton
* Are types with only one instance.
* Are Composite types with no fields.
* Are concrete types.
* E.g., `Nothing`, `Missing`

## Union
* Are unions of types.
* Are non-concrete types.
* E.g., `Union{Integer, Nothing}`

!!! note
	The Julia protocol is to capitalize at least the first letter of a type. This signals to the user that you are using a type and not a variable or function, which typically begin with a lower case letter.
"""

# ╔═╡ 34e00674-489b-48b2-b770-39112edd1e89
md"""
# Type Comparisons

The `<:` or `>:` operators are subtype operators. They return a boolean value when comparing two types. For example, `SubType <: SuperType`.

The related `isa` operator returns a boolean value when value `x` is of type `T`. For example, `isa(1, Int)` or `1 isa Int`.
"""

# ╔═╡ b344fb14-7a78-4893-ae10-bc8d8026fc63
md"""
# Summary

!!! note
	* Julia has a type hierarchy that defines the relationship between various types.
    * Types can have a supertype and subtypes.
    * Abstract types cannot be instantiated.
    * Primitive types can be instantiated.
    * Primitive types are at the bottom of the hierarchy.
	  - I.e., they have a supertype, but no subtypes.
    * Composite types are structs or a group of related types.
    * Types can have parameters.
"""

# ╔═╡ 444a233a-6815-43ce-a9f9-340ccbc7cb65
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ 6d5283e1-cbc8-49c2-a8ff-79e0df888483
md"""
## 1: Subtypes

!!! warning ""
    * Show the subtypes of the Integer abstract type.
	  - Hint: use `subtypes(Integer)`.
    * Show the subtypes of the `AbstractFloat` abstract type.
    * Show the subtypes of the `Real` abstract type.
    * Show the subtypes of the `Float32` primitive type.
    * Where is it on the type hierarchy?
"""

# ╔═╡ 5866c023-3dec-4d4c-926d-cc046de788b5
md"""
## 2: Supertypes

!!! warning ""
    * Show the supertype for `Real`.
    * Show the supertype for `Number`.
    * Show **all** the supertypes of `Float32`.
      - Hint: `supertypes(Float32)`
    * Show the supertype for `Any`.
	* Where is `Any` in the type graph?
"""

# ╔═╡ 58c3b29a-a9a1-4a71-b8ac-adb7a52fa4ed
md"""
## 3: Parametric Types

!!! warning ""
	* Create an array of integers.
	* What type is it?
	  - Hint: typeof(A)
	* Create an array of floats.
	* What type is it?
    * Create a vector of vectors of integers.
    * What type is it?
"""

# ╔═╡ 2283876d-1b7b-44c5-ab80-cab5853d8b94
md"""
## 4: Composite Types

!!! warning ""
    * Create a 1D array or vector
    * Show its type, i.e., `typeof(vector)`.
      - Note: What kind of type is it?
	* Create a composite type,
      - Hint: `struct AType; a::Integer; b::String; end`

    * Instantiate it.
	  - Hint: `AType(2, "abc")`.
"""

# ╔═╡ b1e6e265-c1c9-4618-b40d-71bad13a6395
md"""
## 5: Type Comparisons

!!! warning ""
	* Test if `1` is an `Integer` type.
	  - Hint: Use the `isa` operator.
	* Test if `1` is a `Signed` type.
	* Test if `1` is an `AbstractFloat` type.
	* Test if `1` is a `Real` type.
	* Test if `1.0` is a `Float64` type.
	* Test if `1f0` is a `Float64` type.
	  - What is `1f0`?
	* Test if `Int32` is a `Signed` type.
	  - Hint: Use the `<:` operator.
	* Test if `UInt64` is a `Signed` type.
	* Test if `1` is a `Signed` type without using the `isa` operator.
	  - Hint: Use the `typeof()` function.
	* Test if `[1, 2, 3]` is a `Vector` type.
	* Test if `[1, 2, 3]` is a `Matrix` type.
	* Test if `[1, 2, 3]` is an `AbstractArray` type.
	* Test if `[1.0, 2.0, 3.0]` is a `Vector{Float64}` type.
	* Test if `[1f0, 2f0, 3f0]` is a `Vector{Float64}` type.
	* Test if `[1f0, 2f0, 3f0]` is a `Vector{Float32}` type.
	* Test if `[1f0, 2f0, 3f0]` is a `Vector{<:AbstractFloat}`
"""

# ╔═╡ 847fd889-a8da-4a9c-829d-b899e8446d82
md"""
## 6: Union Types
!!! warning ""
	* Create a `Union` type using an `Integer` and a `Nothing`.
	* Test if `nothing` is a subtype.
	* Test if `1` is a subtype.
	* What is the use of a `Union` type?
"""

# ╔═╡ fb929ac1-0188-4b34-be96-7fadc4472748
md"""
## 7: Singleton Types
!!! warning ""
	* Create a single type.
      - Hint: How many fields does it have?
	* Test if the type is a singleton type.
	  - Hint: Use `Base.issingletontype()`.
"""

# ╔═╡ 764895cc-7448-488f-9c88-500d1f31e728
md"""
## 8: Abstract Types
!!! warning ""
	* Create an abstract type.
	  - Hint: Use the `abstract type` statement.
	* Instantiate the abstract type.
    * Why can't it be instantiated?
	* How would an abstract type be used?
"""

# ╔═╡ bce6847a-0d49-455d-b606-0c52c65e3d6d
md"""
----
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
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
project_hash = "52b7e4660a82c14cd89f38eee88f04ec557ef0a4"

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
# ╟─520278e3-1521-438a-bdbd-088956a4cc42
# ╟─c8a117d7-790b-433f-9993-9e2f09357b25
# ╟─33a3c28c-7b98-4fa9-8603-d9f8848a523b
# ╟─97ba81c9-bb21-4cb6-94a8-99f52e6535ca
# ╟─34e00674-489b-48b2-b770-39112edd1e89
# ╟─b344fb14-7a78-4893-ae10-bc8d8026fc63
# ╟─444a233a-6815-43ce-a9f9-340ccbc7cb65
# ╟─6d5283e1-cbc8-49c2-a8ff-79e0df888483
# ╟─5866c023-3dec-4d4c-926d-cc046de788b5
# ╟─58c3b29a-a9a1-4a71-b8ac-adb7a52fa4ed
# ╟─2283876d-1b7b-44c5-ab80-cab5853d8b94
# ╟─b1e6e265-c1c9-4618-b40d-71bad13a6395
# ╟─847fd889-a8da-4a9c-829d-b899e8446d82
# ╟─fb929ac1-0188-4b34-be96-7fadc4472748
# ╟─764895cc-7448-488f-9c88-500d1f31e728
# ╟─bce6847a-0d49-455d-b606-0c52c65e3d6d
# ╟─d5c060c2-f0eb-4829-baa2-abf595983adf
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
