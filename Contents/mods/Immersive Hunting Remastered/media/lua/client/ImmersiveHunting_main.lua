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
local a_aiming,b_aiming,a_melee,b_melee,a_strength,b_strength,a_stealth,b_stealth
local function initTLOU_OnGameStart(playerIndex, player_init)
	client_player = getPlayer()

    -- determine a and b for y = ax + b for aiming impact
    local x1 = SandboxVars.ImmersiveHunting.MinimumAimingLevelToHunt
    if not x1 then return end
    local x2 = SandboxVars.ImmersiveHunting.MaximumAimingLevelToHunt
    local y1 = SandboxVars.ImmersiveHunting.MinimumAimingImpact
    local y2 = SandboxVars.ImmersiveHunting.MaximumAimingImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum aiming impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 50
        y2 = 100
    end
    if x2 <= x1 then
        print("ERROR: Minimum and maximum aiming level to hunt need to be different values with the maximum greater than the minimum. Using default value in the meantime.")
        x1 = 1
        x2 = 10
    end

    a_aiming = (y2-y1)/(x2-x1)/100
    b_aiming = (x2*y1 - x1*y2)/(x2-x1)/100


    -- determine a and b for y = ax + b for stength impact
    x1 = SandboxVars.ImmersiveHunting.MinimumMeleeLevelToHunt
    x2 = SandboxVars.ImmersiveHunting.MaximumMeleeLevelToHunt
    y1 = SandboxVars.ImmersiveHunting.MinimumMeleeImpact
    y2 = SandboxVars.ImmersiveHunting.MaximumMeleeImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum melee impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 50
        y2 = 150
    end
    if x2 <= x1 then
        print("ERROR: Minimum and maximum melee level to hunt need to be different values with the maximum greater than the minimum. Using default value in the meantime.")
        x1 = 1
        x2 = 10
    end

    a_melee = (y2-y1)/(x2-x1)/100
    b_melee = (x2*y1 - x1*y2)/(x2-x1)/100


    -- determine a and b for y = ax + b for strength impact
    x1 = SandboxVars.ImmersiveHunting.MinimumStrengthLevelToHunt
    x2 = SandboxVars.ImmersiveHunting.MaximumStrengthLevelToHunt
    y1 = SandboxVars.ImmersiveHunting.MinimumStrengthImpact
    y2 = SandboxVars.ImmersiveHunting.MaximumStrengthImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum strength impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 50
        y2 = 150
    end
    if x2 <= x1 then
        print("ERROR: Minimum and maximum strength level to hunt need to be different values with the maximum greater than the minimum. Using default value in the meantime.")
        x1 = 1
        x2 = 10
    end

    a_strength = (y2-y1)/(x2-x1)/100
    b_strength = (x2*y1 - x1*y2)/(x2-x1)/100


    -- determine a and b for y = ax + b for stealth impact
    x1 = 0
    x2 = 10
    y1 = SandboxVars.ImmersiveHunting.MinimumStealthImpact
    y2 = SandboxVars.ImmersiveHunting.MaximumStealthImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum stealth impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 70
        y2 = 150
    end

    a_stealth = (y2-y1)/(x2-x1)/100
    b_stealth = (x2*y1 - x1*y2)/(x2-x1)/100
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
    if not HuntInformation or not HuntInformation.squareTarget or not HuntInformation.animal then
        -- get coordinates
        local p_x,p_y = player:getX(),player:getY()
        local s_x,s_y = square:getX(),square:getY()

        local v_x,v_y = s_x - p_x,s_y - p_y

        -- retrieve the target distance from the foraging point
        local distance = random:random(5,10)
        local originalAngle = Vector2.new(v_x,v_y):getDirection()

        -- determine the square the target will be on
        local squareTarget,angle
        local timeOut = 10

        -- find a valid square or stop after some time
        local x,y
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

        -- determine animal to hunt
        local animal
        if type(huntTarget) == "string" then
            local animals = ImmersiveHunting.AnimalTypes[huntTarget]
            animal = animals[random:random(1,#animals)]
        elseif type(huntTarget) == "table" then
            animal = huntTarget
        end

        square:getModData().HuntInformation = {
            squareTarget = squareTarget,
            animal = animal,
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
            return false, true, false, 80, "Tooltip_ImmersiveHunting_notRecognized", {}
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
            aimingImpact = aimingLevel*a_aiming + b_aiming
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
            if huntingCaliberData.CanKill then
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
            meleeImpact = level*a_melee + b_melee

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
            local strengthImpact = strengthLevel*a_strength + b_strength
            chanceToHit = chanceToHit * strengthImpact
            impacts.strengthImpact = strengthImpact
        end
    end

    return kill, mightKill, shred, chanceToHit, nil, impacts
end

---Do the hunting.
---@param player IsoPlayer
---@param square IsoGridSquare
---@param HuntInformation table
---@param baseIcon table
---@param weapon HandWeapon
---@param chanceToHunt number
---@param kill boolean
---@param shred boolean
ImmersiveHunting.DoHunt = function(player,square,HuntInformation,baseIcon,weapon,chanceToHunt,kill,shred)
    -- safeguard if a sneak bastard opens a new context menu for the icon during a precedent hunting
    if not square:getModData().HuntInformation then return end

    local squareTarget = HuntInformation.squareTarget
    local animal = HuntInformation.animal

    local x,y = player:getX() - square:getX(),player:getY() - square:getY()
    local d = (x*x + y*y)^0.5

    -- if too far from the square for hunting, make the player move there
    if d >= 2 then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(player, square))
    end

    -- equip gun if player tried to cheat and put it away
    if player:getPrimaryHandType() ~= weapon then
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, weapon, 50, true))
    end

    -- start hunting
    ISTimedActionQueue.add(ImmersiveHunting_ISHunt:new(player,square,squareTarget,animal,chanceToHunt,baseIcon,weapon,kill,shred,200))
