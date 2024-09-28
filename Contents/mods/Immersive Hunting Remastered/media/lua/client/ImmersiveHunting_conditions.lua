--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Main file of Immersive Hunting Remastered.

]]--
--[[ ================================================ ]]--

-- requirements
local ImmersiveHunting = require "ImmersiveHunting_module"

-- localy initialize player
local client_player = getPlayer()
local function initTLOU_OnGameStart(playerIndex, player_init)
	client_player = getPlayer()
end
Events.OnCreatePlayer.Remove(initTLOU_OnGameStart)
Events.OnCreatePlayer.Add(initTLOU_OnGameStart)

ImmersiveHunting.AmmoTypes = {
	--- Bullets
	-- vanilla
	["Base.Bullets38"] 					= {AmmoType = "Bullet", Emin = 300, Emax = 450, Diameter = 9.06,},
	["Base.223Bullets"] 				= {AmmoType = "Bullet", Emin = 1670, Emax = 1890, Diameter = 5.69,},
	["Base.308Bullets"] 				= {AmmoType = "Bullet", Emin = 3617, Emax = 3617, Diameter = 7.82,},
	["Base.Bullets44"] 					= {AmmoType = "Bullet", Emin = 1000, Emax = 1800, Diameter = 10.9,},
	["Base.Bullets45"] 					= {AmmoType = "Bullet", Emin = 483, Emax = 676, Diameter = 11.43,},
	["Base.556Bullets"] 				= {AmmoType = "Bullet", Emin = 1670, Emax = 1890, Diameter = 5.56,},
	["Base.Bullets9mm"] 				= {AmmoType = "Bullet", Emin = 480, Emax = 550, Diameter = 9.01,},

	-- VFE
	["Base.762Bullets"] 				= {AmmoType = "Bullet", Emin = 2300, Emax = 2500, Diameter = 7.92,},
	["Base.22Bullets"] 					= {AmmoType = "Bullet", Emin = 140, Emax = 280, Diameter = 5.56,},
	["Base.308BulletsLinked"] 			= {AmmoType = "Bullet", Emin = 3617, Emax = 3617, Diameter = 7.82,},

	-- Brita
	["Base.Bullets45LC"] 				= {AmmoType = "Bullet", Emin = 664, Emax = 845, Diameter = 11.43,},
	["Base.Bullets357"] 				= {AmmoType = "Bullet", Emin = 780, Emax = 1090, Diameter = 9.06,},
	["Base.Bullets380"] 				= {AmmoType = "Bullet", Emin = 275, Emax = 360, Diameter = 9.01,},
	["Base.Bullets57"] 					= {AmmoType = "Bullet", Emin = 500, Emax = 600, Diameter = 5.7,},
	["Base.Bullets22"] 					= {AmmoType = "Bullet", Emin = 140, Emax = 280, Diameter = 5.56,},
	["Base.Bullets4570"] 				= {AmmoType = "Bullet", Emin = 2300, Emax = 2500, Diameter = 11.63,},
	["Base.Bullets50MAG"] 				= {AmmoType = "Bullet", Emin = 19000, Emax = 19000, Diameter = 12.98,},
	["Base.545x39Bullets"] 				= {AmmoType = "Bullet", Emin = 1390, Emax = 1390, Diameter = 5.6,},
	["Base.762x39Bullets"] 				= {AmmoType = "Bullet", Emin = 2300, Emax = 2500, Diameter = 7.92,},
	["Base.762x51Bullets"] 				= {AmmoType = "Bullet", Emin = 2000, Emax = 3850, Diameter = 7.84,},
	["Base.762x54rBullets"] 			= {AmmoType = "Bullet", Emin = 2600, Emax = 2800, Diameter = 7.92,},
	["Base.3006Bullets"] 				= {AmmoType = "Bullet", Emin = 2500, Emax = 2800, Diameter = 7.62,},
	["Base.50BMGBullets"] 				= {AmmoType = "Bullet", Emin = 19000, Emax = 19000, Diameter = 12.98,},
	["Base.40HERound"] 					= {AmmoType = "Bullet", Emin = 20000, Emax = 20000, Diameter = 40,},
	["Base.40INCRound"] 				= {AmmoType = "Bullet", Emin = 15000, Emax = 16000, Diameter = 40,},
	["Base.HERocket"] 					= {AmmoType = "Bullet", Emin = 30000, Emax = 30000, Diameter = 40,},

	-- Firearms B41
	["Base.Bullets4440"] 				= {AmmoType = "Bullet", Emin = 1016, Emax = 1016, Diameter = 10.9,},
	["Base.Bullets3006"] 				= {AmmoType = "Bullet", Emin = 2500, Emax = 2800, Diameter = 7.62,},


	--- Shotguns
	-- vanilla
	["Base.ShotgunShells"] 				= {AmmoType = "Shotgun", Emin = 2500, Emax = 3300, Diameter = 18.53,},

	-- Brita
	["Base.410gShotgunShells"] 			= {AmmoType = "Shotgun", Emin = 1000, Emax = 1780, Diameter = 10.4,},
	["Base.20gShotgunShells"] 			= {AmmoType = "Shotgun", Emin = 1700, Emax = 2400, Diameter = 15.63,},
	["Base.10gShotgunShells"] 			= {AmmoType = "Shotgun", Emin = 3000, Emax = 3960, Diameter = 19.69,},
	["Base.4gShotgunShells"] 			= {AmmoType = "Shotgun", Emin = 5000, Emax = 5500, Diameter = 26.72,},


	--- Others
	["Base.PB68"] 						= {AmmoType = "Other", NoHitTime = true, CantKill = true,},
	["Base.BB177"] 						= {AmmoType = "Other", NoHitTime = true, CantKill = true,},
	["Base.CO2_Cartridge"] 				= {AmmoType = "Other", NoHitTime = true, CantKill = true,},
	["Base.FlameFuel"] 					= {AmmoType = "Other", NoHitTime = true, CantKill = true,},
	["Base.Smoke"] 						= {AmmoType = "Other", NoHitTime = true, CantKill = true,},
	["Base.WaterAmmo"] 					= {AmmoType = "Other", NoHitTime = true, CantKill = true,},
	["Base.Flare"] 						= {AmmoType = "Other", NoHitTime = true, CantKill = true,},
	["Base.SlingShotAmmo_Rock"] 		= {AmmoType = "Other", NoHitTime = true, Emin = 0, Emax = 5, Diameter = 20,},
	["Base.SlingShotAmmo_Marble"] 		= {AmmoType = "Other", NoHitTime = true, Emin = 0, Emax = 5, Diameter = 20,},
}

