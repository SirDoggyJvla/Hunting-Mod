-----------------------------------------------------------------------------------
----------------------------------- TRACE TRACKS STUFF ----------------------------
-----------------------------------------------------------------------------------

function SIHTrackSpawnSmall_OnCreate(items, result, player)
	
	
	local weather 			= getClimateManager();
	local rain 				= weather:getRainIntensity();
	local snow 				= weather:getSnowIntensity();
	local wind 				= weather:getWindIntensity();
	local fog 				= weather:getFogIntensity();
	local PlantScavenging 	= player:getPerkLevel(Perks.PlantScavenging);
	local Sneaking 			= player:getPerkLevel(Perks.Sneak);
	local badWeather 		= 0;
	local Outdoorsman 		= 0;
	local Scout 			= 0;
	local Hunter 			= 0;
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 4;
	end
	if player:HasTrait("Hunter") then
		Hunter = 6;
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-5);
	end
	local SumOfTraits 		= Outdoorsman+Scout+Hunter;
	local TotalSkill 		= PlantScavenging+Sneaking;	
	local RandomAddon 		= ZombRand(30);
	local SIHRollMain 		= TotalSkill + SumOfTraits + badWeather + RandomAddon;
	local SIHRollActual 	= ZombRand(1,6);
	if SIHRollMain > 30 then
		if SIHRollActual == 3 then
			local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHTrackRabbit")
			getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0)
		else
			local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHTrackBird")
			getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0)
		end
	else
		local trackerSay = ZombRand(1,15);
		if trackerSay == 2 then
			getPlayer():Say("Seems to be nothing here...");
		elseif trackerSay == 4 then
			getPlayer():Say("These tracks lead nowhere.");
		elseif trackerSay == 6 then
			getPlayer():Say("Nothing.");
		elseif trackerSay == 8 then
			getPlayer():Say("Seems no game today.");
		elseif trackerSay == 10 then
			getPlayer():Say("Dang it, nothing!");
		elseif trackerSay == 12 then
			getPlayer():Say("I lost the track.");
		else
			getPlayer():Say("Arghhh, lost it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Body and Weather: " .. badWeather);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. SIHRollMain);
	
end

function SIHTrackSpawnBig_OnCreate(items, result, player)


	local weather 			= getClimateManager();
	local rain 				= weather:getRainIntensity();
	local snow 				= weather:getSnowIntensity();
	local wind 				= weather:getWindIntensity();
	local fog 				= weather:getFogIntensity();
	local PlantScavenging 	= player:getPerkLevel(Perks.PlantScavenging);
	local Sneaking 			= player:getPerkLevel(Perks.Sneak);
	local badWeather 		= 0;
	local Outdoorsman 		= 0;
	local Scout 			= 0;
	local Hunter 			= 0;
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 4;
	end
	if player:HasTrait("Hunter") then
		Hunter = 6;
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-5);
	end
	local SumOfTraits 		= Outdoorsman+Scout+Hunter;
	local TotalSkill 		= PlantScavenging+Sneaking;	
	local RandomAddon 		= ZombRand(40);
	local SIHRollMain 		= TotalSkill + SumOfTraits + badWeather + RandomAddon;
	local SIHRollActual 	= ZombRand(1,6);
	if SIHRollMain > 35 then
		if SIHRollActual == 3 then
			local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHTrackDeer")
			getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0)
		else
			local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHTrackPig")
			getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0)
		end
	else
		local trackerSay = ZombRand(1,15);
		if trackerSay == 2 then
			getPlayer():Say("Seems to be nothing here...");
		elseif trackerSay == 4 then
			getPlayer():Say("These tracks lead nowhere.");
		elseif trackerSay == 6 then
			getPlayer():Say("Nothing.");
		elseif trackerSay == 8 then
			getPlayer():Say("Seems no game today.");
		elseif trackerSay == 10 then
			getPlayer():Say("Dang it, nothing!");
		elseif trackerSay == 12 then
			getPlayer():Say("I lost the track.");
		else
			getPlayer():Say("Arghhh, lost it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Body and Weather: " .. badWeather);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. SIHRollMain);
	
end

-----------------------------------------------------------------------------------
----------------------------------- GUN STUFF -------------------------------------
-----------------------------------------------------------------------------------

function SIHSpawnRabbit_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
		
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 45 then
		local item = InventoryItemFactory.CreateItem("Base.DeadRabbit");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnBird_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,4.5);
	if HuntChance >= 50 then
		local item = InventoryItemFactory.CreateItem("Base.DeadBird");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnPig_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 35 then
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHPigCorpse");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnDeer_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 35 then
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHDeerCorpse");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

-----------------------------------------------------------------------------------
----------------------------------- GUN STUFF - Shotty ----------------------------
-----------------------------------------------------------------------------------

function SIHSpawnRabbitShotty_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
		
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 50 then
		local item = InventoryItemFactory.CreateItem("Base.DeadRabbit");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnBirdShotty_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,4.5);
	if HuntChance >= 45 then
		local item = InventoryItemFactory.CreateItem("Base.DeadBird");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnPigShotty_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 40 then
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHPigCorpse");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnDeerShotty_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	local Scoped 		= 0;	
	local weapon 		= getPlayer():getPrimaryHandItem()
	
	if weapon and weapon:getScope() then
	local scope = weapon:getScope():getType()
		Scoped = 5;
	end
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming) * 2;
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody+Scoped;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 40 then
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHDeerCorpse");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Is Scoped: " .. Scoped);
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

