--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Main file of Hunting Mod.

]]--
--[[ ================================================ ]]--

-- requirements
local HuntingMod = require "HuntingMod_module"
local climateManager = getClimateManager()
local gametime = getGameTime()
local random = newrandom()
local isDebug = getDebug()

-- localy initialize player and values
local client_player = getPlayer()
local function initTLOU_OnGameStart(playerIndex, player_init)
	client_player = getPlayer()

    -- determine a and b for y = ax + b for aiming impact
    local x1 = SandboxVars.HuntingMod.MinimumAimingLevelToHunt
    local x2 = SandboxVars.HuntingMod.MaximumAimingLevelToHunt
    local y1 = SandboxVars.HuntingMod.MinimumAimingImpact
    local y2 = SandboxVars.HuntingMod.MaximumAimingImpact

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

    HuntingMod.a_aiming = (y2-y1)/(x2-x1)/100
    HuntingMod.b_aiming = (x2*y1 - x1*y2)/(x2-x1)/100


    -- determine a and b for y = ax + b for stength impact
    x1 = SandboxVars.HuntingMod.MinimumMeleeLevelToHunt
    x2 = SandboxVars.HuntingMod.MaximumMeleeLevelToHunt
    y1 = SandboxVars.HuntingMod.MinimumMeleeImpact
    y2 = SandboxVars.HuntingMod.MaximumMeleeImpact

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

    HuntingMod.a_melee = (y2-y1)/(x2-x1)/100
    HuntingMod.b_melee = (x2*y1 - x1*y2)/(x2-x1)/100


    -- determine a and b for y = ax + b for strength impact
    x1 = SandboxVars.HuntingMod.MinimumStrengthLevelToHunt
    x2 = SandboxVars.HuntingMod.MaximumStrengthLevelToHunt
    y1 = SandboxVars.HuntingMod.MinimumStrengthImpact
    y2 = SandboxVars.HuntingMod.MaximumStrengthImpact

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

    HuntingMod.a_strength = (y2-y1)/(x2-x1)/100
    HuntingMod.b_strength = (x2*y1 - x1*y2)/(x2-x1)/100


    -- determine a and b for y = ax + b for stealth impact
    x1 = 0
    x2 = 10
    y1 = SandboxVars.HuntingMod.MinimumStealthImpact
    y2 = SandboxVars.HuntingMod.MaximumStealthImpact

    if y2 < y1 then
        print("ERROR: Minimum and maximum stealth impact to hunting need to the maximum greater or equal to the minimum. Using default value in the meantime.")
        y1 = 70
        y2 = 150
    end

    HuntingMod.a_stealth = (y2-y1)/(x2-x1)/100
    HuntingMod.b_stealth = (x2*y1 - x1*y2)/(x2-x1)/100
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)

---Returns the hunting informations on the target, or initialize them if they aren't already.
---@param square IsoGridSquare
---@param player IsoPlayer
---@return table
HuntingMod.GetHuntInformations = function(square,player)
    -- get options
    local HuntInformation = square:getModData().HuntInformation

    -- define informations on the hunt target
    if not HuntInformation or not HuntInformation.squareTarget then
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

        square:getModData().HuntInformation = {
            squareTarget = squareTarget,
        }
        HuntInformation = square:getModData().HuntInformation
    end

    return HuntInformation
end

