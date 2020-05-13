@pydef mutable struct TestGame <: Widget
    function on_kv_post(self, args...)
        # Initialise systems for 4 map layers and get the renderer and animator names
        self.map_layers, self.map_layer_animators = setupMap(
            self.gameworld,
            ["general", "map"],
        )

        # Init gameworld with all the systems , self.map_layers, self.map_layer_animators
        self.gameworld.init_gameworld(
            vcat(
                [
                 "cymunk_physics",
                 "rotate_renderer",
                 "rotate",
                 "position",
                 "cymunk_touch",
                 "color",
                 "camera1",
                 "tile_map",
                 "input",
                ],
                self.map_layers,
                self.map_layer_animators,
            ),
            callback = self.init_game,
        )
    end

    function init_game(self)
        # Set the camera1 render order to render lower layers first
        self.camera1.render_system_order = Iterators.Reverse(self.map_layers)

        map_manager = self.gameworld.managers[:"map_manager"]

        # The map file to load
        # Change to hexagonal/isometric/isometric_staggered.tmx for other maps
        # Load TMX data and create a TileMap from it resource_find(filename)
        map_name = map_utils.parse_tmx(
            "assets/maps/isometric_staggered.tmx",
            self.gameworld,
        )

        # Initialise each tile as an entity in the gameworld
        map_utils.init_entities_from_map(map_manager.maps[map_name], self.checkMapData)

        # Initialise keyboard input
        self._keyboard = Window.request_keyboard(self._keyboard_closed, self)
        self._keyboard.bind(on_key_down = triggerKeyboardDown)
        self._keyboard.bind(on_key_up = triggerKeyboardUp)

        # Initialise gameworld
        self.gameworld.add_state(
            state_name = "main",
            systems_added = vcat(["rotate_renderer"], self.map_layers),
            systems_removed = [],
            systems_paused = [],
            systems_unpaused = vcat(
                ["rotate_renderer", "input"],
                self.map_layer_animators,
                self.map_layers,
            ),
            screenmanager_screen = "main",
        )
        self.gameworld.state = "main"
    end

    function _keyboard_closed(self)
        self._keyboard.unbind(on_key_down = triggerKeyboardDown)
        self._keyboard.unbind(on_key_up = triggerKeyboardUp)
        self._keyboard = nothing
    end

    update(self, dt) = self.gameworld.update(dt)

    function checkMapData(self, components, list)
        self.gameworld.init_entity(components, list)
    end

    function draw_some_stuff(self)
        for x = 1:20
            pos = rand(0:Window.width), rand(0:Window.height)
            asteroid = createEntity(entityFactory, "Asteroid", pos)
            pc = asteroid.components[:PhysicsComponent]
            physics = PhysicsComponent(
                pc.mainShape,
                (rand(-500:500), rand(-500:500)),
                pos,
                deg2rad(rand(-360:360)),
                deg2rad(rand(-150:-150)),
                pc.velocityLimit,
                pc.angleVelocityLimit,
                pc.mass,
                pc.colShapes,
            )
            asteroid.components[:PhysicsComponent] = physics
            self.gameworld.init_entity(
                toPy(asteroid),
                orderComponentKeysToPy(asteroid.components),
            )
        end
    end
end
