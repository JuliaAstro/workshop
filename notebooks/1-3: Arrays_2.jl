### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 157fdc89-ff6f-4e6c-99b0-fc952daa24ef
begin
	using Markdown, Dates, PlutoUI, InteractiveUtils
	TableOfContents(title = "1-3: Arrays 2", depth = 4)
end

# ╔═╡ d046592d-9786-4675-b8bd-26848fcb6a50
"""
!!! note "1-3: Arrays 2"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 5c45b5c1-d4c7-40e5-b765-9917078b715f
md"""
# Slice Operator

The slice operators are `b:e` and `b:s:e`, where `b`, `s`, and `e` are the beginning, step, and ending values. The step (or three value) variation differs slightly from the Python syntax of `b:e:s`.

!!! note
	Originally, Python did not have the three value slice operator. It only had the two value operator. Therefore, when the three value operator was added, it was made to be backward compatible with the two value version.

The slice operator is also an **iterator** and can be used to generate an array of values. It does not generate the array until a value is requested. For example:

```julia-repl
julia> 1:2:10
1:2:9
```
!!! note
	The slice operator calculates the begin and end values, but does not generate an array. It just returns itself. This behavior means that a value is only created or returned when needed.
"""

# ╔═╡ 2788d2f9-a6b9-4169-85c9-014e5dd565bc
md"""
# Array and Tuple Comprehensions

In Julia, much like in Python, you can use **comprehensions** to create arrays. The syntax is borrowed from set-builder notation in mathematics, where you can define new sets from existing ones, e.g.:
```math
E = \{2n \mid n ∈ \mathbb{Z} \},
```
where ``\mathbb{Z}`` is the set of all integers, and so ``E`` is the set of all even numbers.

In Julia, the comprehension syntax is similar to Python
```julia-repl
julia> [... for x in myarray]
```
or
```julia-repl
julia> [... for x=myarray]
```
For example,
```julia-repl
julia> [x^2 for x in 1:10]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```
where `x_arr` doesn't necessarily have to be an array itself, it can be any iterable object, such as a Tuple or Slice (i.e., `1:2:10`).

Or,

```julia-repl
julia> Tuple(2n for n=1:10)
(2, 4, 6, 8, 10, 12, 14, 16, 18, 20)
```

Array comprehensions can contained multiple and nested `for` loops.

A multiple `for` loop with a ',' will create a multi-dimensional array:

```julia-repl
julia> [(j, k) for j=1:2, k=1:4]
2×4 Matrix{Tuple{Int64, Int64}}:
 (1, 1)  (1, 2)  (1, 3)  (1, 4)
 (2, 1)  (2, 2)  (2, 3)  (2, 4)
```

And a nested `for` loop without a ',' will create a one dimensional array:

```julia-repl
julia> [(j, k) for j=1:2 for k=1:4]
8-element Vector{Tuple{Int64, Int64}}:
 (1, 1)
 (1, 2)
 (1, 3)
 (1, 4)
 (2, 1)
 (2, 2)
 (2, 3)
 (2, 4)
```

There ia also Tuple comprehension. Its syntax is similar to the array comprehension, except the `[]` is replaced by Tuple(). And, of course, they are limited to one dimension.

```julia-repl
julia> Tuple((j, k) for j=1:2 for k=1:4)
((1, 1), (1, 2), (1, 3), (1, 4), (2, 1), (2, 2), (2, 3), (2, 4))
```
"""

# ╔═╡ 7a634fe5-2a4e-4abd-90c8-5a4da31bba1e
md"""
# Comprehensions and `if`

We can also filter out elements by using a conditional after the statement part. The following two examples calculates the squares of the even and odd numbers respectively from 1 to 10:

```julia-repl
julia> [x^2 for x in 1:10 if x%2 == 0]
[4, 16, 36, 64, 100]
```

and

```julia-repl
julia> [x^2 for x=1:10 if isodd(x)]
[1, 9, 25, 49, 81]
```

Of course, this syntax also applies to Tuples.

The built-in `filter()` function is also an option.
"""

# ╔═╡ bfa7975e-f206-4179-93eb-e0236855c981
md"""
# Array Indexing and Slicing

Indexing an array is similar to Python array syntax, e.g.,

```julia-repl
julia> A = [1 2 3 4; 5 6 7 8]
2×4 Matrix{Int64}:
 1  2  3  4
 5  6  7  8

julia> A[1,3]
3
```

The slice operator can be used to create subarrays of an equal or larger array. A colon by itself can be used as a shortcut for all indices of a dimension. The `end` word can be used into indicate the last index of an array dimension. It must be used if the beginning and step values are given. The ending index cannot be larger than largest index of a dimension. Otherwise, there will be an error.

```julia-repl
julia> A[1,1:3]
3-element Vector{Int64}:
 1
 2
 3

julia> A[:,1:2:end]
2×2 Matrix{Int64}:
 1  3
 5  7
```

A multiple dimensional array can be treated as a flattened or one dimensional array by using a single slice operator, e.g.:

```julia-repl
julia> A[1:2:end]
4-element Vector{Int64}:
 1
 2
 3
 4
```

