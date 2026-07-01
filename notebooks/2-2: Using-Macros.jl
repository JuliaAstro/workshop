### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 39182b4b-a7a8-4a37-b543-121f744d5d65
begin
	using Dates, PlutoUI, HypertextLiteral
	TableOfContents(title = "2-2: Using Macros", depth = 4)
end

# ╔═╡ 7c6e05a0-b0e4-4278-bb1a-e9316469d3ce
"""
!!! note "2-2: Using Macros"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 61ba1a79-3f3f-4d4f-a43e-e3d8883787e8
md"""
# Why Macros

Unlike other interactive languages, such as Matlab, Python, and R, Julia has macros. They are a very powerful programming construct. Macros modify existing source code or generate entirely new code. In essence, **they simplify programming by automating mundane coding tasks.**

Preprocessor "macro" systems, like that of C/C++, work at the source code level by perform textual manipulation and substitution before any parsing or interpretation is done. For example the following C/C++ macro expression tells the compiler to insert the code between the `#if` and `#endif` statements when `NAME` is defined.

```
#if defined(NAME) ... #endif
```

Whereas, Julia macros work at the level of the abstract syntax tree after parsing, but before compilation is done.
"""

# ╔═╡ 2b1abe2e-fc7a-4d3a-9f65-b820eaff70ea
md"""
# The Abstract Syntax Tree

Nearly all computer languages use an abstract syntax tree (AST) to parse the syntax of the language. In other words, the strings of characters that humans can read must be converted to a language that computers can read. The following snippet of Julia code represents how that is performed. The first line creates a string expression. The second line parses that expression, the third line prints the type of the parsed expression, namely an `Expr` type, and the fourth line prints the AST.

The `Meta.parse` statement in line 2 converts the mathematical expression in line 1 into an AST.

```julia-repl
julia> str1 = "3 * 4 + 5"
"3 * 4 + 5"

julia> ex1 = Meta.parse(str1)
:(3 * 4 + 5)

julia> typeof(ex1)
Expr
```

Let's dump or print the AST of the above expression.

```julia-repl
julia> dump(ex1)
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol *
        2: Int64 3
        3: Int64 4
    3: Int64 5
```

The `Expr` type has two fields, a `head` and an `args`. The `head` declares the item is a function `call` of type `Symbol` and the `args` is an `Array` of function arguments, namely the `+` operator of type `Symbol` and the two values to be added. The first value is another `Expr` type and the second is a 64-bit integer. The second nested `Expr` is also composed of a `Symbol` call. Its arguments are the multiplication `*` operation of type `Symbol` and two 64-bit integers. Note that the multiplication operation is nested in the addition operation, since multiplication has precedence over addition.

Note that the expression `ex1` can be written directly in AST syntax.

```julia-repl
julia> ex2 = Expr(:call, :+, Expr(:call, :*, 3, 4), 5)
:(3 * 4 + 5)

julia> dump(ex2)
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol *
        2: Int64 3
        3: Int64 4
    3: Int64 5
julia> ex1 == ex2
true
```
!!! note
    If you prefer writing code as an AST, you can do so in Julia.

    However, you may not be popular with other coders.
"""

# ╔═╡ bc66ff75-77ce-4487-ab2e-72800331839b
md"""
# The `:` Operator

The `:` character has two syntatic purposes in Julia. It defines a `Symbol` or a `Quote`.

## Symbols

A `Symbol` is an interned string used as a building-block of an expression.

```julia-repl
julia> sym = :foo
:foo

julia> typeof(sym)
Symbol

julia> sym == Symbol("foo")
true
```

The `Symbol` constructor takes a variable number of arguments and concatenates them together to create a `Symbol` string.

```julia-repl
julia> Symbol("func", 10)
:func10
```

In the context of expressions, symbols are used to indicate access to variables. When an expression is evaluated, a symbol is replaced with the value bound to that symbol in the appropriate scope.

## Quoting

The second purpose of the `:` character is to create expression objects without using the explicit `Expr` constructor. This is referred to as *quoting*.

```julia-repl
julia> ex3 = :(3 * 4 + 5)
:(3 * 4 + 5)

julia> dump(ex3)
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol *
        2: Int64 3
        3: Int64 4
    3: Int64 5

julia> ex1 == ex2 == ex3
true
```

So, there are three ways to construct an expression allowing the programmer to use whichever one is most convenient.

