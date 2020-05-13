@pydef mutable struct MoveSystem <: GameSystem
    function update(self, dt)
        entities = self.gameworld.entities
        for component in self.components
            if !isnothing(component)
                entity = entities[component.entity_id]
                if hasproperty(entity, :cymunk_physics) && hasproperty(entity, :input)
                    body = entity.cymunk_physics.body
                    body.velocity += entity.input.input.direction()
                end
            end
        end
    end
end

Factory.register("MoveSystem", cls = MoveSystem)
