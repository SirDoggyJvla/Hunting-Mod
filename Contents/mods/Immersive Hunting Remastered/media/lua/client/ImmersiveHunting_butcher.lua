--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Handles the butchering of Immersive Hunting Remastered.

]]--
--[[ ================================================ ]]--

-- requirements
local ImmersiveHunting = require "ImmersiveHunting_module"
require "ImmersiveHunting_conditions"

-- localy initialize player and values
local client_player = getPlayer()
local function initTLOU_OnGameStart(playerIndex, player_init)
	client_player = getPlayer()

    local AnimalBodies = ImmersiveHunting.AnimalBodies
    for track,animal in pairs(ImmersiveHunting.ValidForageItems) do
        local meatItem = animal.meat
        if meatItem then
            AnimalBodies[animal.dead] = animal
        end
    end
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)

ImmersiveHunting.Butcher = function(player,carcass,animal,hungerAmount,amountHarvest)
    -- drop carcass on floor if not already a world item
    local worldItem = carcass:getWorldItem()
    if not worldItem then
        ISTimedActionQueue.add(ISDropWorldItemAction:new(player, carcass, player:getSquare(), 0, 0, 0, 0, false))
        carcass:getWorldItem()
    end

    -- timed action to butcher
    ISTimedActionQueue.add(ImmersiveHunting_ISButcher:new(player,carcass,animal,hungerAmount,amountHarvest,200))
end

ImmersiveHunting.OnFillInventoryObjectContextMenu = function(playerIndex, context, items)
    -- retrieve player
	local player = getSpecificPlayer(playerIndex)

    -- check if item is animal body
    local AnimalBodies = ImmersiveHunting.AnimalBodies
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

            local option = context:addOption(getText("ContextMenu_ImmersiveHunting_Butcher"),player,ImmersiveHunting.Butcher,item,animal,hungerAmount,amountHarvest)

            local tooltip = ISWorldObjectContextMenu.addToolTip()

            -- set the meat item texture
            local scriptItem = getScriptManager():FindItem(animal.meat)
            if scriptItem then
                local texture = scriptItem:getNormalTexture()
                if texture then
                    tooltip:setTexture(texture:getName())
                end
            end

            local equipedItem = player:getPrimaryHandItem()

            if not instanceof(equipedItem,"HandWeapon") then
                tooltip.description = getText("Tooltip_ImmersiveHunting_NeedSharpKnife",amountHarvest)
                option.toolTip = tooltip
                option.notAvailable = true
                return
            end
            ---@cast equipedItem HandWeapon

            local tags = equipedItem:getTags()

            if not tags:contains("SharpKnife") then
                tooltip.description = getText("Tooltip_ImmersiveHunting_NeedSharpKnife",amountHarvest)
                option.toolTip = tooltip
                option.notAvailable = true

            else
                tooltip.description = getText("Tooltip_ImmersiveHunting_ButcherAmount",amountHarvest)
                option.toolTip = tooltip

            end
        end
    end
end
