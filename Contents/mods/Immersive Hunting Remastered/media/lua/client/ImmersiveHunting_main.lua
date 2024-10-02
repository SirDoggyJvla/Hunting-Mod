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
require "TimedActions/Immersive Hunting Remastered/ISHunt"
-- local gametime = GameTime:getInstance()
local climateManager = getClimateManager()
local random = newrandom()

-- localy initialize player and values
local client_player = getPlayer()
local a_aiming,b_aiming,a_melee,b_melee,a_strength,b_strength
local function initTLOU_OnGameStart(playerIndex, player_init)
	client_player = getPlayer()

    -- determine a and b for y = ax + b for aiming impact
    local x1 = SandboxVars.ImmersiveHunting.MinimumAimingLevelToHunt
    local x2 = SandboxVars.ImmersiveHunting.MaximumAimingLevelToHunt
    local y1 = SandboxVars.ImmersiveHunting.MinimumAimingImpact
    local y2 = SandboxVars.ImmersiveHunting.MaximumAimingImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum aiming impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 0
        y2 = 100
    end
    if x2 <= x1 then
        print("ERROR: Minimum and maximum aiming level to hunt need to be different values with the maximum greater than the minimum. Using default value in the meantime.")
        x1 = 1
        x2 = 10
    end

    a_aiming = (y2-y1)/(x2-x1)
    b_aiming = (x2*y1 - x1*y2)/(x2-x1)


    -- determine a and b for y = ax + b for stength impact
    x1 = SandboxVars.ImmersiveHunting.MinimumMeleeLevelToHunt
    x2 = SandboxVars.ImmersiveHunting.MaximumMeleeLevelToHunt
    y1 = SandboxVars.ImmersiveHunting.MinimumMeleeImpact
    y2 = SandboxVars.ImmersiveHunting.MaximumMeleeImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum melee impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 0
        y2 = 150
    end
    if x2 <= x1 then
        print("ERROR: Minimum and maximum melee level to hunt need to be different values with the maximum greater than the minimum. Using default value in the meantime.")
        x1 = 1
        x2 = 10
    end

    a_melee = (y2-y1)/(x2-x1)
    b_melee = (x2*y1 - x1*y2)/(x2-x1)


    -- determine a and b for y = ax + b for stength impact
    x1 = SandboxVars.ImmersiveHunting.MinimumStrengthLevelToHunt
    x2 = SandboxVars.ImmersiveHunting.MaximumStrengthLevelToHunt
    y1 = SandboxVars.ImmersiveHunting.MinimumStrengthImpact
    y2 = SandboxVars.ImmersiveHunting.MaximumStrengthImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum strength impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 0
        y2 = 150
    end
    if x2 <= x1 then
        print("ERROR: Minimum and maximum strength level to hunt need to be different values with the maximum greater than the minimum. Using default value in the meantime.")
        x1 = 1
        x2 = 10
    end

    a_strength = (y2-y1)/(x2-x1)
    b_strength = (x2*y1 - x1*y2)/(x2-x1)
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)

---Retrieve the hunting informations on the target
---@param square IsoGridSquare
---@param huntTarget string
---@return table
ImmersiveHunting.GetHuntInformations = function(square,player,huntTarget)
    -- define informations on the hunt target
    local HuntInformation = square:getModData().HuntInformation
    if not HuntInformation or true then
        print("set hunt information")
        -- get coordinates
        local p_x,p_y,p_z = player:getX(),player:getY(),player:getZ()
        local s_x,s_y,s_z = square:getX(),square:getY(),square:getZ()

        local x,y = s_x - p_x,s_y - p_y

        -- retrieve the target distance from the foraging point
        local distance = random:random(5,10)
        local originalAngle = Vector2.new(x,y):getDirection()

        -- determine the square the target will be on
        local squareTarget,angle
        local timeOut = 10

        -- find a valid square or stop after some time
        while not squareTarget and timeOut > 0 do
            timeOut = timeOut - 1

            -- get a random square in the direction between the player and the forage item
            angle = originalAngle + math.rad(random:random(-45,45))
            x = distance * math.cos(angle)
            y = distance * math.sin(angle)
            squareTarget = getSquare(s_x + x, s_y + y, 0)
            if squareTarget and squareTarget:isBlockedTo(square) then
                squareTarget = nil
            end
        end

        -- if no square was found, default to the square of the forage item
        if not squareTarget then
            squareTarget = square
        end

        square:getModData().HuntInformation = {
            squareTarget = squareTarget
        }
        HuntInformation = square:getModData().HuntInformation

    end

    return HuntInformation
