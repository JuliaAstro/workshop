### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 34fcf5ed-037d-4483-bc41-085ab63ad41a
begin
	using Dates, PlutoUI, HypertextLiteral
	TableOfContents(title = "2-4: Parallel Computing", depth = 4)
end

# ╔═╡ 4083769b-0071-406b-b4c3-a5a6284d5600
"""
!!! note "2-4: Parallel Computing"
    **Last Updated: $(Dates.format(today(), dateformat"d u Y"))**
""" |> Markdown.parse

# ╔═╡ e6020e3a-77c7-11ed-2be9-e987cee1edf0
md"""
Julia can use various types of parallelism to accelerate the performance of a program. This session will provide a brief overview of the various types and how to use them.

Julia has a strong parallel computing infrastructure that enable high performance computing (HPC) using **vectorization**, **threading**, **distributed computing**, and even **GPU acceleration**.

# Vectorization

All modern CPUs provide vectorization or Single-Instruction-Multiple-Data (**SIMD**) execution. SIMD is when the computer can apply a single instruction to multiple data in a single CPU cycle. For example, consider adding two vectors `A` and `B`.

The serial computation loops through each value in the two arrays and applies the
addition operation during each CPU cycle (left figure). Whereas, the vectorized computation loops through groups of values in the two arrays and applies the addition operation during each CPU cycle (right figure), resulting in 2x, 4x, or greater performance improvement depending on the CPU architecture (i.e., AVX, AVX2, AVX512).

Julia will vectorize array compuations whenever possible and as discussed in session 2-2, it will vector pipelining for even better performance.

!!! note
    A **CPU cycle** is effectively the smallest unit of time for the Central Processing Unit or CPU. During a single CPU cycle, the CPU usually does a fetch-decode-execute step, which is equivalent to the CPU doing a single simple operation such as addition or multiplication.
"""

# ╔═╡ 4473cae3-9350-4741-8457-6bacb1def61b
html"""
<img src="https://github.com/JuliaAstro/workshop/blob/main/data/vectorization.jpeg?raw=true"/>
"""

# ╔═╡ 54d083d4-3bf8-4ed7-95b5-203e13cc3249
md"""
# Threading

Multi-threading is when a set of processors in Julia share the same Julia runtime and memory.
This means that multiple threads can all write and read from the exact same section of
memory in the computer and can execute code on the memory simultaneously.

To enable threading in julia you need to tell julia the number of threads you want to use.
For instance, start julia with 4 threads do
```bash
> julia -t 4
```
which will start Julia with 4 threads. You can also start Julia with threads on Linux/Mac by
using the environment label `JULIA_NUM_THREADS=4`. If you use `julia -t auto` then Julia will
start with the number of threads available on your machine. Note that `julia -t` required julia version 1.5 or later.

You can check the number of threads julia is using in the repl by typing
```julia
Threads.nthreads()
```

Each Julia thread is tagged with an id that can be found using
```julia
Threads.threadid()
```
which defaults to 1, the master thread.


!!! tip
	This is the number of `Julia` threads not the number of BLAS threads. To set those do
	```julia
	using LinearAlgebra
	BLAS.set_num_threads(8)
	```
	where 8 is the number of threads you want to use.

which defaults to `1` the master thread.

## Threads.@threads

The simplest way to use multi-threading in Julia is to use the `Threads.@threads` macro
which automatically threads loops for you. For instance, we can thread our previous function using:

```julia-repl
function threaded_add!(out, x, y)
	Threads.@threads for i in eachindex(out, x, y)
		out[i] = x[i] + y[i]
	end
	return out
end
```

## Complications

There are additional considerations to keep in mind when multi-threading. An important one is that Julia's Base threading utilities are rather low-level and do not guarantee threading safety, e.g., to be free of **race-conditions**. To see this, let's consider a simple map and sum function.
"""

# ╔═╡ 40fbf241-6c38-4ed0-81e2-b44462baaf52
md"""
## High-Level Packages

In general multi-threading programming can be quite difficult and error prone. Luckily there are a number of packages in Julia that can make this much simpler. The [`JuliaFolds`](https://github.com/JuliaFolds) ecosystem has a large number of packages, for instance, the [`FLoops.jl`](https://github.com/JuliaFolds/FLoops.jl). FLoops.jl provides two macros that enable a simple for-loop to be used for a variety of different execution mechanisms. For instance, every previous version of apply_sum can be written as:

```julia-repl
julia> using FLoops

julia> function floops_apply_sum(f, x; executor=ThreadedEx())
	s = zero(eltype(x))
	@floop for i in eachindex(x)
		@reduce s += f(x[i])
	end
	return s
end
```

Pay special attention to the additional `executor` keyword argument. FLoops.jl provides a number of executors:
 - `SequentialEx` runs the for-loop serially (similar to `apply_sum`)
 - `ThreadedEx` runs the for-loop using threading, while avoiding data-races (similar to `threaded_sol1_apply_sum`)
 - `CUDAEx` runs the for-loop vectorized on the GPU using CUDA.jl. (this is experimental)
 - `DistributedEx` runs the for-loop using Julia's distributed computing infrastruture (see below).

We can then easily run both threaded and serial versions of the algorithm by just changing the `executor`
"""

