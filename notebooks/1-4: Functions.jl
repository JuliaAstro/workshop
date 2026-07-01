### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 83ab9733-5969-4d0c-a3c0-b8f4d2402fde
begin
	using Dates, PlutoUI, HypertextLiteral
	TableOfContents(title = "1-4: Functions", depth = 4)
end

# ╔═╡ afe988c7-c708-4fdb-bf82-54edeb9db708
"""
!!! note "1-4: Functions"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ c78da21b-40ad-42d1-8516-b91d16982c77
md"""
# Functions in Julia

Introduction to the contruction of Julia functions and their implementation by Julia.

If you come from Python or Java, functions are attached to classes. In Julia, functions are standalone citizens, and they define the behavior of the language. We will cover the syntax, the argument system, and introduce a key Julia feature: **multiple dispatch**.
"""

# ╔═╡ c74cace1-0e96-48e7-82d3-12f3af3d8591
md"""
# Defining Functions

Julia offers three syntactic ways to define a function. They all compile down to the same code, so choose the syntax that is most convenient or appropriate.

## Default Syntax

The standard multi-line version looks similar to other languages. It uses the `function` statement and closes with the `end` statement.

```julia-repl
julia> function hypotenuse(a, b)
    result = sqrt(a^2 + b^2)
    return result
end
```

!!! note
    * Julia does not use indentation to define code blocks. It is used for readability.


	* Julia automatically returns the result of the last expression. Therefore, the `return` statement is optional for the last line of a function.

## Single-Line Syntax

The single-line assignment form may be unique to Julia and is perfect for short operations. While functionally identical to the multiline version, it reduces visual clutter for simple logic.

```julia-repl
julia> hypotenuse(a, b) = sqrt(a^2 + b^2)
```

!!! note
    The compiler will automatically inline functions to improve performance, unlike C or Python. Therefore, there is no performance hit by using functions and their use is encouraged for convenience and readability.

## Anonymous Functions (Lambdas)

An anonymous function uses the arrow syntax: `->`. The variables before the `->` are the arguments to be used and the expression afterward is the function body. They are often used in functional programming contexts such as `map`, `filter` or `findall` to define a filter.

```julia-repl
julia> # Equivalent to Python's: lambda x: x^2 + 2x - 1
julia> f = x -> x^2 + 2x - 1

julia> # Usage in a map function
julia> map(x -> x^2, [1, 2, 3])

julia> # Two arrays zipped together returning a Tuple with two values.
julia> map(((x, y),) -> x > 2 && y > 4, zip(1:5, 2:6))
```
"""

# ╔═╡ 70b70576-0c49-4e5b-b7c1-dd400f3fbcca
md"""
# Function Arguments

## Positional and Keyword

Functions have two types of arguments, positional and keyword. They are separated using a '`;`' (semi-colon). Positional arguments are required, whereas keyword arguments are optional. The next section will show the importance of positional arguments.

```julia-repl
julia> # a and b are positional, while scale and offset are keywords
julia> function transform(a, b; scale=1.0, offset=0.0)
    return (a + b) * scale + offset
end

julia> # Usage
julia> transform(10, 20; scale=2.0)
```

## Default Values and Methods

Positional arguments can have default values, which means the default value will be used if the argument is missing.

```julia-repl
julia> # This function defines a default value for the y.
julia> myfunc(x, y=10) = x * y
```

Julia creates two versions or methods of this function, one with two arguments and one with one argument.

```julia-repl
julia> myfunc(x, y)
julia> myfunc(x)    # The 2nd positional argument will have the value 10.
```
"""

# ╔═╡ 12928360-90aa-4409-860a-af7f5c781e98
md"""
# Multiple Dispatch

!!! note "The most important part and a core reason for Julia's existence."

## Single Dispatch

Object-oriented languages such as Python and Java use single dispatch for choosing the function or method to execute. That means that the function is determined using the function name and the type of the first argument. This is called **single dispatch**. Therefore, the functions or methods are tightly bound to the object or class. When you call `obj.method(arg)`, the language transforms that expression into `method(obj, arg)`.

