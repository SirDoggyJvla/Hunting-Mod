--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Handles the butchering of Hunting Mod.

]]--
--[[ ================================================ ]]--

-- requirements
local HuntingMod = require "HuntingMod_module"
require "HuntingMod_conditions"

-- localy initialize player and values
local client_player = getPlayer()
local function initTLOU_OnGameStart(playerIndex, player_init)
	client_player = getPlayer()

    local AnimalBodies = HuntingMod.AnimalBodies
    for _,animal in pairs(HuntingMod.ForageAnimalTracks) do
        local meatItem = animal.meat
        if meatItem then
            AnimalBodies[animal.dead] = animal
        end
    end
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)

HuntingMod.Butcher = function(player,carcass,animal,hungerAmount,amountHarvest,knife)
    -- drop carcass on floor if not already a world item
    local worldItem = carcass:getWorldItem()
    if not worldItem then
        ISTimedActionQueue.add(ISDropWorldItemAction:new(player, carcass, player:getSquare(), 0, 0, 0, 0, false))
        carcass:getWorldItem()
    end

    -- equip gun if player tried to cheat and put it away
    if player:getPrimaryHandItem() ~= knife then
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, knife, 50, true))
    end

    -- timed action to butcher
    ISTimedActionQueue.add(HuntingMod_ISButcher:new(player,carcass,animal,hungerAmount,amountHarvest,200))
end

HuntingMod.OnFillInventoryObjectContextMenu = function(playerIndex, context, items)
    -- retrieve player
	local player = getSpecificPlayer(playerIndex)

    -- check if item is animal body
    local AnimalBodies = HuntingMod.AnimalBodies
	for i = 1,#items do
		-- retrieve the item
		local item = items[i]
		if not instanceof(item, "InventoryItem") then
            item = item.items[1];
        end

		-- if item is an animal body with a custom meat item
        local animal = AnimalBodies[item:getFullType()]
		if animal then
            local hungerAmount = item:getHungChange()
            local amountHarvest = math.ceil(-hungerAmount)

            -- verify if the player has a knife in hands, or retrieve one from the inventory
            local description, notAvailable
            local knife = player:getPrimaryHandItem()
            if not knife or not instanceof(knife,"HandWeapon") or not knife:getTags():contains("SharpKnife") then
                knife = player:getInventory():getFirstTagRecurse("SharpKnife")
                if not instanceof(knife,"HandWeapon") then
                    description, notAvailable = getText("Tooltip_HuntingMod_NeedSharpKnife",amountHarvest), true
                end
            end

            -- if no description, means the player has a knife
            if not description then
                description = getText("Tooltip_HuntingMod_ButcherAmount",amountHarvest)
            end

            -- create the option
            local option = context:addOption(getText("ContextMenu_HuntingMod_Butcher"),player,HuntingMod.Butcher,item,animal,hungerAmount,amountHarvest,knife)
            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip.description = description
            option.toolTip = tooltip
            option.notAvailable = notAvailable

            -- set the tooltip to use the meat item texture
            local scriptItem = getScriptManager():FindItem(animal.meat)
            if scriptItem then
                local texture = scriptItem:getNormalTexture()
                if texture then
                    tooltip:setTexture(texture:getName())
                end
            end
        end
    end
end