# ╔═╡ dc8d70b5-0a0e-4547-b165-fd1d2a6f440d
md"""
# GPU Acceleration

## Introduction

GPUs are in some sense, opposite to CPUs. The typical CPU is characterized by a small
number of very fast processors. On the other hand, a GPU has thousands of very slow processors.
This dichotomy directly relates to the types of problems that are fast on a GPU compared to a CPU.

To get started with GPUs in Julia you need to load the correct package one of

1. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl): NVIDIA GPUs, and the most stable GPU package
2. [AMDGPU.jl](https://github.com/JuliaGPU/AMDGPU.jl): AMD GPUs, actively developed but not as mature as CUDA; only works on linux due to ROCm support
3. [oneAPI.jl](https://github.com/JuliaGPU/oneAPI.jl): Intel GPUs, currently under active development so it may have bugs; only works on linux currently.
4. [Metal.jl](https://github.com/JuliaGPU/Metal.jl): Mac GPUs. Work in progress. Expect bugs and it is open to pull-requests.

For this tutorial I will be using mostly be using the CUDA library. However, we will try to include code for other GPUs as well.

## Simple Computations

CUDA.jl provides a complete suite of GPU tools in Julia from low-level kernel writing to high-level array operations. Most of the time a user just needs to use the high-level array interface which uses Julia's built-in broadcasting. For instance we can port our simple addition example above to the GPU by first moving the data to the GPU and using Julia's CUDA.jl broadcast interface.

```julia-repl
julia> using AMDGPU        # For AMD
```
```julia-repl
julia> using oneAPI        # For intel (linux only)
```
```julia-repl
julia> using Metal         # For M1 Mac
```
```julia-repl
julia> using CUDA          # For nVidia
```

For CUDA.jl the `cu` function take an array and creates a `CuArray` which is a copy of the
array that lives in the GPU memory. For the other GPUs the story is very similar and just the array type changes. Below we will mention some potential performance
pitfalls that can occur due to this memory movement.

`cu` will tend to work on many Array types in Julia. However, if you have a
more complicated variable such as a `struct` then you will need to tell Julia how to move
the data to the GPU. To see how to do this see <https://cuda.juliagpu.org/stable/tutorials/custom_structs/>

Given these GPU array objects, our `serial_add!` function could be written as

## Custom Kernels

While Julia's array base GPU programming is extremely powerful, sometimes we have to use
something more low-level. For instance, suppose our function accesses specific elements of
a GPU array (e.g., CuArray) that isn't handled through the usual linear algebra of broadcast interface.

In this case when we try to index into a `CuArray` we get a `Scalar Indexing` error.

```julia-repl
julia> xlarge_gpu[1]
```

Analyzing the error message tells us what is happening. When accessing a single element,
the CuArray will first copy the entire array to the CPU and then access the element.
This is incredibly slow! So how to we deal with this?

The first approach is to see if you can rewrite the function so that you can make use of
the GPU broadcasting interface. If this is impossible, you will need to write a custom kernel.

To do this, let's adapt our simple example to demonstrate the general approach to writing CUDA kernels

For CUDA and AMD

```julia-repl
julia> function gpu_kernel_all!(out, x, y)
    index = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    stride = gridDim().x * blockDim().x
    for i in index:stride:length(out)
        out[i] = x[i] + y[i]
    end
    return nothing
end
```

For Mac

```julia-repl
julia> function gpu_kernel_all!(out, x, y)
	i = thread_position_in_grid_1d()
	out[i] = x[i] + y[i]
	return nothing
end
```

This creates the kernel function. This looks almost identical to our `serial_add` function except for the `threadIDx` and `blockDim` calls. These arguments relate to how the GPU vectorizes the operation across all of its threads. For an introduction to these see the `CUDA.jl` [introduction](https://cuda.juliagpu.org/stable/tutorials/introduction/). Now to run the CUDA kernel we can compile our function to a native CUDA kernel using the `@cuda` macro.

```julia-repl
# Compile the CUDA kernel and run it
julia> CUDA.@sync @cuda threads=256 gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu)
```

For AMD we use the `@roc` macro

```julia-repl
julia> wait(@roc groupsize=256 gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu))
```

For M1 Mac we use the `@metal` macro

```julia-repl
julia> @metal threads=length(outlarge) gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu)
```

!!! note
	Due to the nature of GPU programming we need to specify the number of threads to run the kernel on. Here we use 256 as a default value. However, this is not optimal and the `CUDA.jl` documentation provides additional advice on how to optimize these parameters

Finally, to get our result from the GPU we then just use the `Array` constructor
```julia
Array(outlarge_gpu)
```

And there you go, you just wrote your first native CUDA kernel within Julia! Unlike other programming languages, we can use native Julia code to write our own CUDA kernels and do not have to go to a lower-level language like C.

## GPU caveats

### Dynamic Control Flow
GPUs, in general, are more similar to SIMD than any other style of parallelism mentioned in
this tutorial. That is, GPUs follow the **Single Program Multiple Data** paradigm. What this
means is that GPUs will experience the fastest programming when the exact same program will
be run across all the processors on the system. In practice it means that a program with control flow such as

```julia-repl
julia> if a > 1
    # Do something
else
    # Do something else
end
```

will potentially be slow. The reason is that, in this case, the GPU will actually compute
both branches at run-time and then select the correct value. Therefore, GPU programs should
generally try to limit this kind of dynamic control flow. You may have noticed this when
using JAX. JAX tries to restrict the user to static computation graphs
(no dynamic control flow) as much as possible for this exact reason. GPUs are not good with
dynamical control flow.

### GPU memory
Another important consideration is the time it takes to move memory on and off of the GPU.
To see how long this takes let's benchmark the cu function which move memory from the CPU to the GPU.

```julia-repl
julia> @benchmark cu($xlarge)
```

!!! tip
	Replace `cu` with the correct GPU array call for your specific provider

Similarly we can benchmark the time it takes to transform from the GPU to the CPU.

```julia-repl
julia> @benchmark Array($outlarge_gpu)
```

In both cases, we see that the just data transfer takes substantially longer than the computation on the GPU! This is a general "feature" of GPU programming. Managing the data transfer between the CPU and GPU is critical for performance. In general, when using the GPU you should aim for as much of the computation to be performed on the GPU as possible. A good rule of thumb is that if the computation on the CPU takes more than 1 ms, then moving it to the GPU will probably have some benefit.
"""

