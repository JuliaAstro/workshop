### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 624bd571-c51e-4f52-848b-7cdefebbd42a
begin
	using Dates, PlutoUI, HypertextLiteral
	TableOfContents(title = "1-2: Arrays 1", depth = 4)
end

# ╔═╡ e984391b-0c01-4dc8-85aa-3593027e8530
"""
!!! note "1-2: Arrays 1"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 2675d602-810c-4320-971c-902c3327a5cb
md"""
# Multidimensional Arrays
In Julia, an array is a collection of objects stored in a multi-dimensional grid.

1. A 1D array is a Vector, i.e., as a single list or column of numbers.

2. A 2D array is a Matrix, i.e., rows and columns.

3. A 3D array is a cube of numbers, but of course one can keep going to 4D, 5D, or any number of dimensions.

We interact with these using square brackets `[]` for indexing, e.g., `A[2]` gets the second element of a vector. `M[2, 3]` gets the element at the second row, third column of a matrix.
"""

# ╔═╡ 346cb64d-3c89-44d1-9edb-06354152243a
md"""
# Matrix Protocol

Julia's arrays behave differently from arrays in languages like Python, C, or Java. Julia's design follows the conventions of mathematics and linear algebra, which has two major consequences.

1. 1-Based Indexing

   The first element of an array is at index 1.


   1. `my_vector[1]` is the first element.


   2. `my_matrix[1, 1]` is the top-left element.

   Python and C use 0-based indexing (where `my_array[0]` is the first element). This 1-based system may be more intuitive for mathematicians and scientists who are used to notation such as ``A_{ij}``, where $i$ and $j$ start at 1.


2. Column-Major Order

   This is one secret to Julia's performance. It describes how arrays are physically laid out in your computer's memory.


   1. Row-major order: Elements of a row are grouped together in memory. The computer stores [row1, row2, row3] (e.g., used by NumPy and C)


   2. Column-major order: Elements of a column are grouped together. The computer stores [col1, col2, col3]. (used by e.g., Julia, MATLAB, and FORTRAN)

Why does this matter? Accessing memory that is close together is typically much faster (due to CPU caching) than accessing memory that is spread out.

In Julia, this means that looping down a column, i.e., through the rows, is fast.

```julia-repl
julia> for j in 1:numCols
	for i in 1:numRows
		# Accessing memory sequentially is better, e.g.,
		A[i, j] ...
	end
end
```

!!! note
	`#` character begins a single comment, i.e., the comment string is between the `#` character and the newline character.

	`#=` and `=#` is a string block that can span multiple lines.
"""

# ╔═╡ 11832b60-4906-4d22-960b-0b16b6634011
md"""
# Array Creation

## Functions

You can create arrays with functions like `zeros(2, 3)` or `rand(3, 3)`, where the integers in parentheses specify the dimensions.

## Array Literals

For literal arrays, we use `[]` with two simple rules:

1. Commas (`,`) signify a 1D column Vector.
2. Spaces ( ) signify a 1D row Vector or a 1×N Matrix.

```julia-repl
julia> x = [1., 2., 3.]
3-element Vector{Float64}:
 1.0
 2.0
 3.0

julia> y = [1. 2. 3.]
1×3 Matrix{Float64}:
 1.0  2.0  3.0
```

## Semicolon Syntax

Semicolons (`;`) separate rows.

The four following examples show array creation:

1: A 1D Vector (using commas) produces a 3-element Vector{Int64}:

```julia-repl
julia> v = [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3
```

2: A 2D Matrix (using spaces for columns and semicolons for rows) produces a 2×3 Matrix{Int64}:

```julia-repl
julia> m = [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6
```

A 1x3 Row Vector (Matrix) produces a 1×3 Matrix{Int64}:
```julia-repl
julia> row_vec = [1 2 3]
1×3 Matrix{Int64}:
 1  2  3
```

A 3x1 Column Vector (Matrix) produces a 3×1 Matrix{Int64}:

```julia-repl
julia> col_vec = [1; 2; 3]
3-element Vector{Int64}:
 1
 2
 3
```

!!! note ""
	`[1, 2, 3]`, with commas, gives a 1D Vector, while `[1; 2; 3]`, with semicolons, gives a 2D, 3×1 Matrix. The 1D Vector is "dimensionless" and often acts like a column vector in math operations, which is very convenient.

## Array Elements

Array elements do not need to be homogeneous. They can be heterogeneous, meaning that they can have any type. For example:

```julia-repl
julia> a = [1, 2f0, "three", :four, nothing, missing]
4-element Vector{Any}:
 1
 2.0f0
  "three"
  :four
  nothing
  missing
```

!!! note
	The `nothing` value is of type `Nothing` and is synonymous with Python's `none` object. The `missing` value is of type `Missing` and means that the value is missing. Statistical functions will ignore the `missing` value during computations, unlike the `nothing` value, so the results will be statistically correct.
