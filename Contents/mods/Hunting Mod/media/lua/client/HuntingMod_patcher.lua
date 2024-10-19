--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Patches to vanilla functions of Hunting Mod.

]]--
--[[ ================================================ ]]--

-- requirements
local HuntingMod = require "HuntingMod_module"
require "Foraging/ISForageIcon"

local old_ISForageIcon_new = ISForageIcon.new
function ISForageIcon:new(_manager, _forageIcon, _zoneData)
    local o = old_ISForageIcon_new(self,_manager, _forageIcon, _zoneData)

    -- verify it's one of our items
    local itemType = _forageIcon.itemType
    local huntTarget = HuntingMod.ForageAnimalTracks[itemType]
    if huntTarget then
        o.onMouseDoubleClick = function(...) end
    end

    return o
end