### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ cab50215-8895-4789-997f-589f017b2b84
using PyCall

# ╔═╡ c3bc0c44-b2e9-4e6a-862f-8ab5092459ea
using LinearAlgebra

# ╔═╡ 97f7a295-5f33-483c-8a63-b74c8f79eef3
begin
	using Dates, PlutoUI, HypertextLiteral
	TableOfContents(title = "2-3: Optimizing Code", depth = 4)
end

# ╔═╡ 299764bc-ebbf-4246-85d8-42e834dd752a
"""
!!! note "2-3: Optimizing Code"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ 76073161-c983-4dfb-945c-27164e50f8ae
md"""
# Optimization of Algorithms

Julia is a high-performance language. However, like any computer language, certain constructs are faster and use your computer's resources more efficiently. This session will give an overview of how you can use Julia and some of its unique features to enable blazing-fast performance.

However, to achieve good performance, there are a couple of things to keep in mind.

## Global Variables and Type Instabilities

First global variables in Julia are almost always a bad idea. First, from a coding standpoint, they are very hard to reason about since they could change at any moment. However, for Julia, they are also a performance bottleneck. Let's consider a simple function that updates a global array to demonstrate the issue of global arrays.

```julia-repl
julia> gl = rand(1000)

julia> function global_update()
	for i in eachindex(gl)
		gl[i] += 1
	end
end

```

Now let's check the performance of this function. To do this, we will use the excellent benchmarking package [`BenchmarkTools.jl`](https://github.com/JuliaCI/BenchmarkTools.jl) and the macro `@benchmark`, which runs the function multiple times and outputs a histogram of the time it took to execute the function

```julia-repl
julia> using BenchmarkTools
```
```julia-repl
julia> @benchmark global_update()
```
```julia
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):   96.743 μs …   8.838 ms  ┊ GC (min … max): 0.00% … 97.79%
 Time  (median):     105.987 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   123.252 μs ± 227.353 μs  ┊ GC (mean ± σ):  5.14% ±  2.76%

  ▄█▇█▇▅▄▃▄▅▃▂▃▅▆▅▅▄▃▃▂▂▂ ▁▁▁          ▁  ▁                     ▂
  ████████████████████████████▇██▇▇██▇███████▇▇█▇▇█▇▇▇▇▆▇▇▆▆▅▆▅ █
  96.7 μs       Histogram: log(frequency) by time        211 μs <

 Memory estimate: 77.77 KiB, allocs estimate: 3978.
```
!!! note
	This was run on a Intel Core i7 i7-1185G7 processors so your benchmarks may differ.

Looking at the histogram, we see that the minimum time is 122 μs to update a vector! We can get an idea of why this is happening by looking at the total number of allocations we made while updating the vector. Since we are updating the array in place, there should be no allocations.

To see what is happening here, Julia provides several code introspection tools.
Here we will use `@code_warntype`
```julia-repl
julia> @code_warntype global_update()
```
```julia
MethodInstance for Main.var"workspace#12".global_update()
  from global_update() in Main.var"workspace#12"
Arguments
  #self#::Core.Const(Main.var"workspace#12".global_update)
Locals
  @_2::Any
  i::Any
Body::Nothing
1 ─ %1  = Main.var"workspace#12".eachindex(Main.var"workspace#12".gl)::Any
│         (@_2 = Base.iterate(%1))
│   %3  = (@_2 === nothing)::Bool
│   %4  = Base.not_int(%3)::Bool
└──       goto #4 if not %4
2 ┄ %6  = @_2::Any
│         (i = Core.getfield(%6, 1))
│   %8  = Core.getfield(%6, 2)::Any
│   %9  = Base.getindex(Main.var"workspace#12".gl, i)::Any
│   %10 = (%9 + 1)::Any
│         Base.setindex!(Main.var"workspace#12".gl, %10, i)
│         (@_2 = Base.iterate(%1, %8))
│   %13 = (@_2 === nothing)::Bool
│   %14 = Base.not_int(%13)::Bool
└──       goto #4 if not %14
3 ─       goto #2
4 ┄       return nothing
```

