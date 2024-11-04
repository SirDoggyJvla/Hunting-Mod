--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Patches needed for Hunting Mod.

]]--
--[[ ================================================ ]]--

-- requirements
local HuntingMod = require "HuntingMod_module"

-- Patches forage action to not be able to pick up animal tracks

require "Foraging/ISForageAction"

local old_ISForageAction_start = ISForageAction.start
function ISForageAction:start()
    -- if not discard, so we can properly discard with the discard option
    if not self.discardItems then
        -- verify it's one of our items
        local itemType = self.forageIcon.itemType
        local huntTarget = HuntingMod.ForageAnimalTracks[itemType]
        if huntTarget then
            ISTimedActionQueue.clear(self.character)
        else
            old_ISForageAction_start(self)
        end
    end
end