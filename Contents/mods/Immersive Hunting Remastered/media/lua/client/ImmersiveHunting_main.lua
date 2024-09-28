--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Main file of Immersive Hunting Remastered.

]]--
--[[ ================================================ ]]--

-- requirements
local ImmersiveHunting = require "ImmersiveHunting_module"
local random = newrandom()

-- localy initialize player
local client_player = getPlayer()
local function initTLOU_OnGameStart(playerIndex, player_init)
	client_player = getPlayer()
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)


---Retrieve the hunting informations on the target
---@param square IsoGridSquare
---@param huntTarget string
---@return table
ImmersiveHunting.GetHuntInformations = function(square,huntTarget)
    -- define informations on the hunt target
    local HuntInformation = square:getModData().HuntInformation
    if not HuntInformation then
        square:getModData().HuntInformation = {}
        HuntInformation = square:getModData().HuntInformation
    end

    return HuntInformation
end

---Determines whenever a weapon will kill or not. It also determines if
---the weapon might kill, which will be basically an extra roll if weapon
---hits hunting target.
---@param weapon HandWeapon
---@param huntTarget string
---@return boolean
---@return boolean
---@return boolean
---@return number
---@return string|nil
ImmersiveHunting.GetWeaponStats = function(weapon,huntTarget)
    -- default values
    local kill = false
    local mightKill = false
    local shred = false
    local reason = nil
    local chanceToHit = 0

    -- get data related to hunting type
    local huntingConditions = ImmersiveHunting.HuntingConditions[huntTarget]

    -- handle as ranged weapon
    if weapon:isRanged() then
        -- check ammo type
        local ammo = weapon:getAmmoType()
        if not ammo then return false, true, false, chanceToHit, "No ammo type" end

        -- default to mightKill for non-compatible calibers
        local bulletData = ImmersiveHunting.AmmoTypes[ammo]
        if not bulletData then return false, true, false, chanceToHit, "Not recognized" end

        -- get huntingCaliber data
        local ammoType = bulletData.AmmoType
        local huntingCaliberData = huntingConditions.huntingCaliber[ammoType]

        -- energy of bullet types is considered
        if ammoType == "Bullet" then
            -- verify bullet can kill
            if bulletData.Emin > huntingCaliberData.Emin then
                kill = true
                mightKill = true
                chanceToHit = 100
            elseif bulletData.Emax > huntingCaliberData.Emin then
                mightKill = true
            end

            -- if hunting target is susceptible to shreding (losing value)
            if huntingConditions.canBeShreded then
                if bulletData.Diameter > huntingCaliberData.Diameter
                or bulletData.Emax > huntingCaliberData.Emax
                then
                    shred = true
                end
            end

        -- energy is ignored here, suppose energy is the same and diameter is considered
        -- slug can kill big games, but shreds small birds, birds are one shot tho
        elseif ammoType == "Shotgun" then
            -- verify if hunting target should die from shotgun instantly (typically birds)
            if huntingCaliberData.kill then
                kill = true
                mightKill = true

            -- else calculate based on needed diameter of shotgun to kill
            elseif bulletData.Diameter > huntingCaliberData.Diameter then
                kill = true
                mightKill = true
            end

            -- if hunting target is susceptible to shreding (losing value)
            if huntingConditions.canBeShreded then
                if bulletData.Diameter > huntingCaliberData.shredDiameter then
                    shred = true
                end
            end

        -- other types are special, they might be non-lethal weapons
        -- or arrows, slingshots etc
        elseif ammoType == "Other" then
            -- verify such a caliber can kill
            if not huntingCaliberData.CantKill then
                kill = true
                mightKill = true
            end

        end

    -- handle as melee weapon
    else
        -- get melee rules for this huntTarget
        local melee = huntingConditions.melee
        local melee_mightKill = melee.mightKill
        local melee_willKill = melee.willKill
        local melee_noMeleeTwoHanded = melee.noMeleeTwoHanded

        local twoHanded = weapon:isTwoHandWeapon()

        -- iterate through every categories and check every weapon types
        local categories = weapon:getCategories()
        local category
        for i = 0,categories:size() - 1 do
            -- get category
            category = categories:get(i)

            -- if weapon is two handed, verify if its category can be
            if melee_noMeleeTwoHanded and twoHanded then
                -- if weapon can't be used to hunt bcs two handed, skip
                if melee_noMeleeTwoHanded[category] then
                    return false, false, false, 0, "Two handed "..category
                end

            end

            -- check if weapon will kill
            local chanceKill = melee_willKill[category]
            local chanceMightKill = melee_mightKill[category]
            if chanceKill then
                kill = true
                mightKill = true

                chanceToHit = chanceKill > chanceToHit and chanceKill or chanceToHit

            -- check if it might kill if not already the case
            elseif chanceMightKill then
                mightKill = true
                chanceToHit = chanceMightKill > chanceToHit and chanceMightKill or chanceToHit

            end
        end
    end

    return kill, mightKill, shred, chanceToHit, reason