`@code_warntype` tells us where the Julia compiler could not infer the variable type. If this happens, Julia cannot efficiently compile the function, and we end up with performance comparable to Python. The above example highlights the type instabilities in red and denotes accessing the global variable `gl`. These globals are a problem for Julia because their type could change anytime. As a result, Julia defaults to leaving the type to be the `Any` type.

Typically the standard way to fix this issue is to pass the offending variable as an argument to the function.

```julia-repl
julia> function better_update!(x)
	for i in eachindex(x)
		x[i] += 1
	end
end
```

Benchmarking this now

```julia-repl
julia> @benchmark better_update!(gl)
```

By passing the array as a function argument, Julia can infer the type and compile an efficient version of the function, achieving a 1000x speedup on my machine (Ryzen 7950x).

```julia-repl
julia> @code_warntype better_update!(gl)
```

The red font is now gone. This is a general thing to keep in mind when using Julia. Try not to use the global scope in performance-critical parts. Instead, place the computation inside a function.
"""

# ╔═╡ b89b329e-0dd1-4b0b-82a1-19d104dcf430
md"""
## Types

Julia is a typed but dynamic language. The use of types is part of the reason that Julia can produce fast code. If Julia can infer the types inside the body of a function, it will compile efficient machine code. However, if this is not the case, the function will become **type unstable**. We saw this above with our global example, but these type instabilities can also occur in other seemingly simple functions.

For example let's start with a simple sum
```julia-repl
julia> function my_sum(x)
	s = 0
	for xi in x
		s += xi
	end
	return
end
```

Analyzing this with `@code_warntype` shows a small type instability.

```julia-repl
julia> @code_warntype my_sum(gl)
```

!!! tip
	Remember to look for red-highlighted characters.

In this case, we see that Julia inserted a type instabilities since it could not determine the specific type of `s`. This is because when we initialized `s`, we used the value `0` which is an integer. Therefore, when we added xi to it, Julia determined that the type of `s` could either be an `Int` or `Float`.