end


---Determines whenever a weapon will kill or not. It also determines if
---the weapon might kill, which will be basically an extra roll if weapon
---hits hunting target.
---@param weapon HandWeapon
---@param huntTarget string
---@return boolean kill
---@return boolean mightKill
---@return boolean shred
---@return number chanceToHit
---@return string|nil reason
---@return table impacts
ImmersiveHunting.GetWeaponStats = function(player,weapon,huntTarget)
    -- default values
    local kill = false
    local mightKill = false
    local shred = false
    local chanceToHit = 0
    local impacts = {}

    -- get data related to hunting type
    local huntingConditions = ImmersiveHunting.HuntingConditions[huntTarget]

    -- handle as ranged weapon
    if weapon:isRanged() then
        -- check ammo type
        local ammo = weapon:getAmmoType()
        if not ammo then return false, true, false, chanceToHit, "Tooltip_ImmersiveHunting_noAmmoType", {} end

        -- default to mightKill for non-compatible calibers
        local bulletData = ImmersiveHunting.AmmoTypes[ammo]
        if not bulletData then
            return false, true, false, chanceToHit, "Tooltip_ImmersiveHunting_notRecognized", {}
        end

        -- get huntingCaliber data
        local ammoType = bulletData.AmmoType
        local huntingCaliberData = huntingConditions.huntingCaliber[ammoType]
        if not huntingCaliberData then
            return false, false, false, 0, "Tooltip_ImmersiveHunting_badCaliber", {}
        end

        -- aiming impact
        local aimingImpact = 1
        if SandboxVars.ImmersiveHunting.AimingImpact then
            local aimingLevel = player:getPerkLevel(Perks.Aiming)
            if aimingLevel < SandboxVars.ImmersiveHunting.MinimumAimingLevelToHunt then
                return false, false, false, 0, "Tooltip_ImmersiveHunting_badAiming", {}
            end
            aimingImpact = (aimingLevel*a_aiming + b_aiming)/100
            impacts.aimingImpact = aimingImpact
        end

        -- weapon impact
        local gunImpact = 1 - (1 - huntingCaliberData.impact/10) * SandboxVars.ImmersiveHunting.WeaponImpact/100
        impacts.gunImpact = gunImpact

        -- total chance to hit
        chanceToHit = gunImpact * aimingImpact

        -- energy of bullet types is considered
        if ammoType == "Bullet" then
            -- verify bullet can kill
            if bulletData.Emin > huntingCaliberData.Emin then
                kill = true
                mightKill = true

            elseif bulletData.Emax > huntingCaliberData.Emin then
                mightKill = true
            end

            -- if hunting target is susceptible to shreding (losing value)
            if huntingConditions.canBeShrededDiameter and bulletData.Diameter > huntingCaliberData.Diameter
            or huntingConditions.canBeShrededEnergy and bulletData.Emax > huntingCaliberData.Emax
            then
                shred = true
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
            if huntingConditions.canBeShrededDiameter then
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
        local category,perk,level,meleeImpact,chanceKill,chanceMightKill
        for i = 0,categories:size() - 1 do
            -- get category
            category = categories:get(i)

            -- if weapon is two handed, verify if its category can be
            if melee_noMeleeTwoHanded and twoHanded then
                -- if weapon can't be used to hunt bcs two handed, skip
                if melee_noMeleeTwoHanded[category] then
                    return false, false, false, 0, "Tooltip_ImmersiveHunting_twoHanded"..category, {}
                end
            end

            -- get level in this weapon handling
            perk = Perks[category]
            level = perk and player:getPerkLevel(Perks[category]) or player:getPerkLevel(Perks.Maintenance)
            meleeImpact = (level*a_melee + b_melee)/100

            -- get chance to kill or mightKill
            chanceKill = melee_willKill[category]
            chanceKill = chanceKill and chanceKill/10*meleeImpact
            chanceMightKill = melee_mightKill[category]
            chanceMightKill = chanceMightKill and chanceMightKill/10*meleeImpact

            -- check if chance to kill or might kill is higher than precedent chance
            if chanceKill then
                kill = true
                mightKill = true

                if chanceKill > chanceToHit then
                    chanceToHit = chanceKill
                    impacts.meleeImpact = meleeImpact
                end

            -- check if it might kill if not already the case
            elseif chanceMightKill then
                mightKill = true

                if chanceMightKill > chanceToHit then
                    chanceToHit = chanceMightKill
                    impacts.meleeImpact = meleeImpact
                end
            end
        end

        -- verify the character even has a single chance of hunting here
        if chanceToHit == 0 then
            return false, false, false, 0, "Tooltip_ImmersiveHunting_notSkilledEnough", {}
        end

        -- strength impact
        if SandboxVars.ImmersiveHunting.StrengthImpact then
            local strengthLevel = player:getPerkLevel(Perks.Strength)
            if strengthLevel < SandboxVars.ImmersiveHunting.MinimumStrengthLevelToHunt then
                return false, false, false, 0, "Tooltip_ImmersiveHunting_notStrongEnough", {}
            end
            local strengthImpact = (strengthLevel*a_strength + b_strength)/100
            chanceToHit = chanceToHit * strengthImpact
            impacts.strengthImpact = strengthImpact
        end
    end

    return kill, mightKill, shred, chanceToHit, nil, impacts
