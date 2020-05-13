struct Input <: Component
    direction::Signal

    directionalInput(dict, first, second) =
        (get(dict, first, 0) + get(dict, second, 0)) > 0 ? 1 : 0

    Input(componentData::LazyJSON.Object{Nothing,String}) =
        new(async_signal(dict -> begin
        x1 = directionalInput(dict, "up", "w")
        x2 = directionalInput(dict, "down", "s")
        y1 = directionalInput(dict, "right", "a")
        y2 = directionalInput(dict, "left", "d")
        println((x1 - x2, y1 - y2))
        return (x1 - x2, y1 - y2)
    end, inputDict))
end