!!! note
	In the previous example, one iterates down the column first, then the row.
"""

# ╔═╡ d1e8e027-ce75-4cee-bbbd-f977e7c4d442
md"""
# Array Masking Using a Boolean Array

In addition to slicing arrays, subarrays can be created using boolean arrays. For example, a subarray of all values between 6 and 10 can be created by using comparison operators.

```julia-repl
julia> B = collect(1:20);

julia> B[6 .<= B .<= 10]
9-element Vector{Int64}:
  6
  7
  8
  9
 10
```

!!! note
	Comparison operators can be chained, i.e., they do not need to be separated by a boolean operator.
"""

# ╔═╡ b59e0ee5-2496-4b7c-a6b0-a06f1ebada24
md"""
# Summary

!!! info ""
	* Arrays and Tuples can be created by embedding a `for` loop within brackets or parentheses. This is called an array or tuple comprehension.
	* comprehensions can include an if statement.
	* Comprehensions can contain nested `for` loops.
	* Subarrays can be created by using the slice operator or a boolean array.
"""

# ╔═╡ 68240605-d3c1-4ba0-b938-a1785d466456
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ bc42e1cf-8d18-4a4f-a392-81b876c7a525
md"""
## 1: Slicing

!!! warning ""
	* Construct a 5×5 matrix of sequential values starting at 1.
	  - Hint: use `reshape()`.
	* Extract the value at column 1 and row 1.
	* Extract the value at column 5 and row 5.
	* Extract the first column.
	  - Hint: the `:` operator by itself defaults to beginning and end indices.
	* Extract the first row.
	* Extract the lower 3×3 subarray.
	  - Hint: use the `end` index.
	* Extract the odd indices from the first row.
	* Extract the odd indices from the first column and row.
"""

# ╔═╡ 79808bf9-eec0-44b2-be4d-f6eadb8b2b1c
md"""
## 2: Array Comprehensions

!!! warning ""
	* Construct a vector of ten even values using an array comprehension.
	* Construct a 5×5 matrix of odd values using an array comprehension.
	* Construct a vector of `String`s of length 10.
	* Construct a vector of `Int16`s of length 10.
	* Construct a vector of `Tuple`s from the two vectors, where the first Tuple contains the value of the element at index 1 from each vector.
	  - Hint: use `zip()`
"""

# ╔═╡ 6389805e-f9a1-49ad-a95f-d7878bcfc1ca
md"""
## 3: Bit Mask

!!! warning ""
	* Construct a random vector of length 20.
	* Extract the values between 0.4 and 0.6.
	  - Hint: use a comparision expression.
"""

# ╔═╡ 90b215d2-733e-4a7c-a9f6-f2d3c6ef3cd5
md"""
## 4. Identity Matrix

!!! warning ""
	* Construct a 10×10 identity matrix I1 using nested `for`-loops, i.e., without using a comma.
      - Hint: use the tertiary operator: ` <comparison> ? <true value> : <false 
	  - Hint: use `reshape()` to convert a 1D array to a 2D array.
	* Get the size of I1 in bytes.
	  - Hint: use `sizeof()`.
	* Construct a 10×10 identity matrix I2 using multiple `for`-loops, i.e., with using a comma.
	* Get the size of I2 in bytes.
	* Add the LinearAlgebra package.
	* Construct a 10x10 identity matrix I2 using the LinearAlgebra package.
	* Get the size of I2 in bytes.
	* Why might the identity matrices be different in size?	
"""

# ╔═╡ cee1d2fd-cea3-4fbf-bdd6-1d0286f84f69
md"""
## 5. Cartesian indexing
!!! warning ""
	* Construct a 2×2×2×2 matrix with values from 1 to 16.
	* Use a `CartensianIndex` to extract the value at 1, 1, 1, 1.
	* Use a `CartensianIndex` to extract the value at 1, 1, 1, 2.
	* Use a `CartensianIndex` to extract the value at 1:2, 2, 2, 2.
	  - Hint: slicing and `CartesianIndex`s can be used together.
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
# ╟─d046592d-9786-4675-b8bd-26848fcb6a50
# ╟─5c45b5c1-d4c7-40e5-b765-9917078b715f
# ╟─2788d2f9-a6b9-4169-85c9-014e5dd565bc
# ╟─7a634fe5-2a4e-4abd-90c8-5a4da31bba1e
# ╟─bfa7975e-f206-4179-93eb-e0236855c981
# ╟─d1e8e027-ce75-4cee-bbbd-f977e7c4d442
# ╟─b59e0ee5-2496-4b7c-a6b0-a06f1ebada24
# ╟─68240605-d3c1-4ba0-b938-a1785d466456
# ╟─bc42e1cf-8d18-4a4f-a392-81b876c7a525
# ╟─79808bf9-eec0-44b2-be4d-f6eadb8b2b1c
# ╟─6389805e-f9a1-49ad-a95f-d7878bcfc1ca
# ╟─90b215d2-733e-4a7c-a9f6-f2d3c6ef3cd5
# ╟─cee1d2fd-cea3-4fbf-bdd6-1d0286f84f69
# ╟─157fdc89-ff6f-4e6c-99b0-fc952daa24ef
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
