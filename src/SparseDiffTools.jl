module SparseDiffTools

using Compat
using FiniteDiff
using ForwardDiff
using Graphs
using Graphs: SimpleGraph
using VertexSafeGraphs
using Adapt

using LinearAlgebra
using SparseArrays, ArrayInterface

import StaticArrays

using ForwardDiff: Dual, jacobian, partials, DEFAULT_CHUNK_THRESHOLD
using DataStructures: DisjointSets, find_root!, union!

using ArrayInterface: matrix_colors

using SciMLOperators
import SciMLOperators: update_coefficients, update_coefficients!
using Tricks: Tricks, static_hasmethod

abstract type AbstractAutoDiffVecProd end

export contract_color,
       greedy_d1,
       greedy_star1_coloring,
       greedy_star2_coloring,
       matrix2graph,
       matrix_colors,
       forwarddiff_color_jacobian!,
       forwarddiff_color_jacobian,
       ForwardColorJacCache,
       numauto_color_hessian!,
       numauto_color_hessian,
       autoauto_color_hessian!,
       autoauto_color_hessian,
       ForwardColorHesCache,
       ForwardAutoColorHesCache,
       auto_jacvec, auto_jacvec!,
       num_jacvec, num_jacvec!,
       num_vecjac, num_vecjac!,
       num_hesvec, num_hesvec!,
       numauto_hesvec, numauto_hesvec!,
       autonum_hesvec, autonum_hesvec!,
       num_hesvecgrad, num_hesvecgrad!,
       auto_hesvecgrad, auto_hesvecgrad!,
       JacVec, HesVec, HesVecGrad, VecJac,
       update_coefficients, update_coefficients!,
       value!

include("coloring/high_level.jl")
include("coloring/backtracking_coloring.jl")
include("coloring/contraction_coloring.jl")
include("coloring/greedy_d1_coloring.jl")
include("coloring/acyclic_coloring.jl")
include("coloring/greedy_star1_coloring.jl")
include("coloring/greedy_star2_coloring.jl")
include("coloring/matrix2graph.jl")
include("differentiation/compute_jacobian_ad.jl")
include("differentiation/compute_hessian_ad.jl")
include("differentiation/jaches_products.jl")
include("differentiation/vecjac_products.jl")

Base.@pure __parameterless_type(T) = Base.typename(T).wrapper
parameterless_type(x) = parameterless_type(typeof(x))
parameterless_type(x::Type) = __parameterless_type(x)

import Requires
import Reexport

function numback_hesvec end
function numback_hesvec! end
function autoback_hesvec end
function autoback_hesvec! end
function auto_vecjac end
function auto_vecjac! end
function ZygoteVecJac end
function ZygoteHesVec end

@static if !isdefined(Base, :get_extension)
    function __init__()
        Requires.@require Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f" begin
            include("../ext/SparseDiffToolsZygote.jl")
            Reexport.@reexport using .SparseDiffToolsZygote
        end
    end
end

export
       numback_hesvec, numback_hesvec!,
       autoback_hesvec, autoback_hesvec!,
       auto_vecjac, auto_vecjac!,
       ZygoteVecJac, ZygoteHesVec

end # module