# ╔═╡ b2eb604f-9180-4e48-9ae5-04162583fb33
md"""
# Distributed Computing

!!! note
	This section requires the REPL.

Distributed computing differs from all other parallelization strategies we have used.
Distributed computing is when multiple independent processes are used together for computation. That is, unlike multi-threading, where each process lives in the Julia session, distributed computing links multiple **separate** Julia sessions together.

As a result, each processor needs to communicate with the other processors through message passing, i.e., sending data (usually through a network connection) from one process to the other. The downside of this approach is that this communication entails additional overhead compared to the other parallelization strategies we mentioned previously. The upside is that you can link arbitrarily large numbers of processors and processor memory together to parallelize the computation.

Julia has a number of different distributed computing facilities, but we will focus on `Distributed.jl` the one supported in the standard library [`Distributed.jl`](https://tdocs.julialang.org/en/v1/manual/distributed-computing/).

## Distributed.jl

Distributed's multiprocessing uses the **manager-worker** paradigm. This is where the programmer
controls the manager directly and then it assigns tasks to the rest of the workers.
To start multiprocessing with Julia, there are two options

1. `julia -p 3` will start julia with 3 workers (4 processes in total). This will also automatically bring the Distributed library into scope
2. Is to manually add Julia processors in the repl. To do this in a fresh Julia session,

we do

```julia-repl
julia> using Distributed
julia> addprocs(3)
```

!!! note
    On HPC systems, you can also use [`ClusterManagers.jl`] (https://github.com/JuliaParallel/ClusterManagers.jl)
    to setup a distributed environment using different job queue systems, such as Slurm and SGE.

This adds 3 worker processors to the Julia process. To check the id's of the workers we can use the `workers` function

```julia-repl
julia> workers()
```
We see that there are three workers with id's 2, 3, 4. The manager worker is always given the first id `1` and corresponds to the current Julia session. To see this we can use the `myid()` function

```julia-repl
julia> myid()
```

To start a process on a separate worker process, we can use the `remotecall` function

```julia-repl
julia> f = remotecall(rand, 2, 4, 4)
```

The first argument is the function we wish to call on the worker, the second argument is the id of the worker, and the rest of the arguments are passed to the function.
One thing to notice is that `remotecall` doesn't return the actual result of the computation. Instead `remotecall` returns a `Future`. This is because we don't necessarily need to return the result of the computation to the manager processor, which would induce additional communication costs. However, to get the value of the computation you can use the `fetch` function

```julia-repl
julia> fetch(f)
```

`remotecall` is typically considered a low-level function. Typically a user will use the `@spawnat` macro

```julia-repl
julia> f2 = @spawnat :any rand(4, 4)
```

This call does the same thing as the `remotecall` function above but the first argument is the worker id which we set to any to let Julia itself decide which processor to run it on.

## Loading modules

Since Julia uses a manager-worker workflow, we need to manually ensure that every process has access to all the required data. For instance, suppose we wanted to compute the mean of a vector. Typically, we would do

```julia-repl
julia> using Statistics
julia> mean(rand(1000))
```

Now if we try to run this on processor 2 we get

```julia-repl
julia> fetch(@spawnat 2 mean(rand(1000)))
```

I.E., the function `mean` is not defined on worker 2. This is because `using Statistics` only brought Statistics into the scope of the manager process. If we want to load this package on worker 2 we then need to run

```julia-repl
julia> fetch(@spawnat 2 eval(:(using Statistics)))
```

Rerunning the above example gives the expected result

```julia-repl
julia> fetch(@spawnat 2 mean(rand(1000)))
```

Now calling this in every process could potentially be annoying. To simplify this Julia provides the `@everywhere` macro

```julia-repl
julia> @everywhere using Statistics
```

which loads the module Statistics on every Julia worker and manager processor.

## Distributed computation

While remotecall and `spawnat` provide granular control of multi-processor parallelism often we are interested in loop or map-reduce based parallelism. For instance, suppose we consider our previous map or `apply_sum` function. We can easily turn this into a distributed program using the `@distributed` macro

```julia-repl
julia> function distributed_apply_sum(f, x)
    @distributed (+) for i in eachindex(x)
        f(x[i])
    end
end
julia> d = randn(1_000_000)
julia> using BenchmarkTools
julia> @benchmark distributed_apply_sum($(x->exp(-x)), $d)
```

One important thing to note is that the `@distributed` macro uses Julia's static scheduler. This means that the for loop is automatically split evenly among all workers. For the above calculation this make sense since `f` is a cheap variable. However, suppose that `f` is extremely expensive and its run time varies greatly depending on its argument. A trivial example of this would be

```julia-repl
julia> @everywhere function dynamic_f(x)
    if abs(x) < 1
        return x
    else
        sleep(5)
        return 2*x
    end
end
```

In this case, rather than equally splitting the run-time across all processes, it makes sense to assign work to processors as they finish their current task. This is known as a **dynamic scheduler** and is provided in julia by `pmap`

```julia-repl
julia> x = randn(10)
julia> @time out = pmap(dynamic_f, x)
```

which is 2x faster than using the usual distributed function

```julia-repl
julia> @time out = distributed_apply_sum(dynamic_f, x)
```

However, for cheaper operations

```julia-repl
julia> @btime out = sum(pmap(exp, x))
julia> @btime out = distributed_apply_sum(exp, d)
```

We find that `@distributed` is faster since it has less communication overhead. Therefore, the general recommendation is to use `@distributed` when reducing over cheap and consistent function, and to use `pmap` when the function is expensive.
"""

