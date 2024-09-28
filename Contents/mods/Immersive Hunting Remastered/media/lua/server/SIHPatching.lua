function firearmsRecipesPatch()
	local recipes = getScriptManager():getAllRecipes()
	
	for i=0,recipes:size()-1 do
		local recipe = recipes:get(i)
		
		if not getActivatedMods():contains("firearmmod") then
			if recipe:getName() == "Hunt Rabbit with M1Garand Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Birds with M1Garand Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Deer with M1Garand Rifle" then
				recipe:setIsHidden(true)
			end	
			if recipe:getName() == "Hunt Pig with M1Garand Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Rabbit with M24 Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Birds with M24 Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Deer with M24 Rifle" then
				recipe:setIsHidden(true)
			end	
			if recipe:getName() == "Hunt Pig with M24 Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Rabbit with Rugerm7722 Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Birds with Rugerm7722 Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Deer with Rugerm7722 Rifle" then
				recipe:setIsHidden(true)
			end	
			if recipe:getName() == "Hunt Pig with Rugerm7722 Rifle" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Rabbit with Shotgun (B41)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Birds with Shotgun (B41)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Deer with Shotgun (B41)" then
				recipe:setIsHidden(true)
			end	
			if recipe:getName() == "Hunt Pig with Shotgun (B41)" then
				recipe:setIsHidden(true)
			end
		end
		if not getActivatedMods():contains("MandelaBowAndArrow") then
			if recipe:getName() == "Hunt Rabbit with a Bow" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Birds with a Bow" then
				recipe:setIsHidden(true)
			end
		end
		if not getActivatedMods():contains("Brita") then
			if recipe:getName() == "Hunt Rabbit with a 308 Rifle (Brita)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Birds with a 308 Rifle (Brita)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Deer with a 308 Rifle (Brita)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Pig with a 308 Rifle (Brita)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Rabbit with a Shotty (Brita)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Birds with a Shotty (Brita)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Deer with a Shotty (Brita)" then
				recipe:setIsHidden(true)
			end
			if recipe:getName() == "Hunt Pig with a Shotty (Brita)" then
				recipe:setIsHidden(true)
			end
		end	
	end
end

firearmsRecipesPatch()