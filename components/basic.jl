abstract type Component end

Position(componentData::LazyJSON.Object{Nothing,String}) =
    (componentData["x"], componentData["y"])

Rotate(componentData::LazyJSON.Object{Nothing,String}) = componentData["rotate"]

Velocity(componentData::LazyJSON.Object{Nothing,String}) =
    (componentData["x"], componentData["y"])

struct Animation <: Component
    name::String
    loop::Bool

    Animation(componentData::LazyJSON.Object{Nothing,String}) =
        new(componentData["name"], componentData["loop"])
end

toPy(a::Animation) = PyDict(Dict("name" => a.name, "loop" => a.loop))

struct RotateStructure <: Component
    texture::String
    size::Tuple{Float64,Float64}
    render::Bool

    RotateStructure(componentData::LazyJSON.Object{Nothing,String}) = new(
        componentData["texture"],
        (componentData["sizeX"], componentData["sizeY"]),
        true
    )
end

toPy(r::RotateStructure) =
    PyDict(Dict("texture" => r.texture, "size" => r.size, "render" => r.render))

struct TileMap <: Component
    name::String
    position::Tuple{Int,Int}
end

toPy(t::TileMap) = PyDict(Dict("name" => t.name, "pos" => t.position))

struct MapLayer <: Component
    model::String
    texture::String
end

toPy(m::MapLayer) = PyDict(Dict("model" => m.model, "texture" => m.texture))
