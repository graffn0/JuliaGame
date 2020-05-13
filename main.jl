using Signals
using Lazy
# using Flux
using PyCall
using LazyJSON

# Kivy imports
pyimport("kivy")
App = pyimport("kivy.app").App
Widget = pyimport("kivy.uix.widget").Widget
SettingsWithSidebar = pyimport("kivy.uix.settings").SettingsWithSidebar
Clock = pyimport("kivy.clock").Clock
Window = pyimport("kivy.core.window").Window
Factory = pyimport("kivy.factory").Factory
resource_find = pyimport("kivy.resources").resource_find
ConfigParser = pyimport("kivy.config").ConfigParser

# Kivent imports
pyimport("kivent_core")
pyimport("kivent_cymunk")
GameWorld = pyimport("kivent_core.gameworld").GameWorld
PositionSystem2D = pyimport("kivent_core.systems.position_systems").PositionSystem2D
RotateSystem2D = pyimport("kivent_core.systems.rotate_systems").RotateSystem2D
RotateRenderer = pyimport("kivent_core.systems.renderers").RotateRenderer
GameSystem = pyimport("kivent_core.systems.gamesystem").GameSystem
TextureManager = pyimport("kivent_core.managers.resource_managers").texture_manager
map_utils = pyimport("kivent_maps.map_utils")
MapSystem = pyimport("kivent_maps.map_system").MapSystem
imghdr = pyimport("imghdr")

# Julia imports
include("components/basic.jl")
include("components/physics.jl")
include("components/input.jl")

include("entities/entity.jl")

include("systems/move.jl")

include("modules/map.jl")

include("utils/game.jl")
include("utils/inputEvents.jl")

# App setup
Window.size = (640, 640)
entityFactory = EntityFactory("entities/entities.json")

get_asset_path(asset, asset_loc) = string(asset_loc, "/", asset)
pyimport("__main__").get_asset_path = get_asset_path

TextureManager.load_atlas("assets/background_objects.atlas")

@pydef mutable struct TestApp <: App
    function build(self)
        self.settings_cls = SettingsWithSidebar
        self.use_kivy_settings = false
        setting = self.config.get("Graphics", "fullscreen")
        nothing
    end

    build_config(self, config) =
        config.setdefaults("Graphics", PyDict(Dict("fullscreen" => false)))

    build_settings(self, settings) =
        settings.add_json_panel("Graphics", self.config, "utils/settings.json")

    on_config_change(self, config, section, key, value) = print(config, section, key, value)
end

# TestApp().run()