Single dispatch creates the **Expression Problem**. For example, `a + b` calls `a.__add__(b)` in Python. If the object `a` is known, but not `b`, there is no problem; the `__add__` function can still be called. However, if `a` is unknown, what do we do now? In Python this problem is solved by the `__radd__` function. Python will try `__add__`, if that fails, then it will try `__radd__`. Therefore, when we add an `__add__` operator to a new class in Python, the new class must implement the `__radd__` method too, because other classes do not know about our new classs. 

## Multiple Dispatch

Julia is not an object-oriented language. It is functional language. When you call `func(arg1, arg2)`, Julia looks at the types of the function's positional arguments to determine the version of the function to execute. This is called **multiple dispatch**. Julia will look at the argument types of all positional arguments, i.e., `arg1` and `arg2`, and choose the function that has that exact type signature. Multiple dispatch makes it easier for a new Julia type to extend the functional interface of another type.

The example below illustrates that situation. Two `fAdd` functions are implemented, one for each situation. Julia then determines which version of that function to execute. The situation is similar to Python's `__add__` and `__radd__`, except that Python first tries to use `__add__` and when that fails, tries `__radd__`. Whereas, Julia just chooses the correct function the first time. The following is an example of how Julia may implement this situation.

```julia-repl
julia> # Define additon for an integer and a float, and the other way around:
julia> fAdd(a::Int, b::Float64) = a + b
julia> fAdd(a::Float64, b::Int) = a + b
```

Why is this powerful?

1. Symmetry: You don't need __radd__ because compared with (a::Float, b::Int), (a::Int, b::Float) is just a different method.

2. Extensibility: If you import a library that defines a `Planet` type, and another library that defines a `Satellite` type, you can define a `collide(p::Planet, s::Satellite)` function in your own code without modifying the source code of either library.

3. Trying to add two integers or two floating points fails, e.g., "ERROR: MethodError: no method matching fAdd(::Float64, ::Float64)."  If you know, for example, that a particular function is only supposed to be called with an integer and a float, and you don't want to worry about the order, you now have a check on your code.
"""

# ╔═╡ d8ba51b9-2d28-4d97-8704-c56c44e04a62
md"""
!!! note "Summary of Dispatch"
    - Python: `dog.bark(at_stranger)` -> Logic lives in `dog`.\
    - Julia: `bark(dog, stranger)` -> Logic lives in the `bark` function, selected specifically for the combination of `Dog` and `Stranger`.
"""

# ╔═╡ 09abe51d-ed7d-4f8a-b49c-193dbf188e02
md"""
# Summary

!!! note ""
    * Three versions of function definitions: multi-line blocks, one-liners, or anonymous (lambdas).
    * Positional and keyword arguments are separated by a `;`.
	* Positional arguments are required. Keyword arguments are optional.
    * Multiple Dispatch is used to determine the correct function to execute, making the language composable and highly performant.
"""

# ╔═╡ 8e6406dd-e58c-4aef-8bc9-a57984f90884
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ 334abd5f-8a2c-4e05-96cc-feb9dd8f30ae
md"""

## 1: Function Syntax (Multi-line & Defaults)

!!! warning ""
	* **Basic Multi-line:** Define a function `calculate_vol(l, w, h)` using the `function ... end` block. It should return the product of the three arguments.
	  - Test: `calculate_vol(2, 3, 4)` should be 24.
	* **Adding Defaults:** Redefine the function so `h` has a default value of `4`.
	  - Code: `function calculate_vol(l, w, h=1) ... end`
	*  **Testing Defaults:** Call `calculate_vol(5, 5)`.
	  - Note: You only provided 2 arguments, so Julia automatically supplies `4` for `h`, yielding 100 for the result; what will `calculate_vol(5, 5, 5)` produce?
"""

# ╔═╡ 0659caa1-1dfd-418a-80c8-3167ca30ade9
md"""

## 2: Keywords & Single-liners

