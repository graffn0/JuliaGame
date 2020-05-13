mutable struct Entity
    components::Dict{Symbol,Any}
end

function componentKeyToPy(s::Symbol)
    if s == :PhysicsComponent
        return "cymunk_physics"
    elseif s == :RotateStructure
        return "rotate_renderer"
    else
        return @> s string lowercasefirst
    end
end

function orderComponentKeysToPy(d::Dict{Symbol,Any})
    dictCopy = copy(d)
    components::Vector{String} = []
    componentOrder = [:Position, :Rotate, :RotateStructure, :PhysicsComponent]
    for component in componentOrder
        if haskey(dictCopy, component)
            push!(components, componentKeyToPy(component))
            delete!(dictCopy, component)
        end
    end
    if length(dictCopy) > 0
        components = @>> dictCopy begin
            keys
            collect
            map(string)
            map(lowercasefirst)
            vcat(components)
        end
    end
    return components
end

toPy(c::Component) = PyDict(Dict(c |> typeof |> string |> lowercasefirst => c))

toPy(e::Entity) =
    PyDict(Dict(componentKeyToPy(key) => toPy(value) for (key, value) in e.components))

toPy(v::Vector{Symbol}) = map(componentKeyToPy, v)

toPy(a::Any) = a

struct EntityFactory
    entityData::String

    EntityFactory(file::String) = @> file read(String) new
end

function createEntity(e::EntityFactory, name::String, pos::Tuple{Number,Number})
    components::Dict{Symbol,Any} = Dict()
    for (k, v) in LazyJSON.value(e.entityData)[name]
        val = Symbol(k)
        components[val] = @eval $val($v)
    end
    components[:Position] = pos
    components[:Rotate] = 0
    return Entity(components)
end