end

---Hunt target.
---@param player IsoPlayer
---@param square IsoGridSquare
---@param squareTarget IsoGridSquare
---@param huntTarget string
---@param baseIcon table
---@param weapon HandWeapon
---@param chanceToHunt number
ImmersiveHunting.Hunt = function(player,square,squareTarget,huntTarget,baseIcon,weapon,chanceToHunt)
    -- baseIcon:onClickDiscard()
    print("HUNT")

    ISTimedActionQueue.add(ImmersiveHunting_ISHunt:new(player,square,squareTarget,chanceToHunt,baseIcon,weapon,100))

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

    ]]

    ImmersiveHunting_ISHunt:new(player,square,squareTarget,chanceToHunt,baseIcon,weapon,100)

    square:getModData().HuntInformation = nil
end

function ISBaseIcon:doPickup()				return false;					end;

function ISBaseIcon:doPickup()
    print("HOLA")
    
    return false
end

---Returns if a weapon can shoot, or true if not ranged.
---@param weapon HandWeapon|nil
---@return boolean|nil
---@return string
ImmersiveHunting.CanShoot = function(weapon)
    -- if no weapon
    if not weapon then return nil, "Tooltip_ImmersiveHunting_NeedWeapon" end

    -- verify if ranged
    if not weapon:isRanged() then return true, "" end

    -- check if jammed
    print("JAMMED")
    print(weapon:isJammed())
    if weapon:isJammed() then return false, "Tooltip_ImmersiveHunting_IsJammed" end

    print("CHAMBER")
    print(weapon:haveChamber())
    if weapon:haveChamber() then
        print("CHAMBERED ?")
        print(weapon:isRoundChambered())
        if not weapon:isRoundChambered() then return false, "Tooltip_ImmersiveHunting_NoRoundChambered" end
    else
        print("AMMO COUNT")
        print(weapon:getCurrentAmmoCount())
        if weapon:getCurrentAmmoCount() == 0 then return false, "Tooltip_ImmersiveHunting_NoAmmo" end
    end

    print("DATA")
    print(weapon:isReloadable(client_player))

    return true
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
                    local HuntInformation = ImmersiveHunting.GetHuntInformations(square,player,huntTarget)

                    -- create tooltip
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    local notAvailable,chanceToHunt,description

                    local canShoot, reason = ImmersiveHunting.CanShoot(weapon)
                    print("canShoot = "..tostring(canShoot))
                    -- verify the character has a weapon
                    if canShoot == nil then
                        notAvailable = true
                        description = getText(reason)

                    elseif not canShoot then
                        notAvailable = true
                        description = getText(reason)

                    else
                        ---@cast weapon HandWeapon

                        -- set the tool tip texture with the weapon
                        local texture = weapon:getTexture()
                        if texture then tooltip:setTexture(texture:getName()) end

                        local kill,mightKill,shred,chanceToHit,impacts = ImmersiveHunting.GetWeaponStats(player,weapon,huntTarget)

                        local weaponName = weapon:getDisplayName()
                        description = string.format("%s will be used to hunt.",weaponName)

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


                        -- determine probability of hunting
                        local dayLight = 1 - (1 - climateManager:getDayLightStrength())*SandboxVars.ImmersiveHunting.LightImpact/100
                        dayLight = dayLight < 0 and 0 or dayLight

                        local fog = 1 - climateManager:getFogIntensity()*SandboxVars.ImmersiveHunting.FogImpact/100
                        fog = fog < 0 and fog or fog

                        local wind = 1 - climateManager:getWindIntensity()*SandboxVars.ImmersiveHunting.WindImpact/100
                        wind = wind < 0 and wind or wind

                        chanceToHunt = chanceToHit*dayLight*fog*wind*SandboxVars.ImmersiveHunting.BoostToHuntingChance/100

                        -- show probability if should
                        if SandboxVars.ImmersiveHunting.ShowProbabilities then
                            description = description.."\n<RGB:1,1,1>"..getText("Tooltip_ImmersiveHunting_impacts").."\n"
                            dayLight = dayLight*100
                            dayLight = dayLight - dayLight%1
                            description = description.."\n"..getText("Tooltip_ImmersiveHunting_DayLightImpact").." "..tostring(dayLight).."%"
                            fog = fog*100
                            fog = fog - fog%1
                            description = description.."\n"..getText("Tooltip_ImmersiveHunting_FogImpact").." "..tostring(fog).."%"
                            wind = wind*100
                            wind = wind - wind%1
                            description = description.."\n"..getText("Tooltip_ImmersiveHunting_WindImpact").." "..tostring(wind).."%"

                            local text
                            for k,v in pairs(impacts) do
                                text = getText("Tooltip_ImmersiveHunting_"..k)
                                v = v*100
                                v = v - v%1
                                description = description.."\n"..text.." "..tostring(v).."%"
                            end

                            local chance = chanceToHit*100
                            chance = chance - chance%1
                            description = description.."\n"..getText("Tooltip_ImmersiveHunting_ChanceToHit").." "..tostring(chance).."%"

                            chance = chanceToHunt*100
                            chance = chance - chance%1
                            description = description.."\n\n"..getText("Tooltip_ImmersiveHunting_ChanceToHunt").." "..tostring(chance).."%"
                        end
                    end

                    tooltip.description = description

                    local squareTarget = HuntInformation.squareTarget
                    option = context:addOptionOnTop(getText("ContextMenu_ImmersiveHunting_Hunt"..huntTarget),player,ImmersiveHunting.Hunt,square,squareTarget,huntTarget,baseIcon,weapon,chanceToHunt)

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

