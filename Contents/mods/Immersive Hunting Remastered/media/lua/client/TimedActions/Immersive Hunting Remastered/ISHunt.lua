--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Defines the timed actions for hunting of Immersive Hunting Remastered.

]]--
--[[ ================================================ ]]--

require "TimedActions/ISBaseTimedAction"

ImmersiveHunting_ISHunt = ISBaseTimedAction:derive("ImmersiveHunting_ISHunt")

function ImmersiveHunting_ISHunt:isValid()
	return true
end

function ImmersiveHunting_ISHunt:waitToStart()
	return false
end

function ImmersiveHunting_ISHunt:update()

end

function ImmersiveHunting_ISHunt:start()
	self.character:setAttackAnim(true)
end

function ImmersiveHunting_ISHunt:stop()
	self.character:setAttackAnim(false)
	ISBaseTimedAction.stop(self);
end

function ImmersiveHunting_ISHunt:perform()
	-- show the square with the hunting target
	ImmersiveHunting.AddHighlightSquare(self.squareTarget,{r=1,g=1,b=1},self.character)

	-- remove the foraging icon and data related to it
    -- self.baseIcon:onClickDiscard()
	-- self.square:getModData().HuntInformation = nil

	local character = self.character
	local swingSound = self.weapon:getSwingSound()
	local emitter = character:getEmitter()
	emitter:playSound(swingSound)


	character:DoAttack(1)
	-- self.character:pressedAttack(true)
	character:setAttackAnim(false)
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
---@param time number
---@return table
function ImmersiveHunting_ISHunt:new(character,square,squareTarget,chanceToHunt,baseIcon,weapon,time)
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
    o.chanceToHunt = chanceToHunt
	o.baseIcon = baseIcon
	o.weapon = weapon
	o.isRanged = weapon:isRanged()
	return o
end
