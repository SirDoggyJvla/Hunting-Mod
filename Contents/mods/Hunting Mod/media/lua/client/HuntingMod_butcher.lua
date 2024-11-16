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
local random = newrandom()

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

HuntingMod.Butcher = function(player,playerIndex,carcass,animal,hungerAmount,amountHarvest,knife)
    -- drop carcass on floor if not already a world item
    local worldItem = carcass:getWorldItem()
    if not worldItem then
        -- ISTimedActionQueue.add(ISDropWorldItemAction:new(player, carcass, player:getSquare(), 0, 0, 0, 0, false))
        ISInventoryPaneContextMenu.dropItem(carcass, playerIndex)
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
            local scriptItem_meat = getScriptManager():FindItem(animal.meat)
            local hungerAmount = item:getHungChange()
            local amountHarvest = math.ceil(-hungerAmount)

            local description = "<CENTRE>"

            -- get fat and fatAmount
            local fat = animal.fat
            local fatAmount
            if fat then
                local carcass_modData = item:getModData().HuntingMod
                if carcass_modData then
                    fatAmount = carcass_modData.fatLeft
                else
                    -- initialize fat amount if not already (meaning spawned item)
                    fatAmount = random:random(animal.fatAmountMin*10000,animal.fatAmountMax*10000)/10000
                    fatAmount = -fatAmount * item:getHungChange()
                    fatAmount = fatAmount - fatAmount%1 + 1

                    local fatItemInventory = InventoryItemFactory.CreateItem(fat) --[[@as Food]]

                    item:setCalories(item:getCalories() + fatItemInventory:getCalories()*fatAmount)
                    item:setLipids(item:getLipids() + fatItemInventory:getLipids()*fatAmount)
                    item:setCarbohydrates(item:getCarbohydrates() + fatItemInventory:getCarbohydrates()*fatAmount)
                    item:setProteins(item:getProteins() + fatItemInventory:getProteins()*fatAmount)

                    item:getModData().HuntingMod = {
                        fatLeft = fatAmount
                    }
                end
            end

            -- verify if the player has a knife in hands, or retrieve one from the inventory
            local notAvailable
            local knife = player:getPrimaryHandItem()
            local noKnife
            if not knife or not instanceof(knife,"HandWeapon") or not knife:getTags():contains("SharpKnife") then
                knife = player:getInventory():getFirstTagRecurse("SharpKnife")
                if not instanceof(knife,"HandWeapon") then
                    noKnife = true
                end
            end

            if noKnife then
                notAvailable = true
                description = description.."\n\n<RED><IMAGECENTRE:media/UI/NoKnifeFound.png,45,45>\n"..getText("Tooltip_HuntingMod_NeedSharpKnife")
            else
                -- prepare tooltip texture of knife item
                local knifeTexture = knife:getTexture()
                local width = knifeTexture:getWidth()
                local height = knifeTexture:getHeight()
                local ratio = width/height
                local texture = string.gsub(knifeTexture:getName(), "^.*media", "media")
                height = 40
                width = height*ratio
                texture = "<IMAGECENTRE:"..texture..","..width..","..height..">"

                description = description.."\n\n"..texture.."\n"..getText("Tooltip_HuntingMod_KnifeToButcher",knife:getName())
            end

            -- meat item description
            local meatItemName = animal.meatName
            local meatName = meatItemName and getText(meatItemName) or scriptItem_meat:getDisplayName()
            meatName = string.lower(meatName)

            -- prepare tooltip texture of meat item
            local meatTexture = scriptItem_meat:getNormalTexture()
            local width = meatTexture:getWidth()
            local height = meatTexture:getHeight()
            local ratio = width/height
            local texture = string.gsub(meatTexture:getName(), "^.*media", "media")
            height = 40
            width = height*ratio
            texture = "<RGB:1,1,1><IMAGECENTRE:"..texture..","..width..","..height..">"

            description = description.."\n\n"..texture.."\n"..getText("Tooltip_HuntingMod_ButcherAmount",amountHarvest,meatName)

            -- fat item description
            if fat and fatAmount then
                local scriptItem_fat = getScriptManager():FindItem(fat)

                local fatName = animal.fatName or scriptItem_fat:getDisplayName()
                fatName = string.lower(fatName)
                if fatAmount <= 0 then
                    fatAmount = getText("Tooltip_HuntingMod_No")
                end

                -- prepare tooltip texture of fat item
                local fatTexture = scriptItem_fat:getNormalTexture()
                local width = fatTexture:getWidth()
                local height = fatTexture:getHeight()
                local ratio = width/height
                local texture = string.gsub(fatTexture:getName(), "^.*media", "media")
                height = 40
                width = height*ratio
                texture = "<IMAGECENTRE:"..texture..","..width..","..height..">"

                description = description.."\n\n"..texture.."\n"..getText("Tooltip_HuntingMod_FatAmount",fatAmount,fatName)
            end

            -- create the option
            local option = context:addOption(getText("ContextMenu_HuntingMod_Butcher"),player,HuntingMod.Butcher,playerIndex,item,animal,hungerAmount,amountHarvest,knife)
            option.iconTexture = getScriptManager():FindItem("MeatCleaver"):getNormalTexture()
            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip.description = description
            option.toolTip = tooltip
            option.notAvailable = notAvailable
        end
    end
end
