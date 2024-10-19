--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Defines the timed actions for hunting of Hunting Mod.

]]--
--[[ ================================================ ]]--

-- requirements
require "TimedActions/ISBaseTimedAction"
local random = newrandom()

HuntingMod_ISHunt = ISBaseTimedAction:derive("HuntingMod_ISHunt")

function HuntingMod_ISHunt:isValid()
	return true
end

function HuntingMod_ISHunt:waitToStart()
	return false
end

function HuntingMod_ISHunt:update()
	-- get job delta
	local delta = 1 - self.action:getJobDelta()

	-- get coordinates
	local character = self.character
	local p_x,p_y = character:getX(),character:getY()
	local squareTarget = self.squareTarget

	-- get vector
	local vector = self.vector
	vector:setLength(self.distanceToStartPoint * delta)

	local x_target = squareTarget:getX() + vector:getX()
	local y_target = squareTarget:getY() + vector:getY()

	local x,y = x_target - p_x,y_target - p_y

	vector = Vector2.new(x,y)
	self.character:setForwardDirection(vector)

	self.vectorEnd = vector
end

function HuntingMod_ISHunt:start()
	self.character:setAttackAnim(true)
end

function HuntingMod_ISHunt:stop()
	self.character:setAttackAnim(false)
	ISBaseTimedAction.stop(self);
end

function HuntingMod_ISHunt:perform()
	-- get character
	local character = self.character
	local isRanged = self.isRanged

	-- retrieve icon and manager to delete icon
	local manager = ISSearchManager:new(character)
	local baseIcon = self.baseIcon

	--flag the icon for removal
	baseIcon:setIsBeingRemoved(true)

	--do the icon removal
	manager:removeItem(baseIcon)
	manager:removeIcon(baseIcon)

	-- remove data on square
	self.square:getModData().HuntInformation = nil

	-- attack
	local swingSound = self.weapon:getSwingSound()
	local emitter = character:getEmitter()
	emitter:playSound(swingSound)
	character:DoAttack(1)

	-- test if hunt is successful
	local test = self.chanceToHunt*100 >= random:random(1,100)
	local kill = self.kill or self.mightKill and random:random(1,2) == 2

	if test and kill then
		character:Say(getText("IGUI_HuntingMod_SuccessHunt"..tostring(random:random(1,8))))

		-- determine the bonus size
		local size
		if self.shred then
			size = random:random(SandboxVars.HuntingMod.MinimumBonusSizeShred,SandboxVars.HuntingMod.MaximumBonusSizeShred)/100
		else
			size = random:random(SandboxVars.HuntingMod.MinimumBonusSize,SandboxVars.HuntingMod.MaximumBonusSize)/100
		end
		local item = InventoryItemFactory.CreateItem(self.animal.dead);
		---@cast item Food

		item:setHungChange(item:getHungChange() * size)
		item:setCalories(item:getCalories() * size)
		item:setLipids(item:getLipids() * size)
		item:setCarbohydrates(item:getCarbohydrates() * size)
		item:setProteins(item:getProteins() * size)

		-- if melee, spawn corpse on player
		local square = isRanged and self.squareTarget or self.square
		square:AddWorldInventoryItem(item, 0, 0, 0)

		-- show the square with the hunting target
		HuntingMod.AddHighlightSquare(square,{r=1,g=1,b=1},self.character)
	else
		character:Say(getText("IGUI_HuntingMod_FailedHunt"..tostring(random:random(1,8))))
	end

	-- reward with XP
	local xpGain = SandboxVars.HuntingMod.XPGainHunting
	character:getXp():AddXP(Perks.PlantScavenging, xpGain)

	if isRanged then
		character:getXp():AddXP(Perks.Aiming, xpGain)
	else
		local categories = self.weapon:getCategories()
		local playerXP = character:getXp()
        local category, perk
        for i = 0,categories:size() - 1 do
            -- get category
            category = categories:get(i)
			perk = Perks[category]
			if perk then
				playerXP:AddXP(perk, xpGain)
			end
		end
	end

	self.character:setAttackAnim(false)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

---Create a new timed action to hunt a target
---@param character IsoPlayer
---@param square IsoGridSquare
---@param squareTarget IsoGridSquare
---@param chanceToHunt number
---@param baseIcon table
---@param weapon HandWeapon
---@param kill boolean
---@param shred boolean
---@param time number
---@return table
function HuntingMod_ISHunt:new(character,square,squareTarget,animal,chanceToHunt,baseIcon,weapon,kill,shred,time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time

	-- custom fields
	o.square = square
	o.squareTarget = squareTarget
	o.animal = animal
    o.chanceToHunt = chanceToHunt
	o.baseIcon = baseIcon
	o.weapon = weapon
	o.kill = kill
	o.shred = shred
	o.isRanged = weapon:isRanged()

	-- determine perpendicular point
	local distanceToStartPoint = random:random(5,10)
	o.distanceToStartPoint = distanceToStartPoint
	local direction = random:random(0,1) == 1 and -1 or 1

	-- get distance from square to squareTarget
	local x,y = squareTarget:getX() - square:getX(),squareTarget:getY() - square:getY()
	local vector = Vector2.new(x,y)
	local distanceToSquareTarget = vector:getLength()
	o.distanceToSquareTarget = distanceToSquareTarget

	-- determine vector squareTarget to squareStart
	vector:rotate(direction * math.pi/2)
	vector:setLength(distanceToStartPoint)

	o.vector = vector

	return o
end
