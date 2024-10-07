--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Events of Immersive Hunting Remastered.

]]--
--[[ ================================================ ]]--

-- requirements
local ImmersiveHunting = require "ImmersiveHunting_module"
require "ImmersiveHunting_main"
require "ImmersiveHunting_butcher"
require "ImmersiveHunting_conditions"
require "ImmersiveHunting_debug"

Events.onFillSearchIconContextMenu.Add(ImmersiveHunting.onFillSearchIconContextMenu)

Events.OnPostRender.Add(ImmersiveHunting.RenderHighLights)

Events.OnFillInventoryObjectContextMenu.Add(ImmersiveHunting.OnFillInventoryObjectContextMenu)

Events.OnFillWorldObjectContextMenu.Add(ImmersiveHunting.OnFillWorldObjectContextMenu)