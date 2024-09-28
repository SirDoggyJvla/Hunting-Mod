require "Foraging/forageSystem"

Events.onAddForageDefs.Add(function()
	local SIHTraceSmall = {
		type="ImmersiveHunting.SIHTraceSmall",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		xp=10,
		skill=2,
		categories = { "Animals" },
		zones={ Forest=4, DeepForest=8, FarmLand=2, Farm=2, Vegitation=2 },
		bonusMonths = { 6, 7, 8 },
	}

	local SIHTraceBig = {
		type="ImmersiveHunting.SIHTraceBig",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=1,
		xp=20,
		skill=4,
		categories = { "Animals" },
		zones={ Forest=4, DeepForest=8, FarmLand=2, Farm=2, Vegitation=2 },
		bonusMonths = { 6, 7, 8 },
	}

	local SIHSpottedBird = {
		type="ImmersiveHunting.SIHSpottedBird",
		snowChance = -20,
		rainChance = -20,
		minCount=1,
		maxCount=2,
		xp=10,
		skill=0,
		categories = { "Animals" },
		zones={ Forest=12, DeepForest=24, FarmLand=6, Farm=6, Vegitation=6, TrailerPark=6, TownZone=6, Nav=6 },
		bonusMonths = { 6, 7, 8 },
	}

	if SandboxVars.ImmersiveHunting.YearsLater then
		SIHTraceSmall.zones = { Forest=4, DeepForest=8, FarmLand=4, Farm=4, Vegitation=4 }
		SIHTraceBig.zones = { Forest=4, DeepForest=8, FarmLand=4, Farm=4, Vegitation=4 }
		SIHSpottedBird.zones = { Forest=12, DeepForest=24, FarmLand=12, Farm=12, Vegitation=12, TrailerPark=12, TownZone=12, Nav=12 }
	end

	forageSystem.addItemDef(SIHTraceSmall)
	forageSystem.addItemDef(SIHTraceBig)
	forageSystem.addItemDef(SIHSpottedBird)

end)
