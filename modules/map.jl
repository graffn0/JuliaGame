struct SystemArguments
    zones::Vector{String}
    frameCount::Int
    gameview::String
    shaderSource::String
end

function toPy(s::SystemArguments)
    PyDict(Dict(
        "zones" => s.zones,
        "frame_count" => s.frameCount,
        "gameview" => s.gameview,
        "shader_source" => s.shaderSource,
    ))
end

function setupMap(gameworld::PyObject, zones::Vector{String})
    # Args required for Renderer init
    mapRenderArgs = SystemArguments(zones, 2, "camera1", "assets/glsl/positionshader.glsl")

    # Args for AnimationSystem init
    mapAnimArgs = Dict("zones" => zones)

    # Args for PolyRenderer init
    mapPolyArgs = SystemArguments(zones, 2, "camera1", "assets/glsl/poscolorshader.glsl")

    map_utils.load_map_systems(
        4,
        gameworld,
        toPy(mapRenderArgs),
        PyDict(mapAnimArgs),
        toPy(mapPolyArgs),
    )
end