-----------------------------------------------------------------------------------
----------------------------------- SPEAR STUFF -----------------------------------
-----------------------------------------------------------------------------------

function SIHSpawnPigSpear_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(6);
	for i=0,items:size() - 1 do
        if weaponDMG == 3 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 10);
        end
    end
	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Spear) * 2;
	local Strength 		= player:getPerkLevel(Perks.Strength);
	local Fitness 		= player:getPerkLevel(Perks.Fitness);
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Strength+Fitness+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 60 then
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHPigCorpse");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("Make room, make room, wildman coming through!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnDeerSpear_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(6);
	for i=0,items:size() - 1 do
        if weaponDMG == 3 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 10);
        end
    end
	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Spear) * 2;
	local Strength 		= player:getPerkLevel(Perks.Strength);
	local Fitness 		= player:getPerkLevel(Perks.Fitness);
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Strength+Fitness+Sneaking;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 60 then
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHDeerCorpse");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("Make room, make room, wildman coming through!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

-----------------------------------------------------------------------------------
----------------------------------- BOW STUFF -----------------------------------
-----------------------------------------------------------------------------------

function SIHSpawnRabbitBow_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
		
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming);
	local Archery 		= player:getPerkLevel(Perks.Archery);
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking+Archery;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody;
	
	local RandomNut 	= ZombRandFloat(0.8,1.5);
	if HuntChance >= 45 then
		local item = InventoryItemFactory.CreateItem("Base.DeadRabbit");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end

function SIHSpawnBirdBow_OnCreate(items, result, player, selectedItem)
	local weaponDMG = ZombRand(40);
	for i=0,items:size() - 1 do
        if weaponDMG == 20 and instanceof (items:get(i), "HandWeapon") then
            items:get(i):setCondition(items:get(i):getCondition() - 0.01);
        end
    end
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100);
	end

	local weather 		= getClimateManager();
	local rain 			= weather:getRainIntensity();
	local snow 			= weather:getSnowIntensity();
	local wind 			= weather:getWindIntensity();
	local fog 			= weather:getFogIntensity();
	local badWeather 	= 0;		
	local EagleEye 		= 0;
	local Outdoorsman 	= 0;
	local Desensitized 	= 0;
	local Scout 		= 0;
	local Hunter 		= 0;
	local ShortSighted 	= 0;
	local Clumsy 		= 0;
	local hasCold 		= 0;
	local hasCold2 		= 0;
	if player:HasTrait("EagleEyed") then
		EagleEye = 4;
	end
	if player:HasTrait("Outdoorsman") then
		Outdoorsman = 2;
	end
	if player:HasTrait("Desensitized") then
		Desensitized = 2;
	end
	if player:HasTrait("Formerscout") then
		Scout = 2;
	end
	if player:HasTrait("Hunter") then
		Hunter = 4;
	end
	if player:HasTrait("ShortSighted") then
		ShortSighted = (-4);
	end
	if player:HasTrait("Clumsy") then
		Clumsy = (-2);
	end
	if rain > 0.3 or snow > 0.3 or wind > 0.4 or fog > 0.4 then
		badWeather = (-10);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.HasACold) > 0 then
		hasCold = (-5);
	end
	if player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 0 then
		hasCold2 = (-5);
	end
	
	local YourBody 		= badWeather+hasCold+hasCold2;
	local SumOfTraits 	= EagleEye+Outdoorsman+Desensitized+Scout+Hunter+ShortSighted+Clumsy;
	local Aiming 		= player:getPerkLevel(Perks.Aiming);
	local Archery 		= player:getPerkLevel(Perks.Archery);
	local Sneaking 		= player:getPerkLevel(Perks.Sneak);
	local TotalSkill 	= Aiming+Sneaking+Archery;
	local RandomAddon 	= ZombRand(40);
	local HuntChance 	= RandomAddon+TotalSkill+SumOfTraits+YourBody;
	
	local RandomNut 	= ZombRandFloat(0.8,4.5);
	if HuntChance >= 50 then
		local item = InventoryItemFactory.CreateItem("Base.DeadBird");
		item:setCalories(item:getCalories() * RandomNut);
		item:setLipids(item:getLipids() * RandomNut);
		item:setCarbohydrates(item:getCarbohydrates() * RandomNut);
		item:setProteins(item:getProteins() * RandomNut);
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		local hunterSay = ZombRand(1,15);
		if hunterSay == 2 then
			getPlayer():Say("BANG, right in the kisser!");
		elseif hunterSay == 4 then
			getPlayer():Say("YEEEE-HAAAAA!!!");
		elseif hunterSay == 6 then
			getPlayer():Say("STRIKEEEE, You're out!!!");
		elseif hunterSay == 8 then
			getPlayer():Say("BULLSEYE!");
		elseif hunterSay == 10 then
			getPlayer():Say("Ding Ding Ding DINNER IS READY!");
		elseif hunterSay == 12 then
			getPlayer():Say("Hot damn!");
		else
			getPlayer():Say("Got it!");
		end
	end
	
	for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if player:HasTrait("Hemophobic") then
			player:getStats():setStress(player:getStats():getStress() + 0.5)
		end
		if player:HasTrait("Hunter") then
			player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 40)
		end
	end
	
	print("Body and Weather: " .. YourBody);
	print("Traits: " .. SumOfTraits);
	print("Skills: " .. TotalSkill);
	print("Random Addon: " .. RandomAddon);
	print("TOTAL SUM: " .. HuntChance);
	
end
