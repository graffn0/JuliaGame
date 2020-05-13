@enum ShapeType box circle segment

function toShapeType(type::AbstractString)
    if type == "Box"
        return box
    elseif type == "Circle"
        return circle
    else
        return segment
    end
end

abstract type Shape <: Component end

struct Box <: Shape
    width::Float64
    height::Float64
    mass::Float64

    Box(componentData::LazyJSON.Object{Nothing,String}, mass::LazyJSON.Number{String}) =
        new(componentData["width"], componentData["height"], mass)
end

toPy(s::Box) = PyDict(Dict("width" => s.width, "height" => s.height, "mass" => s.mass))

struct Circle <: Shape
    innerRadius::Float64
    outerRadius::Float64
    mass::Float64
    offset::Tuple{Float64,Float64}

    Circle(componentData::LazyJSON.Object{Nothing,String}, mass::LazyJSON.Number{String}) =
        new(
            componentData["innerRadius"],
            componentData["outerRadius"],
            mass,
            (componentData["offsetX"], componentData["offsetY"]),
        )
end

toPy(s::Circle) = PyDict(Dict(
        "inner_radius" => s.innerRadius,
        "outer_radius" => s.outerRadius,
        "mass" => s.mass,
        "offset" => s.offset,
    ))

struct Segment <: Shape
    a::Tuple{Float64,Float64}
    b::Tuple{Float64,Float64}
    mass::Float64
    radius::Float64

    Segment(componentData::LazyJSON.Object{Nothing,String}, mass::LazyJSON.Number{String}) =
        new(
            (componentData["ax"], componentData["ay"]),
            (componentData["bx"], componentData["by"]),
            mass,
            componentData["radius"],
        )
end

toPy(s::Segment) =
    PyDict(Dict("a" => s.a, "b" => s.b, "mass" => s.mass, "radius" => s.radius))

struct ColShape <: Component
    shapeType::ShapeType
    elasticity::Float64
    collisionType::Int
    shapeInfo::Shape
    friction::Float64

    function ColShape(
        shape::AbstractString,
        shapeData::LazyJSON.Object{Nothing,String},
        mass::LazyJSON.Number{String},
    )
        shapeSym = Symbol(shape)
        shapeStruct = @eval $shapeSym($shapeData, $mass)
        new(toShapeType(shape), 0.6, 1, shapeStruct, 1.0)
    end
end

toPy(c::ColShape) = PyDict(Dict(
        "shape_type" => string(c.shapeType),
        "elasticity" => c.elasticity,
        "collision_type" => c.collisionType,
        "shape_info" => toPy(c.shapeInfo),
        "friction" => c.friction,
    ))

struct PhysicsComponent <: Component
    mainShape::ShapeType
    velocity::Tuple{Number,Number}
    position::Tuple{Number,Number}
    angle::Float64
    angularVelocity::Float64
    velocityLimit::Float64
    angleVelocityLimit::Float64
    mass::Float64
    colShapes::Vector{ColShape}
end

function PhysicsComponent(componentData::LazyJSON.Object{Nothing,String})
    mass = componentData["mass"]
    colShapes::Vector{ColShape} = []
    for data in get(componentData, "boxes", Dict())
        push!(colShapes, ColShape("Box", data, mass))
    end
    for data in get(componentData, "circles", Dict())
        push!(colShapes, ColShape("Circle", data, mass))
    end
    for data in get(componentData, "segments", Dict())
        push!(colShapes, ColShape("Segment", data, mass))
    end
    PhysicsComponent(
        toShapeType(componentData["mainShape"]),
        (0, 0),
        (0, 0),
        0,
        componentData["angularVelocity"],
        1000,
        deg2rad(200),
        mass,
        colShapes,
    )
end

toPy(p::PhysicsComponent) = PyDict(Dict(
        "main_shape" => string(p.mainShape),
        "velocity" => p.velocity,
        "position" => p.position,
        "angle" => p.angle,
        "angular_velocity" => p.angularVelocity,
        "vel_limit" => p.velocityLimit,
        "ang_vel_limit" => p.angleVelocityLimit,
        "mass" => p.mass,
        "col_shapes" => map(toPy, p.colShapes),
    ))