# ╔═╡ 3aae32a9-72f8-456a-b719-0c04b9933593
md"""
# Summary

!!! note ""

    * In this tutorial we have shown how Julia provides an extensive library of parallel computing facilities. From single-core SIMD, to multi-threading, GPU computing, and distributed computation. Each of these can be used independently or together.

	* In addition to the packages used in this tutorial, there are several other potential parallel processing packages in the Julia ecosystem. Some of these are:

	* [`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl): Similar to the python dask package that represents parallel computation using a directed acylic graph or DAG. This is built on Distributed and is useful for a more functional approach to parallel programming. It is more common in data science applications
	* [`MPI.jl`](https://github.com/JuliaParallel/MPI.jl): The Julia bindings to the MPI standard. The standard parallel workhorse in HPC.
	* [`Elemental.jl`](https://github.com/JuliaParallel/Elemental.jl) links to the C++ distributed linear algebra and optimization package.
	* [`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl)
"""

# ╔═╡ 12097483-e14e-46bf-9070-11333fa64742
md"""
# Problems
!!! tip "Remember that you can get help either through `?` in a REPL or with "Live Docs" right here in Pluto (lower right-hand corner)"
"""

# ╔═╡ 3888d3c7-4e48-40f2-a32d-2c6abc45b792
md"""
## 1: Serial Computation
!!! warning ""
    * Create a function that adds two values together and returns the result.
	  - See the `serial_add!() function below.
    * Create three arrays having 65536 (2^16) elements.
	  - E.g., N = 2^12; x = rand(N); y = rand(N), out = zero(x)
	* Time or benchmark the serial_add!() function.
	  - E.g., @benchmark serial_add!(x, y, out)
	* What is the median execution time?
	* What is effective CPU processor speed?
	  - Hint: 1/(median-time)/array-length
	* What is the speed of your processor?
	* Is the effective speed greater than the processor speed?
	  - If yes, then Julia has vectorized the computation.

```julia-repl
julia> function serial_add!(out, x, y)
	for i in eachindex(x, y)
		out[i] = x[i] + y[i]
	end
	return out
end
```

!!! note
	The `!` character is appended to the function name to indicate that one or more arguments may be mutated or change per the Julia naming convention.
"""

