# DotMaps

[![Build Status](https://github.com/mcmcgrath13/DotMaps.jl/workflows/CI/badge.svg)](https://github.com/mcmcgrath13/DotMaps.jl/actions)

A wrapper for dictionaries that allows dot notation indexing as well as traditional bracket indexing.

```julia
dict = Dict("a"=>1, "b"=>2, "c" => Dict("d"=>3))
dm = DotMap(dict)

dm.c.d # returns 3
dm.c.e = 5
dm["c"].e # returns 5
```

**NOTE** This is not as performative as using normal dictionaries, but is nice for accessing deeply nested dictionary structures, such as large config/yaml/json files.