---Determines whenever a weapon will kill or not. It also determines if
---the weapon might kill, which will be basically an extra roll if weapon
---hits hunting target.
---@param player IsoPlayer
---@param weapon HandWeapon
---@param huntTarget string
---@return boolean|nil canAttack
---@return table results
---@return string reason
HuntingMod.GetWeaponStats = function(player,weapon,huntTarget)
    local canAttack = true
    local results = {
        kill = false,
        mightKill = false,
        shred = false,
        chanceToHit = 0,
        impacts = {},
    }
    local impacts = results.impacts
    local reason = ""

    -- get data related to hunting type
    local targetConditions = HuntingMod.HuntingConditions[huntTarget]

    ------- hanndle as ranged -------
    if weapon:isRanged() then
        -- check if jammed
        if weapon:isJammed() then return false, results, "Tooltip_HuntingMod_IsJammed" end

        -- verify is loaded
        if weapon:haveChamber() then
            if not weapon:isRoundChambered() then return false, results, "Tooltip_HuntingMod_NoRoundChambered" end
        else
            if weapon:getCurrentAmmoCount() == 0 then return false, results, "Tooltip_HuntingMod_NoAmmo" end
        end

        -- check ammo type
        local ammo = weapon:getAmmoType()
        if not ammo then return false, results, "Tooltip_HuntingMod_noAmmoType" end

        -- ranged can attack
        canAttack = true

        -- default to mightKill for non-compatible calibers
        local caliberDataBase = HuntingMod.CaliberDataBase[ammo]
        if not caliberDataBase then
            results.chanceToHit = 80
            results.mightKill = true
            return canAttack, results, "Tooltip_HuntingMod_notRecognized"
        end

        -- get huntingCaliber data
        local ammoType = caliberDataBase.AmmoType
        local targetLimits = targetConditions.huntingCaliber[ammoType]
        if not targetLimits then
            return canAttack, results, "Tooltip_HuntingMod_badCaliber"
        end

        -- aiming impact
        local aimingImpact = 1
        if SandboxVars.HuntingMod.AimingImpact then
            local aimingLevel = player:getPerkLevel(Perks.Aiming)
            if aimingLevel < SandboxVars.HuntingMod.MinimumAimingLevelToHunt then
                return false, results, "Tooltip_HuntingMod_badAiming"
            end
            aimingImpact = aimingLevel*HuntingMod.a_aiming + HuntingMod.b_aiming
            impacts.AimingImpact = aimingImpact
        end

        -- weapon impact
        local gunImpact = 1 - (1 - targetLimits.impact/10) * SandboxVars.HuntingMod.WeaponImpact/100
        impacts.WeaponImpact = gunImpact

        -- total chance to hit
        results.chanceToHit = gunImpact * aimingImpact

        -- energy of bullet or projectile types is considered
        if ammoType == "Bullet" or ammoType == "Projectile" then
            -- verify bullet can kill
            if caliberDataBase.Emin > targetLimits.Emin then
                results.kill = true
                results.mightKill = true

            elseif caliberDataBase.Emax > targetLimits.Emin then
                results.mightKill = true
            end

            -- if hunting target is susceptible to shreding (losing value)
            if targetConditions.canBeShrededDiameter and caliberDataBase.Diameter > targetLimits.Diameter
            or targetConditions.canBeShrededEnergy and caliberDataBase.Emax > targetLimits.Emax
            then
                results.shred = true
            end

        -- energy is ignored here, diameter is considered instead
        -- slug can kill big games, but shreds small birds, birds are one shot tho
        ---
        ---TODO: consider energy
        ---
        elseif ammoType == "Shotgun" then
            -- verify if hunting target should die from shotgun instantly (typically birds)
            if targetLimits.kill then
                results.kill = true
                results.mightKill = true

            -- else calculate based on needed diameter of shotgun to kill
            elseif caliberDataBase.Diameter > targetLimits.Diameter then
                results.kill = true
                results.mightKill = true
            end

            -- if hunting target is susceptible to shreding (losing value)
            if targetConditions.canBeShrededDiameter then
                if caliberDataBase.Diameter > targetLimits.shredDiameter then
                    results.shred = true
                end
            end

        -- other types are special, they might be non-lethal weapons
        -- or arrows, slingshots etc
        elseif ammoType == "Other" then
            -- verify such a caliber can kill
            if caliberDataBase.CanKill then
                results.kill = true
                results.mightKill = true
            end
        end


    ------- handle as melee -------
    else
        -- melee can always attack
        canAttack = true

        -- get melee rules for this huntTarget
        local meleeConditions = targetConditions.melee
        local melee_mightKill = meleeConditions.mightKill
        local melee_willKill = meleeConditions.willKill
        local melee_noMeleeTwoHanded = meleeConditions.noMeleeTwoHanded

        local twoHanded = weapon:isTwoHandWeapon()

        -- iterate through every categories and check every weapon types
        local categories = weapon:getCategories()
        local a_melee,b_melee = HuntingMod.a_melee,HuntingMod.b_melee
        for i = 0,categories:size() - 1 do
            -- get category
            local category = categories:get(i)

            -- if weapon is two handed, verify if its category can be
            if melee_noMeleeTwoHanded and twoHanded then
                -- if weapon can't be used to hunt bcs two handed, skip
                if melee_noMeleeTwoHanded[category] then
                    return true, results, "Tooltip_HuntingMod_twoHanded"..category
                end
            end

            -- get level in this weapon handling
            local perk = Perks[category]
            local level = perk and player:getPerkLevel(Perks[category]) or player:getPerkLevel(Perks.Maintenance)
            local meleeImpact = level*a_melee + b_melee

            -- get chance to kill or mightKill
            local chanceKill = melee_willKill[category]
            chanceKill = chanceKill and chanceKill/10*meleeImpact
            local chanceMightKill = melee_mightKill[category]
            chanceMightKill = chanceMightKill and chanceMightKill/10*meleeImpact

            -- check if chance to kill or might kill is higher than precedent chance
            if chanceKill then
                results.kill = true
                results.mightKill = true

                if chanceKill > results.chanceToHit then
                    results.chanceToHit = chanceKill
                    impacts.WeaponImpact = meleeImpact
                end

            -- check if it might kill if not already the case
            elseif chanceMightKill then
                results.mightKill = true

                if chanceMightKill > results.chanceToHit then
                    results.chanceToHit = chanceMightKill
                    impacts.meleeImpact = meleeImpact
                end
            end
        end

        -- verify the character even has a single chance of hunting here
        if results.chanceToHit == 0 then
            return true, results, "Tooltip_HuntingMod_notSkilledEnough"
        end

        -- strength impact
        if SandboxVars.HuntingMod.StrengthImpact then
            local strengthLevel = player:getPerkLevel(Perks.Strength)
            if strengthLevel < SandboxVars.HuntingMod.MinimumStrengthLevelToHunt then
                return true, results, "Tooltip_HuntingMod_notStrongEnough"
            end
            local strengthImpact = strengthLevel*HuntingMod.a_strength + HuntingMod.b_strength
            results.chanceToHit = results.chanceToHit * strengthImpact
            impacts.StrengthImpact = strengthImpact
        end
    end

    return canAttack, results, reason
