--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Patches to vanilla functions of Immersive Hunting Remastered.

]]--
--[[ ================================================ ]]--

-- requirements
local ImmersiveHunting = require "ImmersiveHunting_module"
require "Foraging/ISForageIcon"

local old_ISForageIcon_new = ISForageIcon.new
function ISForageIcon:new(_manager, _forageIcon, _zoneData)
    local o = old_ISForageIcon_new(self,_manager, _forageIcon, _zoneData)

    -- verify it's one of our items
    local itemType = _forageIcon.itemType
    local huntTarget = ImmersiveHunting.ValidForageItems[itemType]
    if huntTarget then
        o.onMouseDoubleClick = function(...) end
    end

    return o
end