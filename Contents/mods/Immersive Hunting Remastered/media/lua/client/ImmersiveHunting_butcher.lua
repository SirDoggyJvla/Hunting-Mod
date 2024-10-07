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

    -- get animal bodies
    local AnimalBodies = ImmersiveHunting.AnimalBodies
    local animal, meat
    for _,v in pairs(ImmersiveHunting.AnimalTypes) do
        for i = 1,#v do
            animal = v[i]
            meat = animal.meat
            if animal.meat then
                AnimalBodies[animal.dead] = meat
            end
        end
    end
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)

ImmersiveHunting.Butcher = function(player,carcass,meatItem,hungerAmount,amountHarvest)
    -- drop carcass on floor if not already a world item
    local worldItem = carcass:getWorldItem()
    if not worldItem then
        ISTimedActionQueue.add(ISDropWorldItemAction:new(player, carcass, player:getSquare(), 0, 0, 0, 0, false))
        carcass:getWorldItem()
    end

    -- timed action to butcher
    ISTimedActionQueue.add(ImmersiveHunting_ISButcher:new(player,carcass,meatItem,hungerAmount,amountHarvest,200))
end

ImmersiveHunting.OnFillInventoryObjectContextMenu = function(playerIndex, context, items)
    -- retrieve player
	local player = getSpecificPlayer(playerIndex)

    -- check if item is animal body
    local AnimalBodies = ImmersiveHunting.AnimalBodies
	local item, meatItem
	for i = 1,#items do
		-- retrieve the item
		item = items[i]
		if not instanceof(item, "InventoryItem") then
            item = item.items[1];
        end

		-- if item is an animal body with a custom meat item
        meatItem = AnimalBodies[item:getFullType()]
		if meatItem then
            local hungerAmount = item:getHungChange()
            print("hungerAmount = "..tostring(hungerAmount))
            local amountHarvest = math.ceil(-hungerAmount)
            print("amountHarvest = "..tostring(amountHarvest))

            local option = context:addOption(getText("ContextMenu_ImmersiveHunting_Butcher"),player,ImmersiveHunting.Butcher,item,meatItem,hungerAmount,amountHarvest)

            local tooltip = ISWorldObjectContextMenu.addToolTip()

            -- set the meat item texture
            local scriptItem = getScriptManager():FindItem(meatItem)
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
            --[[
                TODO:

                make option unavailable if no cutting tool in hand (knife, axe or blade)

                show harvestable amount of pieces possible
            ]]
        end
    end
end
