#####################
# Functions for filtering spikes/clusters
#####################


# Filtrera info innan spiketimes i constructor! (Innan den blir immutable)

"""
    filterinfo(df::DataFrame, f...)


Filter a dataframe using filters defined in f...\n
Example:

```
ex = :fr => x -> x > 2
filterinfo(df, ex)
```
"""
function filterinfo(df::DataFrame, f::Tuple)
    for e in f
        filter!(e, df)
    end
end

function filterphy!(p::PhyOutput, filters::Tuple)
    filterinfo(p._info, filters)
    ininfo(cluster) = cluster in p._info[!, "cluster_id"]
    p._spiketimes = p._spiketimes[findall(ininfo, p._spiketimes[:, 1]), :]
end