!!! warning ""
	* **Keywords (`:` vs `;`):** Define a function `describe_data(data; label="Unknown")`.
	  - Note the semicolon `;`! This separates positional arguments (`data`) from keyword arguments (`label`).
	  - Make the function return a string: `"$label: $data"`.
	* **Usage:**
	  - Call it without the keyword: `describe_data([10, 20])`.
	  - Call it *with* the keyword: `describe_data([10, 20], label="Temperature")`.
	* **The One-Liner:** Redefine this function in one line (without needing `function`.)
"""

# ╔═╡ 50f84dd5-7585-482d-bd8e-96b6cabfdbc2
md"""

## 3: Anonymous Functions (Map & Filter)

!!! warning ""
	* **The Syntax:** An anonymous function (lambda) looks like `x -> x + 1`.
	* **Map:** Use `map()` with an anonymous function to double every number in the list `[1, 2, 3, 4]`.
	  - Structure: `map(func, collection)`.
	* **Filter:** Use `filter()` with an anonymous function to extract numbers greater than 5 from the list `[3, 4, 5, 6, 7]`.
"""

# ╔═╡ a1ec03ac-f7b4-4499-92e2-c2a047ed3574
md"""

## 4: The Generic `add()`

!!! warning ""
	* **Generic Definition:** Define a function `my_add(a, b) = a + b`. Do not add any `::Type` annotations.
	* **Duck Typing:**
	  - Try `my_add(10, 20)` (Integers).
	  - Try `my_add(3.14, 2.0)` (Floats).
	  - Try `my_add("Hello ", "World")` (Strings).
	  - *Observation:* It works for all of them because the underlying `+` is defined for all these types.
	* **Introspection:** Run `methods(my_add)`.
	  - You should see `# 1 method for generic function "my_add"`.
"""

# ╔═╡ 0eec43c3-6ca7-4d11-b21c-7d661ef0a3e7
md"""

## 5: Specialization & Dispatch

!!! warning ""
	* **Specific Definition:** add a new method to the *same* function name, `my_add`, but constrain the types to Strings only.
	  - `my_add(a::String, b::String) = "$a ... $b"`
	* **Check Methods:** Run `methods(my_add)` again. You should now see **2 methods**.
	* **Dispatch in Action:**
	  - Execute `my_add(5, 5)`. (Julia chooses the generic version).
	  - Execute `my_add("A", "B")`. (Julia chooses the specific String version).
	* **The Rule:** Julia always executes the **most specific** method that matches the arguments provided.
"""

# ╔═╡ 88e1c20b-5f1d-4a9c-8c4f-61ed72ebc76d
md"""

## 6: Function Broadcasting

!!! warning ""
	* Create a function to add and multiply three scalars.
	* Execute the function for three scalar values.
	* Construct three vectors of equal length.
	* Execute the function using those three vectors.
	* What happens?
	* Execute the same function, but append a `.` after the name and before the opening parenthesis.
	  - E.g., myfunc.(...)
	* What happens now?
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
git-tree-sha1 = "0d751d4ceb9dbd402646886332c2f99169dc1cfd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.76"

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
# ╟─afe988c7-c708-4fdb-bf82-54edeb9db708
# ╟─c78da21b-40ad-42d1-8516-b91d16982c77
# ╟─c74cace1-0e96-48e7-82d3-12f3af3d8591
# ╟─70b70576-0c49-4e5b-b7c1-dd400f3fbcca
# ╟─12928360-90aa-4409-860a-af7f5c781e98
# ╟─d8ba51b9-2d28-4d97-8704-c56c44e04a62
# ╟─09abe51d-ed7d-4f8a-b49c-193dbf188e02
# ╟─8e6406dd-e58c-4aef-8bc9-a57984f90884
# ╟─334abd5f-8a2c-4e05-96cc-feb9dd8f30ae
# ╟─0659caa1-1dfd-418a-80c8-3167ca30ade9
# ╟─50f84dd5-7585-482d-bd8e-96b6cabfdbc2
# ╟─a1ec03ac-f7b4-4499-92e2-c2a047ed3574
# ╟─0eec43c3-6ca7-4d11-b21c-7d661ef0a3e7
# ╟─88e1c20b-5f1d-4a9c-8c4f-61ed72ebc76d
# ╟─83ab9733-5969-4d0c-a3c0-b8f4d2402fde
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
