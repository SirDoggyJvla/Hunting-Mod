--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Adds the foraging of Immersive Hunting Remastered.

]]--
--[[ ================================================ ]]--

require "Foraging/forageSystem"
require "Foraging/forageDefinitions"

-- replace animal require skill to view it to 0
forageCategories["Animals"].identifyCategoryLevel = 0

local dev = getDebug() and false

local areas = {
	Forest			= "NatureAreas",
	DeepForest		= "NatureAreas",
	FarmLand		= "NatureAreas",
	Vegitation		= "NatureAreas",
	TrailerPark		= "HumanAreas",
	TownZone		= "HumanAreas",
	Nav				= "HumanAreas",
}

local forages = {
	-- Birds
	Tracks_Robin = {
		type="ImmersiveHunting.Tracks_Robin",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {
			Forest = 12,
			DeepForest = 16,
			FarmLand = 2,
			Vegitation = 4,
			TrailerPark = 2,
			TownZone = 2,
			Nav = 2,
		},

		option = "Birds",
	},

	-- Tiny game
	Tracks_Rat = {
		type="ImmersiveHunting.Tracks_Rat",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {
			Forest = 4,
			DeepForest = 4,
			FarmLand = 12,
			Farm = 12,
			Vegitation = 4,
			TrailerPark = 12,
			TownZone = 8,
			Nav = 2,
		},

		option = "TinyGame",
	},
	Tracks_Mouse = {
		type="ImmersiveHunting.Tracks_Mouse",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {
			Forest = 4,
			DeepForest = 4,
			FarmLand = 12,
			Farm = 12,
			Vegitation = 4,
			TrailerPark = 12,
			TownZone = 8,
			Nav = 2,
		},

		option = "TinyGame",
	},
	Tracks_Squirrel = {
		type="ImmersiveHunting.Tracks_Squirrel",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {
			Forest = 8,
			DeepForest = 12,
			FarmLand = 2,
			Vegitation = 4,
		},

		option = "TinyGame",
	},

	-- Small game
	Tracks_Rabbit = {
		type="ImmersiveHunting.Tracks_Rabbit",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {
			Forest = 8,
			DeepForest = 12,
			FarmLand = 8,
			Farm = 8,
			Vegitation = 2,
		},

		option = "SmallGame",
	},

	-- Big game
	Tracks_Pig = {
		type="ImmersiveHunting.Tracks_Pig",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {
			Forest = 4,
			DeepForest = 8,
			FarmLand = 2,
			Farm = 2,
			Vegitation = 2,
		},

		option = "BigGame",
	},
	Tracks_Deer = {
		type="ImmersiveHunting.Tracks_Deer",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {
			Forest = 4,
			DeepForest = 8,
			FarmLand = 2,
			Farm = 2,
			Vegitation = 2,
		},

		option = "BigGame",
	},
}

Events.onAddForageDefs.Add(function()
	-- increase the chances for big games to be seen in human areas, and make them appear in city areas
	if SandboxVars.ImmersiveHunting.YearsLater then
		-- robin
		local zones = forages.Tracks_Robin.zones
		zones.Vegitation = 4
		zones.TrailerPark = 4
		zones.TownZone = 4
		zones.Nav = 4

		-- squirrel
		local zones = forages.Tracks_Squirrel.zones
		zones.Vegitation = 4
		zones.TrailerPark = 4
		zones.TownZone = 4
		zones.Nav = 4

		-- rabbit
		local zones = forages.Tracks_Rabbit.zones
		zones.Vegitation = 4
		zones.TrailerPark = 4
		zones.TownZone = 4
		zones.Nav = 4

		-- pig
		local zones = forages.Tracks_Pig.zones
		zones.FarmLand = 4
		zones.Vegitation = 4
		zones.TrailerPark = 4
		zones.TownZone = 4
		zones.Nav = 4

		-- deer
		local zones = forages.Tracks_Deer.zones
		zones.FarmLand = 4
		zones.Vegitation = 4
		zones.TrailerPark = 4
		zones.TownZone = 4
		zones.Nav = 4
	end

	-- increase the chances to a very high level if dev mode
	if dev then
		for _,forage in pairs(forages) do
			for _,value in pairs(forage.zones) do
				value = 1000
			end
		end

	-- not in dev mode, apply the sandbox options
	else
		for _,forage in pairs(forages) do
			local option = forage.option
			local animal_boost = option and SandboxVars.ImmersiveHunting[option.."Forage"]/100 or 1
			for zone,value in pairs(forage.zones) do
				local area = areas[zone]
				local area_boost = area and SandboxVars.ImmersiveHunting[area.."Forage"]/100 or 1

				value = value * animal_boost * area_boost
			end
		end
	end

	-- add the items to spawn as foraging
	for _,forage in pairs(forages) do
		forage.option = nil
		forageSystem.addItemDef(forage)
	end

end)