end

---Do the hunting.
---@param player IsoPlayer
---@param square IsoGridSquare
---@param squareTarget IsoGridSquare
---@param animal table
---@param baseIcon table
---@param weapon HandWeapon
---@param chanceToHunt number
---@param kill boolean
---@param shred boolean
HuntingMod.DoHunt = function(player,square,squareTarget,animal,baseIcon,weapon,chanceToHunt,kill,shred)
    -- safeguard if a sneak bastard opens a new context menu for the icon during a precedent hunting
    if not square:getModData().HuntInformation then return end

    local x,y = player:getX() - square:getX(),player:getY() - square:getY()
    local d = (x*x + y*y)^0.5

    -- if too far from the square for hunting, make the player move there
    if d >= 2 then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(player, square))
    end

    -- equip gun if player tried to cheat and put it away
    if player:getPrimaryHandItem() ~= weapon then
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, weapon, 50, true))
    end

    -- start hunting
    ISTimedActionQueue.add(HuntingMod_ISHunt:new(player,square,squareTarget,animal,chanceToHunt,baseIcon,weapon,kill,shred,200))
end

HuntingMod.Discard = function(baseIcon,square,player)
    player:getXp():AddXP(Perks.PlantScavenging, SandboxVars.HuntingMod.XPGainDiscard)

    square:getModData().HuntInformation = nil
    baseIcon:onClickDiscard()
end

---Returns if a weapon can shoot, or true if not ranged.
---@param weapon HandWeapon|nil
---@return boolean|nil
---@return string
HuntingMod.CanShoot = function(weapon)
    -- if no weapon
    if not weapon then return nil, "Tooltip_HuntingMod_NeedWeapon" end

    -- verify if ranged
    if not weapon:isRanged() then return true, "" end

    -- check if jammed
    if weapon:isJammed() then return false, "Tooltip_HuntingMod_IsJammed" end

    -- verify is loaded
    if weapon:haveChamber() then
        if not weapon:isRoundChambered() then return false, "Tooltip_HuntingMod_NoRoundChambered" end
    else
        if weapon:getCurrentAmmoCount() == 0 then return false, "Tooltip_HuntingMod_NoAmmo" end
    end

    return true, ""
end

---Gives the hunt chance impact from skills and player stats.
---@param player IsoPlayer
---@return number
---@return number
---@return number
---@return table
---@return table
HuntingMod.GetPlayerStatsChance = function(player)
    -- check moodles
    local moodleImpact = SandboxVars.HuntingMod.MoodleImpact/100

    local hasCold = player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0.25 and 0.2 or 0
    local cold = 1 - hasCold*moodleImpact
    local moodle = cold

    -- check traits
    local traits_positive = table.newarray()
    local traits_negative = table.newarray()
    local traitToName = HuntingMod.TraitsToName
    local trait = 1
    local traitImpact = SandboxVars.HuntingMod.TraitImpact/100
    for k,v in pairs(HuntingMod.TraitsToCheck) do
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
    local stealth = HuntingMod.a_stealth * stealthLevel + HuntingMod.b_stealth

    return trait, moodle, stealth, traits_positive, traits_negative
