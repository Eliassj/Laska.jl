##############################################################
#
# Functions for converting times (ms <-> samprate for example)
#
##############################################################

function mstosamplerate(experiment::PhyOutput{T}, ms::T) where {T<:Real}
    return ms * parse(T, experiment.meta["imSampRate"]) / 1000
end