!!! note
	In Julia 1.8, the compiler is actually able to do something called [`union splitting`](https://julialang.org/blog/2018/08/union-splitting/), preventing this type instability from being a problem. However, it is still good practice to write more generic code.

To fix this we need to initialize `s` to be more generic. That can be done with the `zero` function in Julia.

```julia-repl
julia> function my_sum_better(x)
	s = zero(eltype(x))
	for xi in x
		s += xi
	end
	return s
end
```

Running `@code_warntype` we now get
```julia
@code_warntype my_sum_better(gl)
```

`zero` is a generic function that will create a `0` element that matches the type of the elements of the vector `x`.

One important thing to note is that while Julia uses types to optimize the code, using types in the function arguments does not impact performance at all.

To see this let's look at an explicit version of `my_sum`
```julia-repl
julia> function my_sum_explicit(x::Vector{Float64})
	s = zero(eltype(x))
	for xi in x
		s += xi
	end
	return s
end
```

We can now benchmark both of our functions

```julia-repl
julia> @benchmark my_sum_better($gl)
```

```julia-repl
julia> @benchmark my_sum_explicit($gl)
```

We can even make sure that both functions produce the same code using `@code_llvm` (`@code_native`), which outputs the LLVM IR (native machine code).

```julia-repl
julia> @code_llvm my_sum_better(gl)
```

```julia-repl
julia> @code_llvm my_sum_explicit(gl)
```

Being overly specific with types in Julia is considered bad practice since it prevents composability with other libraries in Julia. For example,

```julia-repl
julia> my_sum_explicit(Float32.(gl))
```

gives a method error because we told the compiler that the function could only 
accept `Float64`. In Julia, types are mostly used for `dispatch` i.e., selecting which function to use. However, there is one important instance where Julia requires that the types be specific. When defining a composite type or `struct`.

For example
```julia-repl
julia> struct MyType
		a::AbstractArray
	end
julia> Base.getindex(x, i) = x.a[i]
```

In this case, the `getindex` function is type unstable

```julia-repl
julia> @code_warntype MyType(rand(50))[1]
```
This is because Julia is not able to determine the type of `x.a` until runtime and so the compiler is unable to optimize the function.  This is because `AbstractArray` is an abstract type.

!!! tip
	For maximum performance only use concrete types as `struct` fields/properties.

To fix this we can use *parametric types*

```julia-repl
julia> struct MyType2{A<:AbstractArray}
		a::A
	end

julia> Base.getindex(a::MyType2, i) = a.a[i]
```

```julia-repl
julia> @code_warntype MyType2(rand(50))[1]
```

and now because the exact layout `MyType2` is concrete, Julia is able to efficiently compile the code.
"""

# ╔═╡ a8c622c8-2eaf-4792-94fd-e18d622c3b23
md"""
## Additional Tools

In addition to `@code_warntype` Julia also has a number of other tools that can help diagnose type instabilities or performance problems:
- [`Cthulhu.jl`](https://github.com/JuliaDebug/Cthulhu.jl): Recursively moves through a function and outputs the results of type inference.
- [`JET.jl`](https://github.com/aviatesk/JET.jl): Employs Julia's type inference system to detect potential performance problems as well as bugs.
- [`ProfileView.jl`](https://github.com/timholy/ProfileView.jl) Julia profiler and flame graph for evaluating function performance.
"""

# ╔═╡ 20eff914-5853-4993-85a2-dfb6a8e2c14d
md"""
# Data Layout

Besides ensuring your function is type stable, there are a number of other performance issues to keep in mind with using Julia.

When using higher-dimensional arrays like matrices, the programmer should remember that Julia uses a `column-major order`. This implies that indexing Julia arrays should be done so that the first index changes the fastest. For example

```julia-repl
julia> function row_major_matrix!(a::AbstractMatrix)
	for i in axes(a, 1)
		for j in axes(a, 2)
			a[i, j] = 2.0
		end
	end
	return a
end
```
!!! note
	We use the bang symbol `!`. This is stardard Julia convention and signals that the function is mutating.

"""

# ╔═╡ 4f4dde5e-21f3-4042-a91d-cd2c474a2279


# ╔═╡ da99dabc-f9e5-4f5e-8724-45ded36270dc
md"""
!!! tip
	Here we use an function to fill the matrix. This is just for clarity. The more Julian way to do this would be to use the `fill` or `fill!` functions.
"""

# ╔═╡ b3bb4563-e0f6-4edb-bae1-1a91f64b628f
md"""
Benchmarking this function gives
```julia-repl
julia> @benchmark row_major_matrix!($(zeros(1000, 1000)))
```

"""

# ╔═╡ 0d80a856-131d-4811-8d14-828c8c5e49dc


# ╔═╡ 1194df52-bd14-4d6b-9e99-d87c131156d6
md"""
This is very slow! This is because Julia uses column-major ordering. Computers typically store memory sequentially. That means that the most efficient way to access parts of a vector is to do it in order. For 1D arrays there is no ambiguity. However, for higher dimensional arrays a language must make a choice. Julia follows Matlab and Fortrans conventions and uses column-major ordering. This means that matrices are stored column-wise. In a for-loop this means that the inner index should change the fastest.

!!! note
	For a more complete introduction to computere memory and Julia see <https://book.sciml.ai/notes/02-Optimizing_Serial_Code/>

```julia-repl
julia> function column_major_matrix!(a::AbstractMatrix)
	for i in axes(a, 1)
		for j in axes(a, 2)
			# The j index goes first
			a[j, i] = 2.0
		end
	end
	return a
end
```
"""

# ╔═╡ 5843b2ca-0e98-474d-8a92-7214b05399fd


# ╔═╡ 3270cc6e-3b2d-44b3-a75c-fa50cf15b77b
md"""
```julia-repl
julia> @benchmark column_major_matrix!($(zeros(1000, 1000)))
```
"""

# ╔═╡ 214b7f1b-f90d-4aa8-889f-2a522e80dcf5


# ╔═╡ 50e008a1-a9cc-488e-a1c0-bd21528414c6
md"""
To make iterating more automatic, Julia also provides a generic CartesianIndices tool that ensures that the loop is done in the correct order

```julia-repl
julia> function cartesian_matrix!(a::AbstractMatrix)
	for I in CartesianIndices(a)
		a[I] = 2.0
	end
	return a
end
```
"""

# ╔═╡ e6016b1b-1cb2-4e92-b657-a51a221aa3f2


# ╔═╡ 6ae76360-c446-4ee7-b452-0ac225e9e41b
md"""
```julia-repl
julia> @benchmark cartesian_matrix!($(zeros(1000, 1000)))
```
"""

# ╔═╡ 3534d380-d8ae-498a-84be-c14ba5454e65


# ╔═╡ a52e79b7-3fb0-4ad3-9bf5-f225beff01c3
md"""
# Broadcasting/Vectorization in Julia

One of Julia's greatest strengths over python is surprisingly its ability to vectorize algorithms and **fuse** multiple algorithms together.

In python to get speed you typically need to use numpy to vectorize operations. For example, to compute the operation `x*y + c^3` you would do
```python
python> x*y + c**3
```
However, this is not optimal since the algorithm works in two steps:
```python
python> a = x*y
python> b = c**3
python> out = a + b
```
What this means is that python/numpy is not able to fuse multiple operations together. This essentially loops through the data twice and can lead to substantial overhead.

"""

# ╔═╡ 4dd74c86-333b-4e7a-944b-619675e9f6ed
md"""
```julia-repl
julia> @pyimport numpy as np
```
"""

# ╔═╡ e0a1b20d-366b-4048-80f1-94297697bd4a
x = rand(1_000_000)

# ╔═╡ 82edfb04-3de0-462b-ab4f-77cdad052bef
y = rand(1_000_000)

# ╔═╡ e8febda3-db2c-4f10-84bd-384c9ddd0ff7
c = rand(1_000_000)

# ╔═╡ f33eb06d-f45b-438c-86a9-26d8f94e7809
md"""
First let's use PyCall and numpy to do the computation
"""

# ╔═╡ 60e55645-ab59-4ea7-8009-9db7d0aea2e6
begin
	py"""
	def bench_np(x, y, c):
		return x*y + c**3
	"""
	bench_np = py"bench_np"
end

# ╔═╡ 35f818c2-acee-4d20-9eb3-0c3ae37f3762
md"""
```julia-repl
@benchmark bench_np($x, $y, $c)
```
"""

# ╔═╡ a0c8660c-3ddb-4795-b3c9-a63cc64c8c00


# ╔═╡ cb3bb128-49d3-4996-84e2-5154e13bbfbd
md"""
Now to get started with Julia we will use a simple for loop.

```julia
function serial_loop(x, y, c)
	out = similar(x)
	for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```
"""

# ╔═╡ 924d11a7-5161-4b13-a1f6-a1a8530736da


# ╔═╡ 40381501-952a-48a5-9a28-ee4bf1c65fd4
md"""
```julia
@benchmark serial_loop($x, $y, $c)
```
"""

# ╔═╡ 0be6a2d0-f470-436c-bbd7-8bab3635a34d


# ╔═╡ 7fad0fc0-1a6a-437a-a1c2-ce2c70d41acf
md"""
And right away, we have almost a factor of 4X speed increase in Julia compared to numpy.

However, we can make this loop faster! Julia automatically checks the bounds of an array every loop iteration. This makes Julia memory safe but adds overhead to the loop.

!!! warning
	`@inbounds` used incorrectly can give wrong results or even cause Julia to  SEGFAULT

```julia
function serial_loop_inbounds(x, y, c)
	out = similar(x)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```

!!! tip
	If you index with `eachindex` or `CartesianIndices` Julia can often automatically remove the bounds-check for you. The moral - always use Julia's iterator interfaces where possible. This example doesn't because `out` is not included in `eachindex`
"""

# ╔═╡ 54a92a14-405a-45d1-ad3a-5f42e4ce8789


# ╔═╡ 946da67e-5aff-4de9-ba15-715a05264c4d
md"""
```julia
@benchmark serial_loop_inbounds($x, $y, $c)
```
"""

# ╔═╡ 4da9796c-5102-44e7-8af3-dadbdabcce73


# ╔═╡ db4ceb7c-4ded-4048-88db-fd15b3231a5c
md"""
That is starting to look better. Now we can do one more thing. Looking at the results we see that we are still allocating in this loop. We can fix this by explicitly passing the output buffer.
"""

# ╔═╡ 575d1656-0a0d-40ba-a190-74e36c354e8c
md"""
```julia
function serial_loop!(out, x, y, c)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```
"""

# ╔═╡ fc2351f5-f808-499d-8251-d12c93a2be0e


# ╔═╡ 2bd7d41e-f2c9-47cd-8d5b-a2cfef84a830
out = similar(x)

# ╔═╡ 42be3a59-b6bb-49b2-a2ca-73adedc35588
md"""
```julia
@benchmark serial_loop!(out, x, y, c)
```
"""

# ╔═╡ f5ecdd06-addb-4913-996b-164e337853c2


# ╔═╡ c14acc67-dbb2-4a86-a811-de857769a472
md"""
With just two changes, we have sped up our original function by almost a factor of 2. However, compared to NumPy, we have had to write a lot more code.

Fortunately, writing these explicit loops, while fast, is not required to achieve good performance in Julia. Julia provides its own *vectorization* procedure using the
`.` syntax. This is known as *broadcasting* and results in Julia being able to apply elementwise operations to a collection of objects.

To demonstrate this, we can rewrite our optimized `serial_loop` function just as

```julia
function bcast_loop(x, y, c)
	return x.*y .+ c.^3
	# or @. x*y + c^3
end
```
"""

# ╔═╡ f9a938d8-dce9-4ef0-967e-5b3d5384ca9b


# ╔═╡ 38bafb52-14f0-4a42-8e73-de1ada31c87e
md"""
```julia
@benchmark bcast_loop($x, $y, $c)
```
"""

# ╔═╡ 785a379a-e6aa-4919-9c94-99e277b57844


# ╔═╡ 232cd259-5ff4-42d2-8ae1-cb6823114635
md"""
Unlike Python this syntax can even be used to prevent allocations!

```julia
function bcast_loop!(out, x, y, c)
	out .= x.*y .+ c.^3
	# or @. out = x*y + c^3
end
```
"""

# ╔═╡ 168aee22-6769-4077-a9da-a27689e6bb32


# ╔═╡ 985cd6ec-bd2d-4dd9-bfbe-0bb066036150
md"""
```julia
@benchmark bcast_loop!($out, $x, $y, $c)
```
"""

# ╔═╡ 6acbaed4-6ff3-45be-9b28-595213206218


# ╔═╡ 587d98d8-f805-4c4f-bf2f-1887d86adf05
md"""
Both of our broadcasting functions perform identically to our hand-tuned for loops. How is this possible? The main reason is that Julia's elementwise operations or broadcasting automatically **fuses**. This means that Julia's compiler eventually compiles the broadcast expression to a single loop, preventing intermediate arrays from ever needing to be formed.
"""

# ╔═╡ ea2e2140-b826-4a05-a84c-6309241da0e7
md"""
Julia's broadcasting interface is also generic and a lot more powerful than the usual NumPy vectorization algorithm. For instance, suppose we wanted to perform an eigen decomposition on many matrices. In Julia, this is given in the `LinearAlgebra` module and the `eigen` function. To apply this to a vector of matrices, we then need to change `eigen` to `eigen.` .
"""

# ╔═╡ e8c1c746-ce30-4bd9-a10f-c68e3823faac
A = [rand(50,50) for _ in 1:50]

# ╔═╡ e885bbe5-f7ec-4f6a-80fd-d6314179a3cd
md"""
```julia
eigen.(A)
```
"""

# ╔═╡ 90bd7f7b-3cc1-43ab-8f78-c1e8339a79bf


# ╔═╡ 608a3a98-924f-45ef-aeca-bc5899dd8c7b
md"""
Finally as a bonus we note that Julia's broadcasting interface also automatically works on the GPU.
```julia
using CUDA
```
"""

# ╔═╡ b83ba8db-b9b3-4921-8a93-cf0733cec7aa


# ╔═╡ cc1e5b9f-c5b4-47c0-b886-369767f6ca4b
md"""
```julia
@benchmark bcast_loop!($(cu(out)), $(cu(x)), $(cu(y)), $(cu(c)))
```

!!! tip
	This will only work if you have CUDA installed and a NVIDIA GPU.
"""

# ╔═╡ 687b18c3-52ae-48fa-81d6-c41b48edd719


# ╔═╡ dcd6c1f3-ecb8-4a3f-ae4f-3c5b6f8494e7
md"""
!!! note
	`cu` is the function that moves the data on the CPU to the GPU. See the parallel computing tutorial for more information about GPU based parallelism in Julia.
"""

# ╔═╡ 20bcc70f-0c9f-40b6-956a-a286cea393f8
md"""
# Other Performance Tools

This is just the start of various performance tips in Julia. There exist many other interesting packages/resources when optimizing Julia code. These resources include:
- Julia's [`performance tips`](https://docs.julialang.org/en/v1/manual/performance-tips/) section is excellent reading for more information about the various optimization mentioned here and many more.
- [`StaticArrays.jl`](https://github.com/JuliaArrays/StaticArrays.jl): Provides a fixed size array that enables aggressive SIMD and optimization for small vector operations.
- [`StructArrays.jl`](https://github.com/JuliaArrays/StructArrays.jl): Provides an interface that acts like an array whose elements are a struct but actually stores each field/property of the struct as an independent array.
- [`LoopVectorization.jl`](https://github.com/JuliaSIMD/LoopVectorization.jl) specifically the `@turbo` macro that can rewrite loops to make extra use of SIMD.
- [`Tulio.jl`](https://github.com/mcabbott/Tullio.jl): A package that enables Einstein summation-style summations or tensor operations and automatically uses multi-threading and other array optimization.
"""

# ╔═╡ 5da0f591-00d9-41be-bbc6-dcd8adaf6677
md"""
# Summary

!!! note ""
	* Avoid global variables
	* Avoid type instabilities by profiling your code with `@code_warntype`.
	* Avoid memory allocations by profiling your code using `@time` or `@benchmark`.
	* Access arrays column first.
	* Use the broadcast `.` operator to vectorize and **fuse* expressions.
"""

# ╔═╡ f457ce21-e7c7-45e7-a16d-2edfd693fc6e
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ f8d3fbc9-dc11-4a9f-b7b7-c7627a445a1a
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
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.77"
PyCall = "~1.96.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.3"
manifest_format = "2.0"
project_hash = "0862783add28d285781a1de5458b02ce4741a305"

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

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "b19db3927f0db4151cb86d073689f2428e524576"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.10.2"

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
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

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
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

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

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "522f093a29b31a93e34eaea17ba055d850edea28"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "9816a3826b0ebf49ab4926e2b18842ad8b5c8f04"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.96.4"

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

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

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
# ╟─299764bc-ebbf-4246-85d8-42e834dd752a
# ╟─76073161-c983-4dfb-945c-27164e50f8ae
# ╟─b89b329e-0dd1-4b0b-82a1-19d104dcf430
# ╟─a8c622c8-2eaf-4792-94fd-e18d622c3b23
# ╟─20eff914-5853-4993-85a2-dfb6a8e2c14d
# ╠═4f4dde5e-21f3-4042-a91d-cd2c474a2279
# ╟─da99dabc-f9e5-4f5e-8724-45ded36270dc
# ╟─b3bb4563-e0f6-4edb-bae1-1a91f64b628f
# ╠═0d80a856-131d-4811-8d14-828c8c5e49dc
# ╟─1194df52-bd14-4d6b-9e99-d87c131156d6
# ╠═5843b2ca-0e98-474d-8a92-7214b05399fd
# ╟─3270cc6e-3b2d-44b3-a75c-fa50cf15b77b
# ╠═214b7f1b-f90d-4aa8-889f-2a522e80dcf5
# ╟─50e008a1-a9cc-488e-a1c0-bd21528414c6
# ╠═e6016b1b-1cb2-4e92-b657-a51a221aa3f2
# ╠═6ae76360-c446-4ee7-b452-0ac225e9e41b
# ╠═3534d380-d8ae-498a-84be-c14ba5454e65
# ╠═a52e79b7-3fb0-4ad3-9bf5-f225beff01c3
# ╠═cab50215-8895-4789-997f-589f017b2b84
# ╟─4dd74c86-333b-4e7a-944b-619675e9f6ed
# ╠═e0a1b20d-366b-4048-80f1-94297697bd4a
# ╠═82edfb04-3de0-462b-ab4f-77cdad052bef
# ╠═e8febda3-db2c-4f10-84bd-384c9ddd0ff7
# ╟─f33eb06d-f45b-438c-86a9-26d8f94e7809
# ╠═60e55645-ab59-4ea7-8009-9db7d0aea2e6
# ╟─35f818c2-acee-4d20-9eb3-0c3ae37f3762
# ╠═a0c8660c-3ddb-4795-b3c9-a63cc64c8c00
# ╟─cb3bb128-49d3-4996-84e2-5154e13bbfbd
# ╠═924d11a7-5161-4b13-a1f6-a1a8530736da
# ╟─40381501-952a-48a5-9a28-ee4bf1c65fd4
# ╠═0be6a2d0-f470-436c-bbd7-8bab3635a34d
# ╟─7fad0fc0-1a6a-437a-a1c2-ce2c70d41acf
# ╠═54a92a14-405a-45d1-ad3a-5f42e4ce8789
# ╟─946da67e-5aff-4de9-ba15-715a05264c4d
# ╠═4da9796c-5102-44e7-8af3-dadbdabcce73
# ╟─db4ceb7c-4ded-4048-88db-fd15b3231a5c
# ╟─575d1656-0a0d-40ba-a190-74e36c354e8c
# ╠═fc2351f5-f808-499d-8251-d12c93a2be0e
# ╠═2bd7d41e-f2c9-47cd-8d5b-a2cfef84a830
# ╟─42be3a59-b6bb-49b2-a2ca-73adedc35588
# ╠═f5ecdd06-addb-4913-996b-164e337853c2
# ╟─c14acc67-dbb2-4a86-a811-de857769a472
# ╠═f9a938d8-dce9-4ef0-967e-5b3d5384ca9b
# ╟─38bafb52-14f0-4a42-8e73-de1ada31c87e
# ╠═785a379a-e6aa-4919-9c94-99e277b57844
# ╟─232cd259-5ff4-42d2-8ae1-cb6823114635
# ╠═168aee22-6769-4077-a9da-a27689e6bb32
# ╟─985cd6ec-bd2d-4dd9-bfbe-0bb066036150
# ╠═6acbaed4-6ff3-45be-9b28-595213206218
# ╟─587d98d8-f805-4c4f-bf2f-1887d86adf05
# ╟─ea2e2140-b826-4a05-a84c-6309241da0e7
# ╠═e8c1c746-ce30-4bd9-a10f-c68e3823faac
# ╠═c3bc0c44-b2e9-4e6a-862f-8ab5092459ea
# ╟─e885bbe5-f7ec-4f6a-80fd-d6314179a3cd
# ╠═90bd7f7b-3cc1-43ab-8f78-c1e8339a79bf
# ╟─608a3a98-924f-45ef-aeca-bc5899dd8c7b
# ╠═b83ba8db-b9b3-4921-8a93-cf0733cec7aa
# ╟─cc1e5b9f-c5b4-47c0-b886-369767f6ca4b
# ╠═687b18c3-52ae-48fa-81d6-c41b48edd719
# ╟─dcd6c1f3-ecb8-4a3f-ae4f-3c5b6f8494e7
# ╟─20bcc70f-0c9f-40b6-956a-a286cea393f8
# ╟─5da0f591-00d9-41be-bbc6-dcd8adaf6677
# ╟─f457ce21-e7c7-45e7-a16d-2edfd693fc6e
# ╠═f8d3fbc9-dc11-4a9f-b7b7-c7627a445a1a
# ╟─97f7a295-5f33-483c-8a63-b74c8f79eef3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
