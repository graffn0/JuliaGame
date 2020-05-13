@pydef mutable struct DefaultGameSystem <: GameSystem
    # Loads default arguments when initializing any component for this
    # gamesystem. This allows the programmer to define a
    # default_args dict. Default args can save a lot of typing for complex components

    defaultArgs = Dict()

    function __init__(self, kwargs...)
        GameSystem.__init__(self, kwargs...)
    end

    function init_component(self, componentIndex, entityId, zone, args)
        #Start with default arguments and replace entries with user defined args
        # on initialization (pre-filtering)
        combinedArgs = copy(self.defaultArgs)
        merge!(combinedArgs, args)
        GameSystem.init_component(componentIndex, entityId, zone, combinedArgs)
        self.create_sys_entity(componentIndex, entityId, zone, args)
    end

    function create_sys_entity(self, componentIndex, entityId, zone, args) end
end

Factory.register("DefaultGameSystem", cls = DefaultGameSystem)