end

ImmersiveHunting.Discard = function(baseIcon,square,player)
    player:getXp():AddXP(Perks.PlantScavenging, SandboxVars.ImmersiveHunting.XPGainDiscard)

    square:getModData().HuntInformation = nil
    baseIcon:onClickDiscard()
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
    if weapon:isJammed() then return false, "Tooltip_ImmersiveHunting_IsJammed" end

    -- verify is loaded
    if weapon:haveChamber() then
        if not weapon:isRoundChambered() then return false, "Tooltip_ImmersiveHunting_NoRoundChambered" end
    else
        if weapon:getCurrentAmmoCount() == 0 then return false, "Tooltip_ImmersiveHunting_NoAmmo" end
    end

    return true, ""
end

---Gives the hunt chance impact from skills and player stats.
---@param player IsoPlayer
---@return number
---@return number
---@return table
---@return table
ImmersiveHunting.GetPlayerStatsChance = function(player)
    -- check moodles
    local moodleImpact = SandboxVars.ImmersiveHunting.MoodleImpact/100

    local hasCold = player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0.25 and 0.2 or 0
    local cold = 1 - hasCold*moodleImpact
    local moodle = cold

    -- check traits
    local traits_positive = table.newarray()
    local traits_negative = table.newarray()
    local traitToName = ImmersiveHunting.TraitsToName
    local trait = 1
    local traitImpact = SandboxVars.ImmersiveHunting.TraitImpact/100
    for k,v in pairs(ImmersiveHunting.TraitsToCheck) do
        if player:HasTrait(k) then
            trait  = trait * (1 + v*traitImpact)
            if v > 0 then
                table.insert(traits_positive,traitToName[k])
            else
                table.insert(traits_negative,traitToName[k])
            end
        end
    end

    trait = trait < 0 and trait or trait
    moodle = moodle < 0 and moodle or moodle

    local stealthLevel = (player:getPerkLevel(Perks.Sneak) + player:getPerkLevel(Perks.Lightfoot))/2
    local stealth = a_stealth * stealthLevel + b_stealth

    return trait, moodle, stealth, traits_positive, traits_negative
end

