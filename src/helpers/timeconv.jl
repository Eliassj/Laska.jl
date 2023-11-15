##############################################################
#
# Functions for converting times (ms <-> samprate for example)
#
##############################################################

function mstosamplerate(experiment::T, ms::Int64) where {T<:AbstractExperiment}
    return ms * parse(Float64, experiment.meta["imSampRate"]) * 0.001
end

function sampleratetoms(experiment::T, sample::Int64) where {T<:AbstractExperiment}
    return sample / (experiment.meta["imSampRate"] * 0.001)
end

function sampleratetoms(vec::Vector{T}, samplerate::U) where {T<:Real,U<:Real}
    fac = 1 / (samplerate * 0.001)
    out::Vector{Float64} = Vector(undef, length(vec))
    sampleratetoms!(out, vec, fac)
    return out
end

function sampleratetoms!(out::Vector{Float64}, in::Vector{T}, factor::Float64) where {T<:Real}
    for n in eachindex(in)
        out[n] = in[n] * factor
    end
end
