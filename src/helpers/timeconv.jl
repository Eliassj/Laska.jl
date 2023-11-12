##############################################################
#
# Functions for converting times (ms <-> samprate for example)
#
##############################################################

function mstosamplerate(experiment::T, ms::Int64) where {T<:AbstractExperiment}
    return ms * parse(Float64, experiment.meta["imSampRate"]) / 1000
end
