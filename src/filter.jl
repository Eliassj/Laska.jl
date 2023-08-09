#####################
# Functions for filtering spikes/clusters
#####################

p=res

y = x -> x .> 2
function test(f)
    v = [1 2 4 9 8 6 3]
    
    return findall(f, v)
    
end

test(y)

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
function filterinfo(df::DataFrame, f...)
    for e in f
        filter!(e, df)
    end
end