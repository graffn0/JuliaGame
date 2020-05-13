inputDict = Signal(Dict())

function triggerKeyboardDown(object::PyObject, keycode, text, modifiers)
    for key in keycode
        inputDict[][key] = 1
    end
    inputDict(inputDict[])
    return nothing
end

function triggerKeyboardUp(object::PyObject, keycode)
    _, key = keycode
    inputDict[][key] = 0
    inputDict(inputDict[])
    return nothing
end
