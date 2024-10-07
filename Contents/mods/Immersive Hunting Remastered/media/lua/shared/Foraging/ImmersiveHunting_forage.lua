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

local dev = getDebug() and false

local options = {
	"NatureAreas",
	"HumanAreas",
	"Birds",
	"SmallGame",
	"BigGame",
}

local areas = {
	Forest			= {		baseChance = 4, 	option = "NatureAreas"	},
	DeepForest		= {		baseChance = 8, 	option = "NatureAreas"	},
	FarmLand		= {		baseChance = 2, 	option = "NatureAreas"	},
	Vegitation		= {		baseChance = 2, 	option = "NatureAreas"	},

	TrailerPark		= { 	baseChance = 2, 	option = "HumanAreas"	},
	TownZone		= { 	baseChance = 2, 	option = "HumanAreas"	},
	Nav				= { 	baseChance = 2, 	option = "HumanAreas"	},
}

local zones = {
	["ImmersiveHunting.ImmersiveHuntingTraceSmall"] = {
		"Forest",
		"DeepForest",
		"FarmLand",
		"Vegitation",
	},
	["ImmersiveHunting.ImmersiveHuntingTraceBig"] = {
		"Forest",
		"DeepForest",
		"FarmLand",
		"Vegitation",
	},
	["ImmersiveHunting.ImmersiveHuntingSpottedBird"] = {
		"Forest",
		"DeepForest",
		"FarmLand",
		"Vegitation",
		"TrailerPark",
		"TownZone",
		"Nav",
	},
}

local forage = {
	{
		type="ImmersiveHunting.ImmersiveHuntingTraceSmall",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		xp=10,
		skill=2,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {},

		option = "SmallGame",
	},
	{
		type="ImmersiveHunting.ImmersiveHuntingTraceBig",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		xp=20,
		skill=4,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {},

		option = "BigGame",
	},
	{
		type="ImmersiveHunting.ImmersiveHuntingSpottedBird",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		xp=10,
		skill=0,
		categories = { "Animals" },
		bonusMonths = { 6, 7, 8 },
		zones = {},

		option = "Birds",
	},
}

Events.onAddForageDefs.Add(function()
	local option
	for i = 1,#options do
		option = options[i]
		options[option] = SandboxVars.ImmersiveHunting[option.."Forage"]/100
	end

	if SandboxVars.ImmersiveHunting.YearsLater then
		zones["ImmersiveHunting.ImmersiveHuntingTraceSmall"] = {
			"Forest",
			"DeepForest",
			"FarmLand",
			"Vegitation",
			"TrailerPark",
			"TownZone",
			"Nav",
		}
		zones["ImmersiveHunting.ImmersiveHuntingTraceBig"] = {
			"Forest",
			"DeepForest",
			"FarmLand",
			"Vegitation",
			"TrailerPark",
			"TownZone",
			"Nav",
		}
	end

	-- increase the chances to a very high level if dev mode
	if dev then
		for _,v in pairs(areas) do
			v.baseChance = 1000
		end
	end

	-- setup zone chances
	local forage_item
	local forage_item_type
	local zones_type
	local animal_boost
	local zones_type_data
	local areas_zone
	local baseChance
	local zone_boost

	for i = 1,#forage do
		-- retrieve item to add
		forage_item = forage[i]
		forage_item_type = forage_item.type

		-- retrieve its zones
		zones_type = zones[forage_item_type]

		-- get animal option boost
		animal_boost = options[forage_item.option]

		-- go through every zones for this animal
		for j = 1,#zones_type do
			-- zone item
			zones_type_data = zones_type[j]

			-- get data of this zone
			areas_zone = areas[zones_type_data]
			baseChance = areas_zone.baseChance

			zone_boost = options[areas_zone.option]

			forage_item.zones[zones_type_data] = baseChance * zone_boost * animal_boost
		end

		forageSystem.addItemDef(forage_item)
	end
end)