end

HuntingMod.ValueToRGBTag = function(value)
    value = value > 100 and 100 or value < 0 and 0 or value
    local r = 1 - (value / 100)^6
    -- r = r - r%1
    local g = 1 - (value / 100 - 1)^6
    -- g = g - g%1
    local b = 0
    return "<RGB:"..tostring(r)..","..tostring(g)..","..tostring(b)..">"
end

HuntingMod.onFillSearchIconContextMenu = function(context, baseIcon)
    -- verify it's valid
    if not baseIcon or not context then return end

    -- verify it's a forage icon
    if baseIcon.iconClass ~= "forageIcon" then return end

    -- verify it's one of our items
    local itemType = baseIcon.itemType
    local animal = HuntingMod.ForageAnimalTracks[itemType]
    if not animal then return end

    HuntingMod.HandleIcon(context,baseIcon,animal)
end

HuntingMod.CalculateWorldImpacts = function()
    local impacts = {}

    -- daylight
    local daylightImpact = SandboxVars.HuntingMod.LightImpact
    if daylightImpact ~= 0 then
        impacts.DayLightImpact = 1 - (gametime:getNight())*daylightImpact/100
    end

    -- fog
    local fogImpact = SandboxVars.HuntingMod.FogImpact
    if fogImpact ~= 0 then
        impacts.FogImpact = 1 - climateManager:getFogIntensity()*fogImpact/100
    end

    -- wind
    local windImpact = SandboxVars.HuntingMod.WindImpact
    if windImpact ~= 0 then
        impacts.WindImpact = 1 - climateManager:getWindIntensity()*windImpact/100
    end

    return impacts
end


