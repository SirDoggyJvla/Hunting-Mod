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

-- requirements
require "TimedActions/ISBaseTimedAction"
local activatedMods_FoodPreservationPlus = getActivatedMods():contains("FoodPreservationPlus")
local random = newrandom()


ImmersiveHunting_ISButcher = ISBaseTimedAction:derive("ImmersiveHunting_ISButcher")

function ImmersiveHunting_ISButcher:isValid()
	local carcass = self.carcass
	local carcassWorld = carcass:getWorldItem()

	-- verify item is still on the floor, if not means it can't be accessed by the player
	if not carcassWorld then
		return false
	end

	-- verify the hunger amount was not changed during butchering, possibly meaning another player 
	-- just butchered a piece (so cancel the other player action)
	local amountHarvest = math.ceil(-carcass:getHungChange())
	if amountHarvest ~= self.amountHarvest then
		return false
	end

	return true
end

function ImmersiveHunting_ISButcher:waitToStart()
	return false
end

function ImmersiveHunting_ISButcher:update()
	self.character:faceThisObject(self.worldItem)
end

function ImmersiveHunting_ISButcher:start()
	-- set animation
	self:setActionAnim("SawLog")

	-- play sound
	self.sound = self.character:getEmitter():playSound("PZ_FoodSwoosh")

	self.worldItem = self.carcass:getWorldItem()
end

function ImmersiveHunting_ISButcher:stop()
	ISBaseTimedAction.stop(self)
end

function ImmersiveHunting_ISButcher:perform()
	-- get data
	local carcass = self.carcass
	local character = self.character
	local amountHarvest = self.amountHarvest
	local animal = self.animal
	local meatItem = animal.meat
	local hungerAmount = self.hungerAmount
	local square = character:getSquare()

	-- reward player depending on traits
	if character:HasTrait("Hemophobic") then
		local stats = character:getStats()
		stats:setStress(stats:getStress() + 0.5)
	end

	local bodyDamage = character:getBodyDamage()
	if character:HasTrait("Hunter") then
		bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - 5)
	end
	if character:HasTrait("Pacifist") then
		bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() + 5)
	end

	-- add XP to the player for butchering
	character:getXp():AddXP(Perks.Cooking, 10)
	character:getXp():AddXP(Perks.SmallBlade, 10)

	-- get food values
	local hungerAmount_unique = hungerAmount/amountHarvest
	local calories = carcass:getCalories()/amountHarvest
	local lipids = carcass:getLipids()/amountHarvest
	local carbohydrates = carcass:getCarbohydrates()/amountHarvest
	local proteins = carcass:getProteins()/amountHarvest

	local meatItemInventory = InventoryItemFactory.CreateItem(meatItem) ---@cast meatItemInventory Food

	-- set the meatItem food values
	meatItemInventory:setBaseHunger(hungerAmount_unique)
	meatItemInventory:setHungChange(hungerAmount_unique)
	meatItemInventory:setCalories(calories)
	meatItemInventory:setLipids(lipids)
	meatItemInventory:setCarbohydrates(carbohydrates)
	meatItemInventory:setProteins(proteins)
	meatItemInventory:setCooked(carcass:isCooked())
	square:AddWorldInventoryItem(meatItemInventory, 0, 0, 0)

	-- give leather strips
	local item
	for _ = 1,random:random(1,2) do
		item = InventoryItemFactory.CreateItem("LeatherStripsDirty")
		square:AddWorldInventoryItem(item, 0, 0, 0)
	end

	-- give bones if food preservation plus
	if activatedMods_FoodPreservationPlus then
		for _ = 1,random:random(1,random:random(1,2)) do
			item = InventoryItemFactory.CreateItem("Bones")
			square:AddWorldInventoryItem(item, 0, 0, 0)
		end
	end

	-- check if corpse is done with
	amountHarvest = amountHarvest - 1
	if amountHarvest <= 0 then
		local worldItem = self.worldItem
		worldItem:removeFromWorld()
		worldItem:removeFromSquare()
	else
		-- update carcass food values
		local hungerAmount_carcass = hungerAmount_unique*amountHarvest
		carcass:setBaseHunger(hungerAmount_carcass)
		carcass:setHungChange(hungerAmount_carcass)
		carcass:setCalories(calories*amountHarvest)
		carcass:setLipids(lipids*amountHarvest)
		carcass:setCarbohydrates(carbohydrates*amountHarvest)
		carcass:setProteins(proteins*amountHarvest)

		-- queue another butchering
		ISTimedActionQueue.add(ImmersiveHunting_ISButcher:new(character,carcass,animal,hungerAmount_carcass,amountHarvest,200))
	end

	-- update container to show meat items or carcass removed
	triggerEvent("OnContainerUpdate")

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end


function ImmersiveHunting_ISButcher:new(character,carcass,animal,hungerAmount,amountHarvest,time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time

	-- custom fields
	o.carcass = carcass
	o.animal = animal
	o.hungerAmount = hungerAmount
	o.amountHarvest = amountHarvest
	return o
end
