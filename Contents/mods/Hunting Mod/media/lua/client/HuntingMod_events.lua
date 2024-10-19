--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Events of Hunting Mod.

]]--
--[[ ================================================ ]]--

-- requirements
local HuntingMod = require "HuntingMod_module"
require "HuntingMod_main"
require "HuntingMod_butcher"
require "HuntingMod_conditions"
require "HuntingMod_debug"

Events.onFillSearchIconContextMenu.Add(HuntingMod.onFillSearchIconContextMenu)

Events.OnPostRender.Add(HuntingMod.RenderHighLights)

Events.OnFillInventoryObjectContextMenu.Add(HuntingMod.OnFillInventoryObjectContextMenu)

Events.OnFillWorldObjectContextMenu.Add(HuntingMod.OnFillWorldObjectContextMenu)