"""

# ╔═╡ 21190213-dc6e-4206-b516-338d5922b30e
md"""
# Tuple Creation

Like Python, Julia has Tuples. Tuples differ from arrays in two aspects:

1. A Tuple is **immutable**. That means that once created the values cannot be changed.
2. A Tuple is **one-dimensional**.
2. A Tuple is **non-allocating**. Therefore, they have better performance that Arrays.

## Tuple Literals

Literal tuples are create by using `()` (paratheses) whose elements are separated by '`,`' (commas). For example:

```julia-repl
julia> t = (1, 2., "three")
(1, 2.0, "three")

julia> typeof(t)
Tuple{Int64, Float64, String}
```

## NamedTuples

Julia also has a named tuple type. They are basically identical to Tuples, except that the elements can have names or labels by preceeding the value with a character or string and an '`=`' (equal sign). For example:

```julia-repl
julia> n = (a=1, b=2, c="three")
(a = 1, b = 2, c = "three")
```

There is also a syntatic variation the begins with '`(;`' (parenthesis - semi-colon).

```julia-repl
julia> n = (; a=1, b=2, c="three")
(a = 1, b = 2, c = "three")
```

Tuples and NamedTuples can also be created using the `Tuple` and `NamedTuple` types. See the help documents for details.
"""

# ╔═╡ d5268417-62f9-4fa8-beac-c4d4b9007223
md"""
# Broadcasting ( `.` Operator)

This is arguably the most important feature for clean, fast code using arrays or tuples.

## Arrays

What if you have a vector `A = [1, 2, 3]` and you want to add 1 to every element? Or what if you want to multiply every element in an array by its corresponding element in another array?

The `.` operator is a prefix operator that modifies the behavior of other operators such as `+` and `*`. It tells Julia to. perform an element-wise operation. The `.` operator is called the **broadcast** operator. As we will see in session 1-4, it applies to more than just arrays.

1. `A .+ 1` $\rightarrow$ `[2, 3, 4]`
2. `A .* B` means element-by-element multiplication.

## Tuples

The broadcast operator also applies to Tuples. For example:

```julia-repl
julia> (1, 2, 3) .+ (4, 5, 6)
(5, 7, 9)
```
"""

# ╔═╡ 8a5d4ccf-a3b2-4373-822d-dbf5254bf4b0
md"""

# Array Fusion

This is where the magic happens and the power of Juila. What happens if you chain multiple "dotted" operations?

```julia-repl
julia> A = rand(1000)
julia> B = rand(1000)
julia> C = rand(1000)
julia> D = A .* B .+ C
```
Let's compare how Python (sp., Numpy) and Julia compare.

In Python: `D = A * B + C`

1. Python first calculates `T = A * B`, where `T` is a temporary array to store the result of the multiplication.
2. It then calculates the final array `D = T + C`.
3. This took two passes over the data and allocated a temporary array `T` of N-elements, which is then discarded. Allocating memory, especially large amounts of memory (say ~ GBs) signifantly impacts performance and may result in the calculation returning an "Out of memory" error.

In Julia: `D = A .* B .+ C`

1. Julia sees the "chain of dots" and performs loop fusion.
2. It knows you want to do `D[i] = A[i] * B[i] + C[i]` for every element.
3. It compiles this down to a single, performant for-loop that elimanates the need for the temporary array `T`.

The above array expression is effectively:

```julia-repl
julia> # This is what Julia effectively runs:
julia> D = similar(A) # Allocate D *once*
julia> for i in 1:length(A)
	D[i] = A[i] * B[i] + C[i]
end
```

!!! note
	In Julia, the array expression can also benefit from vectorization or single-instruction-multiple-data (SIMD), where a single operation is simultaneously applied to multiple data. This will be discussed in more detail in session *2-4: Parallel-Computating*. It can also benefit from vector pipelining, where the multiply and add operations are performed simultaneously and in succession. That is, the multiplication operation is performed first on multiple values and the result is followed by the addition operation on multiple values. While the addition operation is being performed, the next multiplication operation is done, resulting in a multiplication-addition pipeline.
"""

# ╔═╡ 65151aba-d946-401d-8cca-1874f38146f2
md"""
# Matrix Multiplication ( `*` Operator)

We just learned that `A .* B` is the element-wise product.

So, how is matrix multiplication performed, as in linear algebra?

We use the asterisk (`*`) operator without the dot.
"""

# ╔═╡ 116911ed-cc32-41ea-a495-a3117815d669
md"""
```julia-repl
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> B = [5 6; 7 8]
2×2 Matrix{Int64}:
 5  6
 7  8
```

Element-wise multiplication

```julia-repl
julia> C = A .* B
2×2 Matrix{Int64}:
  5  12
 21  32
```

Matrix multiplication