There is a second syntatic form of quoting, called a `quote` block (i.e. `quote ... end`), that is commonly used for multiple expressions. For example:

```julia-repl
julia> ex4 = quote
    x = 1
    y = 2
    x + y
end
quote
    #= REPL[78]:2 =#
    x = 1
    #= REPL[78]:3 =#
    y = 2
    #= REPL[78]:4 =#
    x + y
end

julia> typeof(ex4)
Expr
```

## Interpolation

Julia allows **interpolation** of literals or expressions into quoted expressions by prefixing a variable with the `$` character. For example:

```julia-repl
julia> a = 1;
julia> ex5 = :($a + b)
:(1 + b)
julia> dump(ex5)
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Int64 1
    3: Symbol b
```

Splatting is also possible.

```julia-repl
julia> args = [:x, :y, :x];
julia> dump(:(f(1, $(args...))))
Expr
  head: Symbol call
  args: Array{Any}((5,))
    1: Symbol f
    2: Int64 1
    3: Symbol x
    4: Symbol y
    5: Symbol x
```

## Expression evaluation

Julia will evalution an expression in the global scope using `eval`.

```julia-repl
julia> eval(ex1)
17
```

!!! note
	Unlike Python, the use of `eval` in Julia is strongly discouraged.
"""

# ╔═╡ 3be5ecc9-58cf-457a-a5d4-c9ff6114ba01
md"""
# Using Macros

## Creation

Defining a macro is like defining a function. For example,

```julia-repl
julia> macro sayhello(name)
    return :( println("Hello", $name))
end
@sayhello (macro with 1 method)
```

Now invoke the `@sayhello` macro.

```julia-repl
julia> @sayhello("world")
Helloworld
```

Parentheses around the arguments are optional.

```julia-repl
julia> @sayhello "world"
Helloworld
```

!!! note
    When using the parenthesized form, there should be no space between the macro name and the parentheses. Otherwise the argument list will be interpreted as a single argument containing a Tuple.

## Usage

Macros can be used for many tasks such as performing operations on blocks of code, such as timing expressions (`@time`), threading `for` loops (`@threads`), and converting expressions to broadcast form (`@.`). Another use is to generate code. When a significant amount of repetitive boilerplate code is required, it is common to generate it programmatically to avoid redundancy.

Consider the following example.

```julia-repl
julia> struct MyNumber
    x::Float64
end
```

We want to add a various methods to it. This can be done programmatically using a `for` loop.

```julia-repl
julia> length(methods(sin))
14

julia> for op = (:sin, :tan, :log, :exp)
    eval(quote
        Base.$op(a::MyNumber) = MyNumber($op(a.x))
	end)
end

julia> length(methods(sin))
15
```

A slightly shorter version of the above code generator that use the `:` prefix is:

```julia-repl
julia> for op = (:sin, :cos, :tan, :log, :exp)
    eval(:(Base.$op(a::MyNumber) = MyNumber($op(a.x))))
end
```

An even shorter version of the code uses the `@eval` macro.

```julia-repl
julia> for op = (:sin, :cos, :tan, :log, :exp)
    @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
end
```

For longer blocks of generated code, the `@eval` macro can proceed a code `block`:

```julia-repl
julia> @eval begin
    # multiple lines
end
```
"""

# ╔═╡ 8eca8d1b-9077-4f56-a9ef-b901ff5844a9
md"""
# Summary
!!! note ""
    * Macros simplify program development.
    * 
"""

# ╔═╡ 23fcb211-8b7e-404e-9847-cc57f5aa2cd6
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ 58b86c26-d8ba-404d-bc1e-9f8a21de2e38
md"""
## 1: 
!!! warning ""
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
# ╟─7c6e05a0-b0e4-4278-bb1a-e9316469d3ce
# ╟─61ba1a79-3f3f-4d4f-a43e-e3d8883787e8
# ╟─2b1abe2e-fc7a-4d3a-9f65-b820eaff70ea
# ╟─bc66ff75-77ce-4487-ab2e-72800331839b
# ╟─3be5ecc9-58cf-457a-a5d4-c9ff6114ba01
# ╟─8eca8d1b-9077-4f56-a9ef-b901ff5844a9
# ╟─23fcb211-8b7e-404e-9847-cc57f5aa2cd6
# ╠═58b86c26-d8ba-404d-bc1e-9f8a21de2e38
# ╟─39182b4b-a7a8-4a37-b543-121f744d5d65
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
