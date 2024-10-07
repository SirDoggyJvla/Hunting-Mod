--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Main file of Immersive Hunting Remastered. Needs to be loaded for addons.

]]--
--[[ ================================================ ]]--

-- requirements
local ImmersiveHunting = require "ImmersiveHunting_module"

ImmersiveHunting.AmmoTypes = {
--- Vanilla
	["Base.Bullets38"              ]	=	{ AmmoType = "Bullet" ,	Emin =   300,	Emax =   450,	Diameter =  9.06,	CanKill = true, },
	["Base.223Bullets"             ]	=	{ AmmoType = "Bullet" ,	Emin =  1670,	Emax =  1890,	Diameter =  5.69,	CanKill = true, },
	["Base.308Bullets"             ]	=	{ AmmoType = "Bullet" ,	Emin =  2500,	Emax =  3800,	Diameter =  7.82,	CanKill = true, },
	["Base.Bullets44"              ]	=	{ AmmoType = "Bullet" ,	Emin =  1000,	Emax =  1800,	Diameter =  10.9,	CanKill = true, },
	["Base.Bullets45"              ]	=	{ AmmoType = "Bullet" ,	Emin =   483,	Emax =   676,	Diameter = 11.43,	CanKill = true, },
	["Base.556Bullets"             ]	=	{ AmmoType = "Bullet" ,	Emin =  1670,	Emax =  1890,	Diameter =  5.56,	CanKill = true, },
	["Base.Bullets9mm"             ]	=	{ AmmoType = "Bullet" ,	Emin =   480,	Emax =   550,	Diameter =  9.01,	CanKill = true, },
	["Base.ShotgunShells"          ]	=	{ AmmoType = "Shotgun",	Emin =  2500,	Emax =  3300,	Diameter = 18.53,	CanKill = true, },

--- VFE
	["Base.762Bullets"             ]	=	{ AmmoType = "Bullet" ,	Emin =  2300,	Emax =  2500,	Diameter =  7.92,	CanKill = true, },
	["Base.22Bullets"              ]	=	{ AmmoType = "Bullet" ,	Emin =   140,	Emax =   280,	Diameter =  5.56,	CanKill = true, },
	["Base.308BulletsLinked"       ]	=	{ AmmoType = "Bullet" ,	Emin =  2500,	Emax =  3800,	Diameter =  7.82,	CanKill = true, },

--- Brita
	["Base.Bullets45LC"            ]	=	{ AmmoType = "Bullet" ,	Emin =   663,	Emax =   844,	Diameter = 11.43,	CanKill = true, },
	["Base.Bullets357"             ]	=	{ AmmoType = "Bullet" ,	Emin =   780,	Emax =  1090,	Diameter =  9.06,	CanKill = true, },
	["Base.Bullets380"             ]	=	{ AmmoType = "Bullet" ,	Emin =   275,	Emax =   360,	Diameter =  9.01,	CanKill = true, },
	["Base.Bullets57"              ]	=	{ AmmoType = "Bullet" ,	Emin =   500,	Emax =   600,	Diameter =   5.7,	CanKill = true, },
	["Base.Bullets22"              ]	=	{ AmmoType = "Bullet" ,	Emin =   140,	Emax =   280,	Diameter =  5.56,	CanKill = true, },
	["Base.Bullets4570"            ]	=	{ AmmoType = "Bullet" ,	Emin =  2300,	Emax =  2500,	Diameter = 11.63,	CanKill = true, },
	["Base.Bullets50MAG"           ]	=	{ AmmoType = "Bullet" ,	Emin = 19000,	Emax = 19000,	Diameter = 12.98,	CanKill = true, },
	["Base.545x39Bullets"          ]	=	{ AmmoType = "Bullet" ,	Emin =  1390,	Emax =  1890,	Diameter =   5.6,	CanKill = true, },
	["Base.762x39Bullets"          ]	=	{ AmmoType = "Bullet" ,	Emin =  2300,	Emax =  2500,	Diameter =  7.92,	CanKill = true, },
	["Base.762x51Bullets"          ]	=	{ AmmoType = "Bullet" ,	Emin =  2000,	Emax =  3850,	Diameter =  7.84,	CanKill = true, },
	["Base.762x54rBullets"         ]	=	{ AmmoType = "Bullet" ,	Emin =  2600,	Emax =  2800,	Diameter =  7.92,	CanKill = true, },
	["Base.3006Bullets"            ]	=	{ AmmoType = "Bullet" ,	Emin =  2500,	Emax =  2800,	Diameter =  7.62,	CanKill = true, },
	["Base.50BMGBullets"           ]	=	{ AmmoType = "Bullet" ,	Emin = 19000,	Emax = 19000,	Diameter = 12.98,	CanKill = true, },
	["Base.40HERound"              ]	=	{ AmmoType = "Bullet" ,	Emin = 20000,	Emax = 20000,	Diameter =    40,	CanKill = true, },
	["Base.40INCRound"             ]	=	{ AmmoType = "Bullet" ,	Emin = 15000,	Emax = 16000,	Diameter =    40,	CanKill = true, },
	["Base.HERocket"               ]	=	{ AmmoType = "Bullet" ,	Emin = 30000,	Emax = 30000,	Diameter =    40,	CanKill = true, },
	["Base.410gShotgunShells"      ]	=	{ AmmoType = "Shotgun",	Emin =  1000,	Emax =  1780,	Diameter =  10.4,	CanKill = true, },
	["Base.20gShotgunShells"       ]	=	{ AmmoType = "Shotgun",	Emin =  1700,	Emax =  2400,	Diameter = 15.63,	CanKill = true, },
	["Base.10gShotgunShells"       ]	=	{ AmmoType = "Shotgun",	Emin =  3000,	Emax =  3960,	Diameter = 19.69,	CanKill = true, },
	["Base.4gShotgunShells"        ]	=	{ AmmoType = "Shotgun",	Emin =  5000,	Emax =  5500,	Diameter = 26.72,	CanKill = true, },
	["Base.PB68"                   ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     0,	Diameter =     0,	CanKill = false, },
	["Base.BB177"                  ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     0,	Diameter =     0,	CanKill = false, },
	["Base.CO2_Cartridge"          ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     0,	Diameter =     0,	CanKill = false, },
	["Base.FlameFuel"              ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     0,	Diameter =     0,	CanKill = false, },
	["Base.Smoke"                  ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     0,	Diameter =     0,	CanKill = false, },
	["Base.WaterAmmo"              ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     0,	Diameter =     0,	CanKill = false, },
	["Base.Flare"                  ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     0,	Diameter =     0,	CanKill = false, },
	["Base.SlingShotAmmo_Rock"     ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     5,	Diameter =    20,	CanKill = true, },
	["Base.SlingShotAmmo_Marble"   ]	=	{ AmmoType = "Other"  ,	Emin =     0,	Emax =     5,	Diameter =    20,	CanKill = true, },

--- Firearms B41
	["Base.Bullets4440"            ]	=	{ AmmoType = "Bullet" ,	Emin =  1016,	Emax =  1016,	Diameter =  10.9,	CanKill = true, },
	["Base.Bullets3006"            ]	=	{ AmmoType = "Bullet" ,	Emin =  2500,	Emax =  2800,	Diameter =  7.62,	CanKill = true, },

--- Guns93
	["Base.Slugs"                  ]	=	{ AmmoType = "Shotgun",	Emin =  3000,	Emax =  4000,	Diameter = 18.53,	CanKill = true, },
	["Base.76239Bullets"           ]	=	{ AmmoType = "Bullet" ,	Emin =  2300,	Emax =  2500,	Diameter =  7.92,	CanKill = true, },
	["Base.792Bullets"             ]	=	{ AmmoType = "Bullet" ,	Emin =  3800,	Emax =  4000,	Diameter =  8.22,	CanKill = true, },
	["Base.10mmBullets"            ]	=	{ AmmoType = "Bullet" ,	Emin =   680,	Emax =   960,	Diameter = 10.17,	CanKill = true, },
	["Base.40Bullets"              ]	=	{ AmmoType = "Bullet" ,	Emin =   600,	Emax =   800,	Diameter =  10.2,	CanKill = true, },
	["Base.25Bullets"              ]	=	{ AmmoType = "Bullet" ,	Emin =    90,	Emax =   200,	Diameter =  6.38,	CanKill = true, },
	["Base.380Bullets"             ]	=	{ AmmoType = "Bullet" ,	Emin =   275,	Emax =   360,	Diameter =  9.01,	CanKill = true, },
	["Base.357Bullets"             ]	=	{ AmmoType = "Bullet" ,	Emin =   780,	Emax =  1090,	Diameter =  9.06,	CanKill = true, },
	["Base.45LCBullets"            ]	=	{ AmmoType = "Bullet" ,	Emin =   663,	Emax =   844,	Diameter = 11.43,	CanKill = true, },
	["Base.30CarBullets"           ]	=	{ AmmoType = "Bullet" ,	Emin =  1000,	Emax =  1400,	Diameter =  7.82,	CanKill = true, },
	["Base.3030Bullets"            ]	=	{ AmmoType = "Bullet" ,	Emin =  2450,	Emax =  2800,	Diameter =  7.62,	CanKill = true, },
	["Base.556Belt"                ]	=	{ AmmoType = "Bullet" ,	Emin =  1670,	Emax =  1890,	Diameter =  5.56,	CanKill = true, },
	["Base.308Belt"                ]	=	{ AmmoType = "Bullet" ,	Emin =  2500,	Emax =  3800,	Diameter =  7.82,	CanKill = true, },

--- Pallontras Weapons
	["Base.WoodBolt"               ]	=	{ AmmoType = "Other"  ,	Emin =   150,	Emax =   350,	Diameter =  7,62,	CanKill = true, },
	["Base.ShortWoodBolt"          ]	=	{ AmmoType = "Other"  ,	Emin =   100,	Emax =   300,	Diameter =  7,62,	CanKill = true, },
	["Base.ShortIronBolt"          ]	=	{ AmmoType = "Other"  ,	Emin =   150,	Emax =   350,	Diameter =  7,62,	CanKill = true, },
	["Base.IronBolt"               ]	=	{ AmmoType = "Other"  ,	Emin =   200,	Emax =   400,	Diameter =  7,62,	CanKill = true, },

--- Kitsune's Crossbow
	["KCMweapons.CrossbowBolt"     ]	=	{ AmmoType = "Other"  ,	Emin =   150,	Emax =   350,	Diameter =  7,62,	CanKill = true, },
	["KCMweapons.CrossbowBoltLarge"]	=	{ AmmoType = "Other"  ,	Emin =   200,	Emax =   400,	Diameter =  7,62,	CanKill = true, },
	["KCMweapons.WoodenBolt"       ]	=	{ AmmoType = "Other"  ,	Emin =   150,	Emax =   350,	Diameter =  7,62,	CanKill = true, },
}