```julia-repl
julia> D = A * B
2×2 Matrix{Int64}:
 19  22
 43  50
```
"""

# ╔═╡ 29e28885-d969-4e27-b5d3-866eb25302ab
md"""
# Summary

!!! note ""
	* `[...]` is the syntax for a literal `Array` comprehension.
	* `(...)` is the syntax for a literal `Tuple` comprehension.
	* `(...=..., ...=...)` is the syntax for a literal `NamedTuple` comprehension.
	* `.*` (dot): broadcast operator, i.e., use for element-wide operations.
	* `*` (no dot): matix operator, i,e., use for matrix multiplication.
"""

# ╔═╡ e26b69c9-d37d-449d-90d4-cdce4dff2362
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ e3b1c6c2-5631-42c0-9a1b-d5a5520466c8
md"""
## 1: Array Construction
!!! warning ""
	* Construct a Vector using an array literal with the values 1, 2, 3.
	* Construct a 3×3 matrix using an array literal with 1, 2, 3 in the first row.
	* Construct a 3×3 matrix using an array literal with 1, 2, 3 in the first column.
	* Construct a 3×3 matrix of interger zeros.
	  - Hint: Use `zeros()`.
	* Construct a 3×3 matrix of Float32 ones.
	* Construct a 3×3 matrix of UInt8 filled with the value 8.
	  - Hint: Use `fill()`.
	* Construct a 3×3×3 array of Float32 whose values are undefined.
	  - Hint: Use `Array()` and `undef`.
	  - Note: This array allocates memory, but does not initilize it, saving time.
"""

# ╔═╡ 30d5652d-605d-4119-b7e8-9cb8b93ce4a3
md"""
## 2: Tuples and NamedTuples

!!! warning ""
	* Construct a Tuple literal `x` of three integers.
	* Construct a Tuple literal `y` of three floats.
	* Multiply `x` times `y`.
	* Construct a Tuple literal containing an integer, a float, and a string.
	* Construct a NamedTuple literal with labels `a`, `b`, and `c` and integer, float, and string values.
"""

# ╔═╡ ff17e921-4522-4ab3-8282-9d9aafecdbe9
md"""
## 3: Broadcasting
!!! warning ""
	* Construct a 1D vector `x` containing five evenly spaced points from 0 to $\pi$, inclusive.
	  - Hint: Use `range()`.
	  - Note: `π` is a built-in constant.
	* Construct a 1D vector `y` containing five random values between 1 and 10.
	  - Hint: use `rand()`.
	* Multiply element-wise `x` and `y`.
	* Construct a third 1D vector `z` containing five values.
	* Evaluate the expression $x + y * z$
"""

# ╔═╡ e022f21e-7f18-4690-99d4-0141403b3b38
md"""
## 4: Matrix Math vs. Element-wise Math
!!! warning ""
	* Create two 2×2 matrices:
	   - `X = [1 2; 3 4]`
	   - `Y = [2 0; 0 2] # This is a scaling matrix.`
	* Perform matrix multiplication on `X` and `Y`.
	* Perform element-wise multiplication on `X` and `Y`.
	* Are the results the same?
"""

# ╔═╡ 1416a80e-dbda-4185-8984-7f5de3c58f02
md"""
## 5: Array Fusion
!!! warning ""
	* Create three 1D vectors, `a`, `b`, and `c`, each of length 4.
	* Using a single, "fused" broadcast expression, calculate $(a^2 + b)/c$.
	  - Note: `^` (carat) is the exponentiation operator.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.76"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.3"
manifest_format = "2.0"
project_hash = "130913124ee09826a81b0c1a5e4b6a1abdfbdfa9"

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
# ╟─e984391b-0c01-4dc8-85aa-3593027e8530
# ╟─2675d602-810c-4320-971c-902c3327a5cb
# ╟─346cb64d-3c89-44d1-9edb-06354152243a
# ╟─11832b60-4906-4d22-960b-0b16b6634011
# ╟─21190213-dc6e-4206-b516-338d5922b30e
# ╟─d5268417-62f9-4fa8-beac-c4d4b9007223
# ╟─8a5d4ccf-a3b2-4373-822d-dbf5254bf4b0
# ╟─65151aba-d946-401d-8cca-1874f38146f2
# ╟─116911ed-cc32-41ea-a495-a3117815d669
# ╟─29e28885-d969-4e27-b5d3-866eb25302ab
# ╟─e26b69c9-d37d-449d-90d4-cdce4dff2362
# ╟─e3b1c6c2-5631-42c0-9a1b-d5a5520466c8
# ╟─30d5652d-605d-4119-b7e8-9cb8b93ce4a3
# ╟─ff17e921-4522-4ab3-8282-9d9aafecdbe9
# ╟─e022f21e-7f18-4690-99d4-0141403b3b38
# ╟─1416a80e-dbda-4185-8984-7f5de3c58f02
# ╟─624bd571-c51e-4f52-848b-7cdefebbd42a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