--#region Functions to highlight squares

--- Based on Rodriguo's work

---Add a square to highlight.
---@param square IsoGridSquare
---@param ISColors table
ImmersiveHunting.AddHighlightSquare = function(square, ISColors,player)
    if not square or not ISColors then return end
    table.insert(ImmersiveHunting.highlightsSquares, {square = square, color = ISColors, player = player, time = os.time()})
end

---Render squares in the list and remove them based on conditions.
ImmersiveHunting.RenderHighLights = function()
    local size = #ImmersiveHunting.highlightsSquares
    if #ImmersiveHunting.highlightsSquares == 0 then return end
    for i = size,1,-1 do
        local highlight = ImmersiveHunting.highlightsSquares[i]
        local square = highlight.square
        if square ~= nil and instanceof(square, "IsoGridSquare") then
            local x,y,z = square:getX(), square:getY(), square:getZ()
            local r,g,b = highlight.color.r, highlight.color.g, highlight.color.b

            -- check since how long this square has been highlighted
            local time = os.time() - highlight.time
            if time > 60 then
                table.remove(ImmersiveHunting.highlightsSquares, i)
            elseif time > 10 then
                local player = highlight.player
                local p_x = player:getX()
                local p_y = player:getY()
                local new_x = x - p_x
                local new_y = y - p_y
                local d = (new_x*new_x + new_y*new_y)^0.5
                if d < 2 then
                    table.remove(ImmersiveHunting.highlightsSquares, i)
                elseif d > 50 then
                    table.remove(ImmersiveHunting.highlightsSquares, i)
                end
            end

            -- calculate blink value
            local blink = highlight.blink
            if not blink then
                blink = 1
                highlight.blinkDirection = -1
            end

            local blinkDirection = highlight.blinkDirection
            local newBlink = blink + 0.01 * blinkDirection
            if blink < 0 or blink > 1 then
                blinkDirection = blinkDirection * -1
                highlight.blinkDirection = blinkDirection
                newBlink = blink + 0.01 * blinkDirection
            end
            highlight.blink = newBlink

            local floorSprite = IsoSprite.new()
            floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
            floorSprite:RenderGhostTileColor(x, y, z, r, g, b, newBlink)

            -- verify if the square should stop blinking
        end
    end
end

--#endregion

initTLOU_OnGameStart()