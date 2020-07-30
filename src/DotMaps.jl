module DotMaps

export DotMap

"""
   DotMaps.DotMap(::AbstractDict)

Constructs a DotMap from a Dict.  This provides the same functionaliity as dictionaries, but allows indexing with `.` instead of (or in addition to) `[""]`.
"""
mutable struct DotMap
    __dict__ ::Dict{Symbol,Any}
    DotMap() = new(Dict{Symbol,Any}())
end

function DotMap(d::AbstractDict)
   dm = DotMap()
   for (k, v) in d
      dm.__dict__[Symbol(k)] = DotMap(v)
   end
   return dm
end

DotMap(d::Any) = d

"""
   DotMaps.todict(::DotMap; keys_as_strings=false)

Constructs a Dict from a DotMap. If `keys_as_strings`, the keys will be `String` instead of `Symbol`.
"""
function todict(obj::DotMap; keys_as_strings::Bool = false)
   dict = Dict()
   for (k, v) in obj
      nk = keys_as_strings ? string(k) : k
      dict[nk] = todict(v, keys_as_strings = keys_as_strings)
   end

   return dict
end

# return at leaves
todict(obj::Any; keys_as_strings::Bool = false) = obj

# make dots work
function Base.getproperty(obj::DotMap, name::Symbol)
   if name == :__dict__
      return getfield(obj, name)
   else
      return obj.__dict__[name]
   end
end

# make dictionary indexing work
Base.getindex(obj::DotMap, name::Symbol) = Base.getindex(obj.__dict__, name)
Base.getindex(obj::DotMap, name::Any) = Base.getindex(obj, Symbol(name))

Base.setindex!(obj::DotMap, x, name::Symbol) = Base.setindex!(obj.__dict__, x, name)
Base.setindex!(obj::DotMap, x::Dict, name::Symbol) = Base.setindex!(obj.__dict__, DotMap(x), name)
Base.setindex!(obj::DotMap, x, name) = Base.setindex!(obj, x, Symbol(name))

# assignment with dots
Base.setproperty!(obj::DotMap, name::Symbol, x) = Base.setindex!(obj, x, name)

# iteration
Base.iterate(obj::DotMap) = Base.iterate(obj.__dict__)
Base.iterate(obj::DotMap, s::Any) = Base.iterate(obj.__dict__, s)
Base.length(obj::DotMap) = Base.length(obj.__dict__)
Base.firstindex(obj::DotMap) = Base.firstindex(obj.__dict__)
Base.lastindex(obj::DotMap) = Base.lastindex(obj.__dict__)

# dictionary methods
Base.keys(obj::DotMap) = Base.keys(obj.__dict__)
Base.values(obj::DotMap) = Base.values(obj.__dict__)
Base.collect(obj::DotMap) = Base.collect(obj.__dict__)

# retrieval/modification
Base.get(obj::DotMap, key::Symbol, default) = Base.get(obj.__dict__, key, default)
Base.get(obj::DotMap, key::Any, default) = Base.get(obj.__dict__, Symbol(key), default)
Base.get!(obj::DotMap, key::Symbol, default) = Base.get!(obj.__dict__, key, default)
Base.get!(obj::DotMap, key::Any, default) = Base.get!(obj.__dict__, Symbol(key), default)
Base.getkey(obj::DotMap, key::Symbol, default) = Base.getkey(obj.__dict__, key, default)
Base.getkey(obj::DotMap, key::Any, default) = Base.getkey(obj.__dict__, Symbol(key), default)
Base.pop!(obj::DotMap, key::Symbol) = Base.pop!(obj.__dict__, key)
Base.pop!(obj::DotMap, key::Any) = Base.pop!(obj.__dict__, Symbol(key))
Base.delete!(obj::DotMap, key::Symbol) = Base.pop!(obj.__dict__, key)
Base.delete!(obj::DotMap, key::Any) = Base.pop!(obj.__dict__, Symbol(key))
Base.filter!(pred, obj::DotMap) = Base.filter!(pred, obj.__dict__)
Base.filter(pred, obj::DotMap) = DotMap(Base.filter(pred, obj.__dict__))

# about this dict
Base.propertynames(obj::DotMap) = Base.keys(obj.__dict__)
Base.isempty(obj::DotMap) = Base.isempty(obj.__dict__)
Base.show(obj::DotMap) = Base.show(obj.__dict__)

# containment
Base.in(key::Symbol, obj::DotMap) = Base.in(key, obj.__dict__)
Base.in(key::Any, obj::DotMap) = Base.in(Symbol(key), obj.__dict__)
Base.haskey(obj::DotMap, key::Symbol) = Base.haskey(obj.__dict__, key)
Base.haskey(obj::DotMap, key::Any) = Base.haskey(obj.__dict__, Symbol(key))

end