---Remove the pickup and discard options and replace them with our own hunt and discard options.
---Also calculate the chances to hit target and handle the tooltip.
---@param context table
---@param baseIcon table
---@param animal table
HuntingMod.HandleIcon = function(context,baseIcon,animal)
    -- retrieve options and name
    local options = context.options
    if not options then return end

    -- clean options with fresh ones
    for i = #options, 1, -1 do
        local option = options[i]
        if option then
            local name = option.name
            context:removeOptionByName(name)
        end
    end

    -- get informations on hunt
    local player = baseIcon.character
    local square = baseIcon.square
    local HuntInformation = HuntingMod.GetHuntInformations(square,player)

    -- get informations on the animal
    local animalName = getText(animal.name)
    local sprite = animal.sprite
    local huntTarget = animal.huntTarget

    -- access the texture to show on the icon
    local animalTexture
    if sprite then
        animalTexture = Texture.trygetTexture(animal.sprite)

    -- get dead animal texture instead
    else
        local scriptItem = getScriptManager():FindItem(animal.dead)
        animalTexture = scriptItem and scriptItem:getNormalTexture()
    end

    -- get dimensions
    local width = animalTexture:getWidth()
    local height = animalTexture:getHeight()
    local ratio = width/height

    -- adapt dimensions to icon
    if width > height then
        width = 32
        height = width/ratio
    else
        height = 32
        width = height*ratio
    end

    -- set the icon texture
    local animalTexture_resized = Texture.new(animalTexture)
    animalTexture_resized:setWidth(width)
    animalTexture_resized:setHeight(height)
    baseIcon.itemTexture = animalTexture_resized

    -- get the animal texture in tooltip
    local texture = string.gsub(animalTexture:getName(), "^.*media", "media")
    height = 40
    width = height*ratio
    texture = "<IMAGECENTRE:"..texture..","..width..","..height..">"

    -- initialize description
    local description = "<CENTRE>"..texture.."\n"..animalName.."\n"

    -- create tooltip
    local tooltip = ISWorldObjectContextMenu.addToolTip()
    local notAvailable,chanceToHunt,kill,shred

    -- get player weapon
    local weapon = player:getPrimaryHandItem()
    if not instanceof(weapon,"HandWeapon") then
        weapon = nil
        description = description.."\n <RED>"..getText("Tooltip_HuntingMod_NeedWeapon")
        notAvailable = true

    else
        ---@cast weapon HandWeapon

        -- set the tool tip texture with the weapon
        local normalTexture = weapon:getTexture()

        -- set the weapon texture in tooltip
        texture = ""
        if normalTexture then
            -- get dimensions
            width = normalTexture:getWidth()
            height = normalTexture:getHeight()
            ratio = width/height

            -- normalize height
            height = 40
            width = height*ratio

            -- prepare texture string
            texture = string.gsub(normalTexture:getName(), "^.*media", "media")
            texture = "\n<IMAGECENTRE:"..texture..","..width..","..height..">\n"
        end

        description = description..texture
        .."<CENTRE>"..getText("Tooltip_HuntingMod_CurrentWeapon",weapon:getDisplayName()).."\n"

        -- get weapon ability to kill
        local canAttack, results, reason = HuntingMod.GetWeaponStats(player,weapon,huntTarget)
        kill = results.kill
        local mightKill = results.mightKill
        shred = results.shred

        -- verify the character has a weapon and can shoot with it
        if not canAttack or reason ~= "" then
            notAvailable = true
            description = description.."Reason: "..getText(reason)

        -- verify weapon has a chance to kill
        elseif not kill and not mightKill then
            notAvailable = true
            description = description..getText("Tooltip_HuntingMod_CannotKillTarget")

        else

            -- will kill ?
            if kill then
                description = description..getText("Tooltip_HuntingMod_CanKill").."\n"
            end

            -- weapon not adapted
            if not kill and mightKill or shred then
                description = description.."\n"..getText("Tooltip_HuntingMod_NotAdapted").."\n"

                -- can't kill
                if not kill and mightKill then
                    description = description..getText("Tooltip_HuntingMod_MightNotKill").."\n"
                end

                -- will shred
                if shred then
                    description = description..getText("Tooltip_HuntingMod_WillShred").."\n"
                end
            end

            -- intialize chances to hunt
            chanceToHunt = 1

            -- show probabilities ?
            local showProbabilities = SandboxVars.HuntingMod.ShowProbabilities
            local ValueToRGBTag = HuntingMod.ValueToRGBTag
            if showProbabilities then
                description = description.."\n<RGB:1,1,1>"..getText("Tooltip_HuntingMod_impacts").."\n"
            end

            ------ weapon ability to hunt ------
            local chanceToHit = results.chanceToHit

            -- scope bonus
            local scopeImpact = SandboxVars.HuntingMod.ScopeBonus
            local scopeBonus
            if scopeImpact ~= 0 and weapon:isRanged() and weapon:getScope() then
                scopeBonus = 1 + scopeImpact/100
                chanceToHit = chanceToHit * scopeBonus
            end

            -- show weapon impact
            if showProbabilities then
                description = description.."\n"..getText("Tooltip_HuntingMod_Weapon")

                -- skill impact
                for k,v in pairs(results.impacts) do
                    local text = getText("Tooltip_HuntingMod_"..k)
                    v = v*100
                    v = v - v%1
                    local color = ValueToRGBTag(v)
                    description = description.."\n"..color..text.." "..tostring(v).."%"
                end

                -- scope ability
                if scopeBonus then
                    local v = scopeBonus*100
                    v = v - v%1
                    local color = ValueToRGBTag(v)
                    description = description.."\n"..color..getText("Tooltip_HuntingMod_ScopeBonus").." "..tostring(v).."%"
                end

                -- final weapon probabilities
                local v = chanceToHit*100
                v = v - v%1
                local color = ValueToRGBTag(v)
                description = description.."\n"..color..getText("Tooltip_HuntingMod_ChanceToHit").." "..tostring(v).."%\n"

                -- world impact
                description = description.."\n"..getText("Tooltip_HuntingMod_World")
            end

            -- apply world stats to impact hunting chances
            local impacts = HuntingMod.CalculateWorldImpacts()
            local chanceWorld = 1
            for impactName,impact in pairs(impacts) do
                impact = impact < 0 and 0 or impact
                chanceWorld = chanceWorld * impact

                -- format the probabilities to show in tooltip
                if showProbabilities then
                    local value = impact*100
                    value = value - value%1
                    local color = ValueToRGBTag(value)
                    description = description.."\n"..color..getText("Tooltip_HuntingMod_"..impactName).." "..tostring(value).."%"
                end
            end

            -- apply character stats impact
            local trait, moodle, stealth, traits_positive, traits_negative = HuntingMod.GetPlayerStatsChance(player)
            local chanceStats = trait*moodle*stealth

            -- show weapon impact
            if showProbabilities then
                description = description.."\n\n"..getText("Tooltip_HuntingMod_Stats")

                -- traits impact
                if trait ~= 1 then
                    local v = trait*100
                    v = v - v%1
                    local color = ValueToRGBTag(v)
                    description = description.."\n"..color..getText("Tooltip_HuntingMod_TraitImpact").." "..tostring(v).."%"

                    -- positive traits
                    local size = #traits_positive
                    if size > 0 then
                        description = description.."\n\n<GREEN>"..getText("Tooltip_HuntingMod_PositiveTraits").."\n"
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
                    local size = #traits_negative
                    if size > 0 then
                        description = description.."\n\n<RED>"..getText("Tooltip_HuntingMod_NegativeTraits").."\n"
                        local item
                        for j = 1,size do
                            item = traits_negative[j]
                            description = description..item
                            if j ~= size then
                                description = description..", "
                            end
                        end
                    end
                end

                -- moodle impact
                if moodle ~= 1 then
                    local v = moodle*100
                    v = v - v%1
                    local color = ValueToRGBTag(v)
                    description = description.."\n"..color..getText("Tooltip_HuntingMod_MoodleImpact").." "..tostring(v).."%"
                end

                -- stealth impact
                local v = chanceStats*100
                v = v - v%1
                local color = ValueToRGBTag(v)
                description = description.."\n"..color..getText("Tooltip_HuntingMod_ChanceStats").." "..tostring(v).."%"
            end

            -- final chance of hunting target
            chanceToHunt = chanceToHunt*chanceToHit*chanceWorld*chanceStats

            if showProbabilities then
                local v = chanceToHunt*100
                v = v - v%1
                local color = ValueToRGBTag(v)
                description = description.."\n\n"..color..getText("Tooltip_HuntingMod_FinalProbability").." "..tostring(v).."%"
            end
        end
    end

    -- add debug hunting option
    if isDebug then
        local option = context:addOption(
            "DEBUG MODE: Force Hunt".." "..animalName,
            player,
            HuntingMod.DoHunt,
            square,
            HuntInformation.squareTarget,
            animal,
            baseIcon,
            weapon,
            1000,
            true,
            false
        )

        -- set tooltip and if available
        local debug_tooltip = ISWorldObjectContextMenu.addToolTip()
        debug_tooltip.description = "<CENTRE><RED> DEBUG MODE, FORCE HUNT <RGB:1,1,1>\n"..description
        option.toolTip = debug_tooltip
    end

    -- create the option
    local option = context:addOption(
        getText("ContextMenu_HuntingMod_Hunt").." "..animalName,
        player,
        HuntingMod.DoHunt,
        square,
        HuntInformation.squareTarget,
        animal,
        baseIcon,
        weapon,
        chanceToHunt,
        kill,
        shred
    )

    -- set tooltip and if available
    tooltip.description = description
    option.toolTip = tooltip
    if notAvailable then
        option.notAvailable = true
    end

    -- add discard option
    option = context:addOption(getText("UI_foraging_DiscardItem").." "..animalName, baseIcon, baseIcon.onClickDiscard,square,player)