end

ImmersiveHunting.Hunt = function(player,huntTarget,baseIcon,weapon,square)
    
    -- baseIcon:onClickDiscard()
    print("HUNT")

    --[[
        TODO

        kill, mightKill, shred only define if the weapon is adapted, it needs to be written
        in the tooltip, with colors

        like red, can't hunt with
        orange, not adapted
        green, correct to hunt this type of game

        write data in the tooltip for the current meteorological conditions
        aiming stats or combat stats (if melee or ranged for example)

        probability to successfuly hunt this type of game


        make these locked behind sandbox options, if people want to keep it realistic
        should automatic rifles shoot multiple times ? Add the choice ?
        submenu then for each options different chances ?
        
        send data for probabilities as table to this function. keep it simple, maybe calculate
        data if not sent, so sandbox option to show the proba first, calculate first,
        else calculate after for performance reason (no need to calculate if not showing before
        actually shooting)

        show number of bullets used ? Make sure to equip gun before actually hunting, in-case
        player unequiped during the context menu
        also timed action to rack, reload etc

        shooting sound when hunting, based on weapon sound, or melee hit (strong attack ?)
    
        chanceToHit is multiplied by the skill of the player in this field (done in weapon stats)
        this value is a percentage which can be calculated with other values like day time value
        weather, lighting (don't take into account flashlight), fog, rain...
    ]]

    square:getModData().HuntInformation = nil
end

ImmersiveHunting.onFillSearchIconContextMenu = function(context, baseIcon)
    -- verify it's valid
    if not baseIcon or not context then return end

    -- verify it's a forage icon
    if baseIcon.iconClass ~= "forageIcon" then return end

    -- verify it's one of our items
    local itemType = baseIcon.itemType
    local huntTarget = ImmersiveHunting.ValidForageItems[itemType]
    if not huntTarget then return end

    local displayName = baseIcon.itemObj:getDisplayName()
    local options = context.options
    if options then
        local option,name
        for i = #options, 1, -1 do
            option = options[i]

            if option then
                name = option.name

                -- replace the pick up option with our own option
                if name == getText("IGUI_Pickup").." "..displayName then
                    context:removeOptionByName(name)

                    -- get informations on hunt
                    local player = baseIcon.character
                    local weapon = player:getPrimaryHandItem()
                    if not instanceof(weapon,"HandWeapon") then
                        weapon = nil
                    end

                    local square = baseIcon.square

                    -- create tooltip
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    local notAvailable

                    -- verify the character has a weapon
                    if not weapon then
                        notAvailable = true
                        tooltip.description = getText("Tooltip_ImmersiveHunting_NeedWeapon")

                    else
                        -- set the tool tip texture with the weapon
                        local texture = weapon:getTexture()
                        if texture then tooltip:setTexture(texture:getName()) end

                        local kill,mightKill,shred,chanceToHit,reason = ImmersiveHunting.GetWeaponStats(weapon,huntTarget)

                        local weaponName = weapon:getDisplayName()
                        local description = string.format("%s will be used to hunt.",weaponName)

                        -- will kill ?
                        if kill then
                            description = description.."\n".."<GREEN> Weapon will kill target.\n"
                        elseif not mightKill then
                            description = description.."\n".."<RED> Weapon cannot kill target.\n"
                            if reason and reason ~= "" then
                                description = description.."Reason: "..reason
                            end

                            notAvailable = true
                        end

                        -- weapon not adapted
                        if not kill and mightKill or shred then
                            description = description.."\n".."<ORANGE> Weapon is not adapted to hunting:\n<INDENT:8>"

                            -- can't kill
                            if not kill and mightKill then
                                description = description.."- Weapon might not kill target on hit\n"
                            end

                            -- will shred
                            if shred then
                                description = description.."- Weapon will shred target, leaving less meat to collect\n"
                            end
                        end

                        tooltip.description = description

                        print(kill," ",mightKill," ",shred)
                    end

                    option = context:addOptionOnTop(getText("ContextMenu_ImmersiveHunting_Hunt"..huntTarget),player,ImmersiveHunting.Hunt,huntTarget,baseIcon,weapon,square)

                    -- set tooltip and if available
                    option.toolTip = tooltip
                    if notAvailable then
                        option.notAvailable = true
                    end

                elseif name == getText("UI_foraging_DiscardItem").." "..displayName then
                    context:removeOptionByName(name)

                    option = context:addOption(getText("UI_foraging_DiscardItem").." "..huntTarget, baseIcon, baseIcon.onClickDiscard, context)
                end
            end
        end
    end
end