# ╔═╡ 34ad1196-a1d7-4118-b4da-426af6826c7d
md"""
Analyzing this on a Ryzen 7950x, it appears that the summation is 53.512 ns, or each
addition takes only 0.05ns! Inverting this number would naively suggest that the computer I am using has a 19 GHz processor!

SIMD is the reason for this performance. Namely Julia's was able to automatically apply its auto-vectorization routines to use SIMD to accelerate the program.

To confirm that Julia was able to vectorize the loop we can use the introspection tool
```julia
@code_llvm serial_all!(out, x, y)
```
"""

# ╔═╡ a872cf65-a11e-4371-9d4d-41ea92c55369
md"""
This outputs the LLVM IR and represents the final step of Julia's compilation pipeline
before it is converted into native machine code. While the output of `@code_llvm` is
complicated to check that the compiler effectively used SIMD we can look for something
similar to

```
   %wide.load30 = load <4 x double>, <4 x double>* %55, align 8
; └
; ┌ @ float.jl:383 within `+`
   %56 = fadd <4 x double> %wide.load, %wide.load27
```

This means that for each addition clock, we are simultaneously adding four elements of the array together. As a sanity check, this means that I have a 19/4 = 4.8 GHz processor which is roughly in line with the Ryzen 7950x reported speed.
"""

# ╔═╡ 15c30e6e-c178-4500-a850-9ee424dcba21
md"""
## 2: Vectorization Using Packages
!!! warning ""
    *
"""

# ╔═╡ 3de353d3-ef0c-4e25-b52c-189061adac12
md"""
### Vectorizing Julia Code with Packages

Proving that a program can SIMD however can be difficult, and sometimes the compiler
won't effectively auto-vectorize the code. Julia however provides a number of tools that
can help the user to more effectively use SIMD. The most low-level of these libraries
is [`SIMD.jl`](https://github.com/eschnett/SIMD.jl). However,  most users never need to use SIMD.jl directly (for an introduction
see <http://kristofferc.github.io/post/intrinsics/>. Instead most Julia users will use more-upstream packages, such as [`LoopVectorization.jl`](https://github.com/JuliaSIMD/LoopVectorization.jl).

To see `LoopVectorization` in action let's change our above example to the slightly more complicated function.

```julia
function serial_sinadd(out, x, y)
	for i in eachindex(out, x, y)
		out[i] = x[i] + sin(y[i])
	end
	return out
end
```
"""

# ╔═╡ 57bd871d-06fc-4050-9024-aaaf52297d0a
md"""
Again lets start with a baseline evaluation
```julia
@benchmark serial_sinadd($out, $x, $y)
```
"""

# ╔═╡ 566eb7e1-0e2f-4ea7-8770-a6b2c95c1eb4
md"""
Running this example will show that the code is a lot slower than our previous example! Part of this is because `sin` is expensive, however we can also check whether the code was vectorized using the `@code_llvm`.
```julia
@code_llvm serial_sinadd(out, x, y)
```
"""

# ╔═╡ 7f0ff927-71ea-4ab9-99aa-c4a6655b545c
md"""
Analyzing the output does show that Julia/LLVM was unable to automatically vectorize the expression. The reason for this is complicated and won't be discussed. However, we can fix this with
loop vectorization and its `@turbo` macro

```julia
using LoopVectorization
```
"""

# ╔═╡ ccf102f3-9e85-4f70-b65e-6b4b056cf7e3
md"""
```julia
function serial_sinadd_turbo(out, x, y)
	@turbo for i in eachindex(out, x, y)
		out[i] = x[i] + sin(y[i])
	end
	return out
end
```
"""

# ╔═╡ 540326cd-5f2c-4b07-8dd6-1c65f63af7d6
md"""
```julia
@benchmark serial_sinadd_turbo($out, $x, $y)
```
"""

# ╔═╡ 1364924b-0cbd-443d-a319-9701708cbd15
md"""
And boom we get large speed increase (factor of 2 on a Ryzen 7950x) by simply adding the `@turbo` macro to our loop.
"""

# ╔═╡ 5b559c5a-10c8-4636-bdd1-ea73d1187854
md"""
!!! note
	Vectorization in Python and R is different from that of Julia. In Python, vectorization refers to placing all your variables in some vector container, like a Numpy array, so that the operation is executed using a C or Fortran library.
"""

# ╔═╡ 06e4b1e3-00cb-425a-866d-f0d50591c646
md"""
## 3: Threads.@threads
!!! warning ""
    *
"""

# ╔═╡ e468d9fd-ead0-4ce4-92b1-cb96132f6921
md"""
```julia
function threaded_add!(out, x, y)
	Threads.@threads for i in eachindex(out, x, y)
		out[i] = x[i] + y[i]
	end
	return out
end
```
"""