end

--#region Functions to highlight squares

--- Based on Rodriguo's work

---Add a square to highlight.
---@param square IsoGridSquare
---@param ISColors table
HuntingMod.AddHighlightSquare = function(square, ISColors,player)
    if not square or not ISColors then return end
    table.insert(HuntingMod.highlightsSquares, {square = square, color = ISColors, player = player, time = os.time()})
end

---Render squares in the list and remove them based on conditions.
HuntingMod.RenderHighLights = function()
    local size = #HuntingMod.highlightsSquares
    if #HuntingMod.highlightsSquares == 0 then return end
    for i = size,1,-1 do
        local highlight = HuntingMod.highlightsSquares[i]
        local square = highlight.square
        if square ~= nil and instanceof(square, "IsoGridSquare") then
            local x,y,z = square:getX(), square:getY(), square:getZ()
            local r,g,b = highlight.color.r, highlight.color.g, highlight.color.b

            -- check since how long this square has been highlighted
            local time = os.time() - highlight.time
            if time > 60 then
                table.remove(HuntingMod.highlightsSquares, i)
            elseif time > 10 then
                local player = highlight.player or client_player
                local p_x = player:getX()
                local p_y = player:getY()
                local new_x = x - p_x
                local new_y = y - p_y
                local d = (new_x*new_x + new_y*new_y)^0.5
                if d < 2 then
                    table.remove(HuntingMod.highlightsSquares, i)
                elseif d > 50 then
                    table.remove(HuntingMod.highlightsSquares, i)
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