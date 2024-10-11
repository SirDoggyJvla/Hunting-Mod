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

-- skip if client is not in debug mode
if not getDebug() then return end

-- retrieve some zoneData because there's really no need to bother making one so fuck it
if not ImmersiveHunting.zoneData then
    require "Foraging/ISForageIcon"

    local original_ISForageIcon_new = ISForageIcon.new
    function ISForageIcon:new(_manager, _forageIcon, _zoneData)
        ImmersiveHunting.zoneData = _zoneData

        return original_ISForageIcon_new(self,_manager, _forageIcon, _zoneData)
    end
end

ImmersiveHunting.CreateForageIcon = function(player,square,itemType,animal)
    -- scufffed from vanilla code
    local _zoneData = ImmersiveHunting.zoneData
    if not _zoneData then
        player:addLineChatElement("Activate search mode")
        return
    end

    local iconID = getRandomUUID()
    local catDef = {
		name                    = "Animals",
		typeCategory            = "Animals",
		identifyCategoryPerk    = "PlantScavenging",
		identifyCategoryLevel   = 5,
		categoryHidden          = false,
		validFloors             = { "ANY" },
		zoneChance              = {
			DeepForest      = 15,
			Forest          = 15,
			Vegitation      = 25,
			FarmLand        = 20,
			Farm            = 20,
			TrailerPark     = 5,
			TownZone        = 5,
			Nav             = 3,
		},
		spriteAffinities        = {"d_generic_1_17"},
		chanceToMoveIcon        = 3.0,
		chanceToCreateIcon      = 0.1,
		focusChanceMin			= 5.0,
		focusChanceMax			= 15.0,
	}
    local forageIcon = {
        id          			= iconID,
        zoneid      			= _zoneData.id,
        x           			= square:getX(),
        y           			= square:getY(),
        z           			= square:getZ(),
        catName     			= catDef.name,
        itemType    			= itemType,
        isBonusIcon				= true,
        canRollForSearchFocus	= false,
    }

    _zoneData.forageIcons[iconID] = forageIcon
    local manager = ISSearchManager:new(player)
    manager.forageIcons[iconID] = ISForageIcon:new(manager, forageIcon, _zoneData)
    manager.activeIcons[iconID] = manager.forageIcons[iconID]
    manager.activeIcons[iconID]:doUpdateEvents(true)
    manager.activeIcons[iconID]:addToUIManager()

    -- --ignore this icon next time if it's still active
    -- manager.movedIcons[iconID] = iconID
    -- --ignore this square until the zone refills
    -- manager.movedIconsSquares[square] = true
    --add the bonus item to the loading queue of all managers
    for _, manager in pairs(ISSearchManager.players) do
        if manager.activeZones[_zoneData.id] then
            if (not manager.iconStack[iconID]) and (not manager.forageIcons[iconID]) then
                manager.iconStack[forageIcon] = _zoneData
                manager.iconQueue = manager.iconQueue + 1
            end
        end
    end
end

ImmersiveHunting.OnFillWorldObjectContextMenu = function(playerIndex, context, worldObjects, test)
    -- access the first square found
    local worldObject,square
    for i = 1,#worldObjects do
        worldObject = worldObjects[i]
        square = worldObject:getSquare()
        if square then
            break
        end
    end

    -- skip if no square found
    if not square then return end

    -- create the submenu for Immersive Hunting debug
    local option = context:addOptionOnTop(getText("ContextMenu_ImmersiveHunting_DebugMenu"))
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)

    option.iconTexture = getTexture("media/UI/ImmersiveHunting_gun.png")

    -- create the subsubmenu to spawn animals
    option = subMenu:addOption(getText("ContextMenu_ImmersiveHunting_SpawnAnimal"))
    local subSubMenu = subMenu:getNew(subMenu)
    subMenu:addSubMenu(option, subSubMenu)

    -- add experimental tooltip
    local tooltip = ISWorldObjectContextMenu.addToolTip()
    tooltip.description = "<ORANGE> EXPERIMENTAL"
    option.toolTip = tooltip

    -- retrieve player
	local player = getSpecificPlayer(playerIndex)

    -- add options for each animals
    for tracks,animal in pairs(ImmersiveHunting.ValidForageItems) do
        local option = subSubMenu:addOption(getText(animal.name),player,ImmersiveHunting.CreateForageIcon,square,tracks,animal)
        -- access the texture to show on the icon
        local animalTexture
        local sprite = animal.sprite
        if sprite then
            animalTexture = Texture.trygetTexture(animal.sprite)

        -- get dead animal texture instead
        else
            local scriptItem = getScriptManager():FindItem(animal.dead)
            animalTexture = scriptItem and scriptItem:getNormalTexture()
        end

        option.iconTexture = animalTexture
    end
end