# ╔═╡ 478eaa1d-509a-4fba-8b65-cb45561f9157
md"""
And benchmarking:

```julia
@benchmark threaded_add!($out, $x, $y)
```
"""

# ╔═╡ c815af66-cb82-4dd0-a4b8-3c9cb4a8d9f2
md"""
This is actually slower than what we previously got without threading! This is because
threading has significant overhead! For simple computations, like adding two small vectors the overhead from threading dominates over any benefit you gain from using multiple threads.

In order to gain a benefit from threading our operation needs to:

1. Be expensive enough that the threading overhead is relatively minor
2. Be applied to a large enough vector to limit the threading overhead.

To see the benefit of threading we can then simply increase the number of operations
"""

# ╔═╡ 093c2764-c40f-41af-bf66-7b253240e339
md"""
```julia
xlarge = rand(2^20)
```
"""

# ╔═╡ 46855489-3e47-463a-8e53-4af4929f26b0
md"""
```julia
ylarge = rand(2^20)
```
"""

# ╔═╡ d2d65a34-38d9-4db1-8c2d-0dc9364cb5b1
md"""
```julia
outlarge = rand(2^20)
```
"""

# ╔═╡ c06da2eb-ed9f-4986-854c-9b8d830e662b
md"""
Get the baseline again
```julia
@benchmark serial_add!($outlarge, $xlarge,  $ylarge)
```
"""

# ╔═╡ 07eddd9c-c53f-49e7-9d61-2f5d54711a1c
md"""
Now test the threading example
```julia
@benchmark threaded_add!($outlarge, $xlarge,  $ylarge)
```
"""

# ╔═╡ 45639208-ec9f-4aef-adb0-7a2c4467353a
md"""
Now, we are starting to see the benefits of threading for large enough vectors.
To determine whether threading is useful, a user should benchmark the code. Additionally, memory bandwidth limitations are often important and so multi-threaded code should also do as few allocations as possible.
"""

# ╔═╡ a4382806-bc60-4e22-85e2-6e067451c5bb
md"""
## 4: Thread Issues
!!! warning ""
    *
"""

# ╔═╡ bd78505c-904c-4e65-9160-6b3ebf02c21e
md"""
```julia
function apply_sum(f, x)
	s = zero(eltype(x))
	for i in eachindex(x)
		@inbounds s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ 32068e63-5ad5-4d0d-bee6-205597db610b
md"""
Now apply this to our large vector
```julia
apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ 5c5ce94e-1411-4b26-af48-2cd836b0857c
md"""
A naive threaded implementation of this would be to just prepend the for-loop with the @threads macro

```julia
function naive_threaded_apply_sum(f, x)
	s = zero(eltype(x))
	Threads.@threads for i in eachindex(x)
		@inbounds s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ f4602617-c87b-4ce9-bbd0-7d3715b5c7e1
md"""
```julia
naive_threaded_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ 2a9f6170-b3d6-4fbb-ba48-2f82098b3849
md"""
We see that the naive threaded version gives the incorrect answer. This is because we have multiple threads writing to the same location in memory resulting in a race condition. If we run this block multiple times (**try this**) you will get different answers depending on the essentially random order that each thread writes to `s`.

To fix this issue there are two solutions. The first is to create a separate variable that holds the sum for each thread
"""

# ╔═╡ 0fbce4a6-0a0c-4251-be50-c13add4c4768
md"""
```julia
function threaded_sol1_apply_sum(f, x)
	partial = zeros(eltype(x), Threads.nthreads())
	# Do a partial reduction on each thread
	Threads.@threads for i in eachindex(x)
		id = Threads.threadid()
		@inbounds partial[id] += f(x[i])
	end
	# Now group everything together
	return sum(partial)
end
```
"""

# ╔═╡ 74ff761d-b1e4-4468-8f24-77fb84bda8ac
md"""
```julia
threaded_sol1_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ 73097493-1abe-4c6e-9965-9dde6c97611e
md"""
Which now gives the correct answer.
"""

# ╔═╡ aad7b000-7f4b-4901-8513-078eae85ca67
md"""
The other solution is to use Atomics. Atomics are special types that do the tracking in `threaded_sol1_apply_sum` for you. The benefit of this approach is that functionally the program looks very similar
"""

# ╔═╡ 2969c283-4105-4c25-ae39-9e169c195f00
md"""
```julia
function threaded_atomic_apply_sum(f, x)
	s = Threads.Atomic{eltype(x)}(zero(eltype(x)))
	Threads.@threads for i in eachindex(x)
		Threads.atomic_add!(s, f(x[i]))
	end
	# Access the atomic element and return it
	return s[]
