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
local activatedMods_FoodPreservationPlus = getActivatedMods():contains("FoodPreservationPlus")
local random = newrandom()


HuntingMod_ISButcher = ISBaseTimedAction:derive("HuntingMod_ISButcher")

function HuntingMod_ISButcher:isValid()
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

function HuntingMod_ISButcher:waitToStart()
	return false
end

function HuntingMod_ISButcher:update()
	self.character:faceThisObject(self.worldItem)
end

function HuntingMod_ISButcher:start()
	-- set animation
	self:setActionAnim("SawLog")

	-- play sound
	self.sound = self.character:getEmitter():playSound("PZ_FoodSwoosh")

	self.worldItem = self.carcass:getWorldItem()
end

function HuntingMod_ISButcher:stop()
	ISBaseTimedAction.stop(self)
end

function HuntingMod_ISButcher:perform()
	-- get data
	local carcass = self.carcass
	local character = self.character
	local amountHarvest = self.amountHarvest
	local animal = self.animal
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

	-- get meat item food values
	local hungerAmount_meatItem = hungerAmount/amountHarvest
	local calories_meatItem = carcass:getCalories()/amountHarvest
	local lipids_meatItem = carcass:getLipids()/amountHarvest
	local carbohydrates_meatItem = carcass:getCarbohydrates()/amountHarvest
	local proteins_meatItem = carcass:getProteins()/amountHarvest

	-- store copies of food values for the update of carcass food values
	local hungerAmount_left = hungerAmount_meatItem
	local calories_left = calories_meatItem
	local lipids_left = lipids_meatItem
	local carbohydrates_left = carbohydrates_meatItem
	local proteins_left = proteins_meatItem

	-- create fat item
	local fat = animal.fat
	if fat then
		local carcass_modData = carcass:getModData().HuntingMod
		if carcass_modData then
			local fatLeft = carcass_modData.fatLeft
			if fatLeft > 0 then
				carcass_modData.fatLeft = fatLeft - 1

				local fatItemInventory = InventoryItemFactory.CreateItem(fat) --[[@as Food]]

				-- remove food value from meatItem food values
				hungerAmount_meatItem = hungerAmount_meatItem - fatItemInventory:getBaseHunger()
				calories_meatItem = calories_meatItem - fatItemInventory:getCalories()
				lipids_meatItem = lipids_meatItem - fatItemInventory:getLipids()
				carbohydrates_meatItem = carbohydrates_meatItem - fatItemInventory:getCarbohydrates()
				proteins_meatItem = proteins_meatItem - fatItemInventory:getProteins()

				-- safeguard in case value gets lower than 0
				calories_meatItem = calories_meatItem >= 0 and calories_meatItem or 0
				lipids_meatItem = lipids_meatItem >= 0 and lipids_meatItem or 0
				carbohydrates_meatItem = carbohydrates_meatItem >= 0 and carbohydrates_meatItem or 0
				proteins_meatItem = proteins_meatItem >= 0 and proteins_meatItem or 0

				square:AddWorldInventoryItem(fatItemInventory, 0, 0, 0)
			end
		end
	end

	-- create the meat item
	local meatItemInventory = InventoryItemFactory.CreateItem(animal.meat) --[[@as Food]]

	-- set meat item's name to meatName if exists
	local meatName = animal.meatName
	if meatName then
		meatItemInventory:setName(getText(meatName))
	end

	-- set the meatItem food values
	meatItemInventory:setBaseHunger(hungerAmount_meatItem)
	meatItemInventory:setHungChange(hungerAmount_meatItem)
	meatItemInventory:setCalories(calories_meatItem)
	meatItemInventory:setLipids(lipids_meatItem)
	meatItemInventory:setCarbohydrates(carbohydrates_meatItem)
	meatItemInventory:setProteins(proteins_meatItem)
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
		local hungerAmount_carcass = hungerAmount_left*amountHarvest
		carcass:setBaseHunger(hungerAmount_carcass)
		carcass:setHungChange(hungerAmount_carcass)
		carcass:setCalories(calories_left*amountHarvest)
		carcass:setLipids(lipids_left*amountHarvest)
		carcass:setCarbohydrates(carbohydrates_left*amountHarvest)
		carcass:setProteins(proteins_left*amountHarvest)

		-- queue another butchering
		ISTimedActionQueue.add(HuntingMod_ISButcher:new(character,carcass,animal,hungerAmount_carcass,amountHarvest,200))
	end

	-- update container to show meat items or carcass removed
	triggerEvent("OnContainerUpdate")

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end


function HuntingMod_ISButcher:new(character,carcass,animal,hungerAmount,amountHarvest,time)
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