ImmersiveHunting.ValidForageItems = {
    ["ImmersiveHunting.SIHTraceSmall"] = "SmallGame",
    ["ImmersiveHunting.SIHTraceBig"] = "BigGame",
    ["ImmersiveHunting.SIHSpottedBird"] = "Bird",
}

ImmersiveHunting.HuntingConditions["Bird"] = {
    distance = {min = 5, max = 15},
    huntingCaliber = {
        ["Bullet"] = {Emin = 300,Emax = 1500,Diameter = 6},
        ["Shotgun"] = {Diameter = 16,shredDiameter = 20,kill = true},
    },
    melee = {
        mightKill = {
            ["Improvised"] = 1,
            -- ["SmallBlunt"] = true,
            -- ["Blunt"] = true,
            -- ["Axe"] = true,
            -- ["SmallBlade"] = true,
            -- ["LongBlade"] = true,
            -- ["Spear"] = true,
        },
        willKill = {
			-- ["Improvised"] = true,
            ["SmallBlunt"] = 3,
            ["Blunt"] = 1,
            ["Axe"] = 1,
            ["SmallBlade"] = 8,
            ["LongBlade"] = 5,
            ["Spear"] = 10,
        },
        noMeleeTwoHanded = {
            ["Blunt"] = true,
            ["Axe"] = true,
            ["LongBlade"] = true,
        },
    },
    canBeShreded = true,
}