end
```
"""

# ╔═╡ 21de2f77-b5ed-4b62-94e3-ca6e22a80e43
md"""
```julia
threaded_atomic_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ 79222f00-3d55-4914-9d9d-b3c7b1ed6c69
md"""
Both approaches gives the same answer, however let's benchmark both solutions:

```julia
@benchmark threaded_sol1_atomic_apply_sum($(x->exp(-x)), $xlarge)
```
"""

# ╔═╡ 4768f5c4-b37b-4667-9b42-d0352c8b5dde
md"""
```julia
@benchmark threaded_atomic_apply_sum($(x->exp(-x)), $xlarge)
```
"""

# ╔═╡ dfa50bc7-2250-4326-b7a6-724a975c4928
md"""
The atomic solution is substantially slower than the manual solution. In fact, atomics should only be used if absolutely necessary. Otherwise the programmer should try to find a more manual solution.
"""

# ╔═╡ 3b65181e-da0e-4ee1-9636-7ccac657c259
md"""
## 5: High-Level Threads
!!! warning ""
    *
"""

# ╔═╡ 44ddfdd9-7898-4561-b46a-045bcc1ae467
md"""
```julia
floops_apply_sum(x->exp(-x), xlarge; executor=SerialEx())
```
"""

# ╔═╡ 872a2066-8c51-4597-89e8-5a902f40c2cc
md"""
```julia
floops_apply_sum(x->exp(-x), xlarge; executor=ThreadedEx())
```
"""

# ╔═╡ df842625-04af-43d0-b802-3e4a9841c172
md"""
Benchmarking the `Floops` version

```julia
@benchmark floops_apply_sum($(x->exp(-x)), $xlarge; executor=ThreadedEx())
```
"""

# ╔═╡ 529f73c3-b8ba-4b4b-bab1-7aa84c2a3a29
md"""
is almost as fast as our hand-written example, but requires less understanding of race-conditions in threading.
"""

# ╔═╡ a839d0b2-fd1b-4e7c-bc2b-e7a15f937da7
md"""
## 6: GPUs
!!! warning ""
    *
"""

# ╔═╡ 799de936-6c6d-402f-93db-771e7ec1ef51
md"""
Now let's load our array onto the GPU

For CUDA:
```julia
begin
	xlarge_gpu   = cu(xlarge)
	ylarge_gpu   = cu(ylarge)
	outlarge_gpu = cu(outlarge)
end
```

For other GPU providers replace `cu` with
```julia
# AMD
ROCArray(xlarge)
# Intel
oneArray(xlarge)
# M1 Mac
MtlArray(xlarge)
```
"""

# ╔═╡ 0218d82e-35b4-4109-bbc8-b1d51c97ab6f
md"""
```julia
function bcast_add!(out, x, y)
	out .= x .+ y
	return out
end
```
"""

# ╔═╡ 891a9803-7fd0-4a83-95ab-58b9bd44f8f2
md"""
!!! note
	Pay special attention to the `.=`. This ensures that no intermediate array is created on the GPU.
"""

# ╔═╡ 7ce8025e-16be-47e0-988d-85947cc4e359
md"""
Running this on the gpu is then as simple as
```julia
@benchmark bcast_add!($outlarge_gpu, $xlarge_gpu, $ylarge_gpu)
```

!!! note
	This will work with any of the GPU packages mentioned above!
"""

# ╔═╡ 2020675b-859b-4939-9f8d-138995ce1d18
md"""
However, at this point you may notice something. Nowhere in our algorithm did we specify
that this kernel is actually running on the GPU. In fact we could use the exact same function
using our CPU verions of the arrays
"""

# ╔═╡ 147bbd17-abf6-465f-abd0-895cb742f896
md"""
```julia
@benchmark bcast_add!($outlarge, $xlarge, $ylarge)
```
"""

# ╔═╡ ccf924ae-fada-4635-af68-ab1fb612a5bc
md"""
This reflects more general advice in Julia. Programs should be written generically. Julia's
dot syntax `.` has been written to be highly generic, so functions should more generally be
written using it than with generic loops, unless speed due to SIMD as with LoopVectorization,
or multi-threading is required. This programming style has been codified in
the [`SciMLStyle coding guide`](https://github.com/SciML/SciMLStyle).
"""

# ╔═╡ 144bb14e-861a-4665-8b50-513b0f463546
md"""
Similarly our more complicated function `serial_sinadd!` could also be written as:
"""

# ╔═╡ 13085fcb-75db-41ec-b8ad-b509798037d7
md"""
```julia
outlarge_gpu .= xlarge_gpu .+ sin.(ylarge_gpu)
```
"""