ImmersiveHunting.ValueToRGBTag = function(value)
    value = value > 100 and 100 or value < 0 and 0 or value
    local r = 1 - (value / 100)^6
    -- r = r - r%1
    local g = 1 - (value / 100 - 1)^6
    -- g = g - g%1
    local b = 0
    return "<RGB:"..tostring(r)..","..tostring(g)..","..tostring(b)..">"
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

                -- get informations on hunt
                local player = baseIcon.character
                local square = baseIcon.square
                local HuntInformation = ImmersiveHunting.GetHuntInformations(square,player,huntTarget)
                local animal = HuntInformation.animal
                local animalName = getText(animal.name)

                -- get animal texture
                -- local scriptItem = getScriptManager():FindItem(animal.dead)
                -- local animalTexture = scriptItem and scriptItem:getNormalTexture()

                local sprite = animal.sprite
                local animalTexture
                if sprite then
                    animalTexture = Texture.trygetTexture(animal.sprite)

                else
                    -- get animal texture
                    local scriptItem = getScriptManager():FindItem(animal.dead)
                    animalTexture = scriptItem and scriptItem:getNormalTexture()

                end
                print(animalTexture)

                -- set icon texture
                local animalTexture_resized = animalTexture
                animalTexture_resized:setWidth(32)
                animalTexture_resized:setHeight(32)
                baseIcon.itemTexture = animalTexture_resized

                -- replace the pick up option with our own option
                if name == getText("IGUI_Pickup").." "..displayName then
                    context:removeOptionByName(name)

                    -- get player weapon
                    local weapon = player:getPrimaryHandItem()
                    if not instanceof(weapon,"HandWeapon") then
                        weapon = nil
                    end

                    -- create tooltip
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    local notAvailable,chanceToHunt,description

                    local kill, mightKill, shred, chanceToHit, impacts
                    local canShoot, reason = ImmersiveHunting.CanShoot(weapon)
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
                        local normalTexture = weapon:getTexture()
                        if normalTexture then tooltip:setTexture(normalTexture:getName()) end

                        kill, mightKill, shred, chanceToHit, reason, impacts = ImmersiveHunting.GetWeaponStats(player,weapon,huntTarget)
                        local weaponName = weapon:getDisplayName()

                        -- set the animal texture icon
                        local texture = ""
                        if normalTexture then
                            texture = string.gsub(animalTexture:getName(), "^.*media", "media")

                            texture = "<IMAGECENTRE:"..texture..",40,40>"
                        end

                        description = "<CENTRE>"..getText("Tooltip_ImmersiveHunting_HuntTooltip",weaponName)
                        description = description.."\n"..texture.."\n"..animalName

                        -- will kill ?
                        if kill then
                            description = description.."\n".."<GREEN> Weapon will kill target.\n"
                        elseif not mightKill then
                            description = description.."\n".."<RED> Weapon cannot kill target.\n"
                            notAvailable = true
                        end

                        if reason and reason ~= "" then
                            description = description.."Reason: "..getText(reason)
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

                        local ranged = weapon:isRanged()
                        local scope = 1
                        if ranged and weapon:getScope() then
                            scope = 1 + SandboxVars.ImmersiveHunting.ScopeBonus/100
                        end

                        local trait, moodle, stealth, traits_positive, traits_negative = ImmersiveHunting.GetPlayerStatsChance(player)

                        chanceToHunt = chanceToHit*dayLight*fog*wind*scope*trait*moodle*stealth*SandboxVars.ImmersiveHunting.BoostToHuntingChance/100

                        -- show probability if should
                        if SandboxVars.ImmersiveHunting.ShowProbabilities then
                            description = description.."\n\n<RGB:1,1,1>"..getText("Tooltip_ImmersiveHunting_impacts").."\n"

                            local ValueToRGBTag = ImmersiveHunting.ValueToRGBTag

                            -- daylight
                            dayLight = dayLight*100
                            dayLight = dayLight - dayLight%1
                            local color = ValueToRGBTag(dayLight)
                            description = description.."\n"..color..getText("Tooltip_ImmersiveHunting_DayLightImpact").." "..tostring(dayLight).."%"

                            -- fog
                            fog = fog*100
                            fog = fog - fog%1
                            color = ValueToRGBTag(fog)
                            description = description.."\n"..color..getText("Tooltip_ImmersiveHunting_FogImpact").." "..tostring(fog).."%"

                            -- wind
                            wind = wind*100
                            wind = wind - wind%1
                            color = ValueToRGBTag(wind)
                            description = description.."\n"..color..getText("Tooltip_ImmersiveHunting_WindImpact").." "..tostring(wind).."%"

                            -- scope
                            if ranged then
                                scope = scope*100
                                scope = scope - scope%1
                                color = ValueToRGBTag(scope)
                                description = description.."\n"..color..getText("Tooltip_ImmersiveHunting_ScopeBonus").." "..tostring(scope).."%"
                            end

                            local text
                            for k,v in pairs(impacts) do
                                text = getText("Tooltip_ImmersiveHunting_"..k)
                                v = v*100
                                v = v - v%1
                                color = ValueToRGBTag(v)
                                description = description.."\n"..color..text.." "..tostring(v).."%"
                            end

                            -- chance to hit
                            local chance = chanceToHit*100
                            chance = chance - chance%1
                            color = ValueToRGBTag(chance)
                            description = description.."\n"..color..getText("Tooltip_ImmersiveHunting_ChanceToHit").." "..tostring(chance).."%"

                            -- stealth
                            stealth = stealth*100
                            stealth = stealth - stealth%1
                            color = ValueToRGBTag(stealth)
                            description = description.."\n\n"..color..getText("Tooltip_ImmersiveHunting_StealthImpact").." "..tostring(stealth).."%"

                            -- moodles
                            moodle = moodle*100
                            moodle = moodle - moodle%1
                            color = ValueToRGBTag(moodle)
                            description = description.."\n"..color..getText("Tooltip_ImmersiveHunting_MoodleImpact").." "..tostring(moodle).."%"

                            -- traits
                            trait = trait*100
                            trait = trait - trait%1
                            color = ValueToRGBTag(trait)
                            description = description.."\n"..color..getText("Tooltip_ImmersiveHunting_TraitImpact").." "..tostring(trait).."%"

                            -- positive traits
                            local size = #traits_positive
                            if size > 0 then
                                description = description.."\n\n<GREEN>"..getText("Tooltip_ImmersiveHunting_PositiveTraits").."\n"
                                local item
                                for j = 1,size do
                                    item = traits_positive[j]
                                    description = description..item
                                    if j ~= size then
                                        description = description..", "
                                    end
                                end
                            end

                            -- negative traits
                            size = #traits_negative
                            if size > 0 then
                                description = description.."\n\n<RED>"..getText("Tooltip_ImmersiveHunting_NegativeTraits").."\n"
                                local item
                                for j = 1,size do
                                    item = traits_negative[j]
                                    description = description..item
                                    if j ~= size then
                                        description = description..", "
                                    end
                                end
                            end

                            -- total
                            chance = chanceToHunt*100
                            chance = chance - chance%1

                            color = ValueToRGBTag(chance)
                            description = description.."\n\n"..color..getText("Tooltip_ImmersiveHunting_ChanceToHunt").." "..tostring(chance).."%"
                        end
                    end

                    tooltip.description = description

                    option = context:addOptionOnTop(getText("ContextMenu_ImmersiveHunting_Hunt").." "..animalName,player,ImmersiveHunting.DoHunt,square,HuntInformation,baseIcon,weapon,chanceToHunt,kill,shred)

                    -- set tooltip and if available
                    option.toolTip = tooltip
                    if notAvailable then
                        option.notAvailable = true
                    end

                elseif name == getText("UI_foraging_DiscardItem").." "..displayName then
                    context:removeOptionByName(name)

                    option = context:addOption(getText("UI_foraging_DiscardItem").." "..animalName, baseIcon, baseIcon.onClickDiscard,square,player)
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
                local player = highlight.player or client_player
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

initTLOU_OnGameStart()