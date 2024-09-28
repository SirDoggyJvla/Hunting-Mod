function SIHButcherDeer_OnCreate(items, result, player)
    local corpse = nil;
    for i=0,items:size() - 1 do
        if instanceof(items:get(i), "Food") then
            corpse = items:get(i);
            break;
        end
    end
    if corpse then
        local hunger = math.max(corpse:getBaseHunger(), corpse:getHungChange())
        result:setBaseHunger(hunger / 5);
        result:setHungChange(hunger / 5);
        result:setActualWeight((corpse:getActualWeight() * 0.9) / 5)
        result:setWeight(result:getActualWeight());
        result:setCustomWeight(true)
        result:setCarbohydrates(corpse:getCarbohydrates() / 5);
        result:setLipids(corpse:getLipids() / 5);
        result:setProteins(corpse:getProteins() / 5);
        result:setCalories(corpse:getCalories() / 5);
        result:setCooked(corpse:isCooked());
    end
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if getActivatedMods():contains("FoodPreservationPlus") then
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
	end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
			if ZombRand(100) == 0 then
				player:getBodyDamage():getBodyPart(BodyPartType.Hand_L):SetScratchedWeapon(true);
			end
			if ZombRand(100) == 0 then
				player:getBodyDamage():getBodyPart(BodyPartType.Hand_R):SetScratchedWeapon(true);
			end
			if player:HasTrait("Hemophobic") then
				player:getStats():setStress(player:getStats():getStress() + 0.5)
			end
			if player:HasTrait("Hunter") then
				player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 20)
			end
	end
end

function SIHButcherPig_OnCreate(items, result, player)
    local corpse = nil;
    for i=0,items:size() - 1 do
        if instanceof(items:get(i), "Food") then
            corpse = items:get(i);
            break;
        end
    end
    if corpse then
        local hunger = math.max(corpse:getBaseHunger(), corpse:getHungChange())
        result:setBaseHunger(hunger / 5);
        result:setHungChange(hunger / 5);
        result:setActualWeight((corpse:getActualWeight() * 0.9) / 5)
        result:setWeight(result:getActualWeight());
        result:setCustomWeight(true)
        result:setCarbohydrates(corpse:getCarbohydrates() / 5);
        result:setLipids(corpse:getLipids() / 5);
        result:setProteins(corpse:getProteins() / 5);
        result:setCalories(corpse:getCalories() / 5);
        result:setCooked(corpse:isCooked());
    end
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	player:getInventory():AddItem("LeatherStripsDirty");
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if ZombRand(3) == 0 then
        player:getInventory():AddItem("LeatherStripsDirty");
    end
	if getActivatedMods():contains("FoodPreservationPlus") then
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		player:getInventory():AddItem("Bones");
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
		if ZombRand(5) == 0 then
        player:getInventory():AddItem("Bones");
		end
	end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
			if ZombRand(100) == 0 then
				player:getBodyDamage():getBodyPart(BodyPartType.Hand_L):SetScratchedWeapon(true);
			end
			if ZombRand(100) == 0 then
				player:getBodyDamage():getBodyPart(BodyPartType.Hand_R):SetScratchedWeapon(true);
			end
			if player:HasTrait("Hemophobic") then
				player:getStats():setStress(player:getStats():getStress() + 0.5)
			end
			if player:HasTrait("Hunter") then
				player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 20)
			end
	end
end