# ╔═╡ cfeda4c2-5881-4ae3-a220-ae8f7511d79f
md"""
## N:
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
# ╟─4083769b-0071-406b-b4c3-a5a6284d5600
# ╟─e6020e3a-77c7-11ed-2be9-e987cee1edf0
# ╟─4473cae3-9350-4741-8457-6bacb1def61b
# ╟─54d083d4-3bf8-4ed7-95b5-203e13cc3249
# ╟─40fbf241-6c38-4ed0-81e2-b44462baaf52
# ╟─dc8d70b5-0a0e-4547-b165-fd1d2a6f440d
# ╟─b2eb604f-9180-4e48-9ae5-04162583fb33
# ╟─3aae32a9-72f8-456a-b719-0c04b9933593
# ╟─12097483-e14e-46bf-9070-11333fa64742
# ╟─3888d3c7-4e48-40f2-a32d-2c6abc45b792
# ╟─34ad1196-a1d7-4118-b4da-426af6826c7d
# ╟─a872cf65-a11e-4371-9d4d-41ea92c55369
# ╟─15c30e6e-c178-4500-a850-9ee424dcba21
# ╟─3de353d3-ef0c-4e25-b52c-189061adac12
# ╟─57bd871d-06fc-4050-9024-aaaf52297d0a
# ╟─566eb7e1-0e2f-4ea7-8770-a6b2c95c1eb4
# ╟─7f0ff927-71ea-4ab9-99aa-c4a6655b545c
# ╟─ccf102f3-9e85-4f70-b65e-6b4b056cf7e3
# ╟─540326cd-5f2c-4b07-8dd6-1c65f63af7d6
# ╟─1364924b-0cbd-443d-a319-9701708cbd15
# ╟─5b559c5a-10c8-4636-bdd1-ea73d1187854
# ╠═06e4b1e3-00cb-425a-866d-f0d50591c646
# ╟─e468d9fd-ead0-4ce4-92b1-cb96132f6921
# ╟─478eaa1d-509a-4fba-8b65-cb45561f9157
# ╟─c815af66-cb82-4dd0-a4b8-3c9cb4a8d9f2
# ╟─093c2764-c40f-41af-bf66-7b253240e339
# ╟─46855489-3e47-463a-8e53-4af4929f26b0
# ╟─d2d65a34-38d9-4db1-8c2d-0dc9364cb5b1
# ╟─c06da2eb-ed9f-4986-854c-9b8d830e662b
# ╟─07eddd9c-c53f-49e7-9d61-2f5d54711a1c
# ╟─45639208-ec9f-4aef-adb0-7a2c4467353a
# ╠═a4382806-bc60-4e22-85e2-6e067451c5bb
# ╟─bd78505c-904c-4e65-9160-6b3ebf02c21e
# ╟─32068e63-5ad5-4d0d-bee6-205597db610b
# ╟─5c5ce94e-1411-4b26-af48-2cd836b0857c
# ╟─f4602617-c87b-4ce9-bbd0-7d3715b5c7e1
# ╟─2a9f6170-b3d6-4fbb-ba48-2f82098b3849
# ╟─0fbce4a6-0a0c-4251-be50-c13add4c4768
# ╟─74ff761d-b1e4-4468-8f24-77fb84bda8ac
# ╟─73097493-1abe-4c6e-9965-9dde6c97611e
# ╟─aad7b000-7f4b-4901-8513-078eae85ca67
# ╟─2969c283-4105-4c25-ae39-9e169c195f00
# ╟─21de2f77-b5ed-4b62-94e3-ca6e22a80e43
# ╟─79222f00-3d55-4914-9d9d-b3c7b1ed6c69
# ╟─4768f5c4-b37b-4667-9b42-d0352c8b5dde
# ╟─dfa50bc7-2250-4326-b7a6-724a975c4928
# ╠═3b65181e-da0e-4ee1-9636-7ccac657c259
# ╟─44ddfdd9-7898-4561-b46a-045bcc1ae467
# ╟─872a2066-8c51-4597-89e8-5a902f40c2cc
# ╟─df842625-04af-43d0-b802-3e4a9841c172
# ╟─529f73c3-b8ba-4b4b-bab1-7aa84c2a3a29
# ╠═a839d0b2-fd1b-4e7c-bc2b-e7a15f937da7
# ╟─799de936-6c6d-402f-93db-771e7ec1ef51
# ╟─0218d82e-35b4-4109-bbc8-b1d51c97ab6f
# ╟─891a9803-7fd0-4a83-95ab-58b9bd44f8f2
# ╟─7ce8025e-16be-47e0-988d-85947cc4e359
# ╟─2020675b-859b-4939-9f8d-138995ce1d18
# ╟─147bbd17-abf6-465f-abd0-895cb742f896
# ╟─ccf924ae-fada-4635-af68-ab1fb612a5bc
# ╟─144bb14e-861a-4665-8b50-513b0f463546
# ╟─13085fcb-75db-41ec-b8ad-b509798037d7
# ╠═cfeda4c2-5881-4ae3-a220-ae8f7511d79f
# ╟─34fcf5ed-037d-4483-bc41-085ab63ad41a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
