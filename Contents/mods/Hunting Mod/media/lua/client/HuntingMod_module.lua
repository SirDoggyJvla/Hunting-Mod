--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Module of Hunting Mod.

]]--
--[[ ================================================ ]]--

HuntingMod = {
    highlightsSquares = {},
    ForageAnimalTracks = {
        -- Birds
        ["HuntingMod.Tracks_Robin"] = {
            huntTarget = "Bird",
            name = "IGUI_HuntingMod_Robin",
            sprite = "Item_Bird",
            dead = "Base.DeadBird",
        },

        -- Tiny game
        ["HuntingMod.Tracks_Rat"] = {
            huntTarget = "TinyGame",
            name = "IGUI_HuntingMod_Rat",
            sprite = "Item_Rat",
            dead = "Base.DeadRat",
        },
        ["HuntingMod.Tracks_Mouse"] = {
            huntTarget = "TinyGame",
            name = "IGUI_HuntingMod_Mouse",
            sprite = "Item_Mouse",
            dead = "Base.DeadMouse",
        },
        ["HuntingMod.Tracks_Squirrel"] = {
            huntTarget = "TinyGame",
            name = "IGUI_HuntingMod_Squirrel",
            sprite = "Item_Squirrel",
            dead = "Base.DeadSquirrel",
        },

        -- Small game
        ["HuntingMod.Tracks_Rabbit"] = {
            huntTarget = "SmallGame",
            name = "IGUI_HuntingMod_Rabbit",
            sprite = "Item_Rabbit",
            dead = "Base.DeadRabbit",
        },

        -- Big game
        ["HuntingMod.Tracks_Pig"] = {
            huntTarget = "BigGame",
            name = "IGUI_HuntingMod_Pig",
            dead = "HuntingMod.PigCorpse",
            meat = "PorkChop",
            fat = "Lard",
        },
        ["HuntingMod.Tracks_Deer"] = {
            huntTarget = "BigGame",
            name = "IGUI_HuntingMod_Deer",
            dead = "HuntingMod.DeerCorpse",
            meat = "Steak",
            fat = "Lard",
        },
    },
    AnimalBodies = {},
    AnimalTypes = {
        ["Bird"] = {
            {name = "IGUI_HuntingMod_Bird", sprite = "Item_Bird", dead = "Base.DeadBird"},
        },
        ["SmallGame"] = {
            {name = "IGUI_HuntingMod_Rabbit", sprite = "Item_Rabbit", dead = "Base.DeadRabbit"},
            {name = "IGUI_HuntingMod_Rat", sprite = "Item_Rat", dead = "Base.DeadRat"},
            {name = "IGUI_HuntingMod_Mouse", sprite = "Item_Mouse", dead = "Base.DeadMouse"},
            {name = "IGUI_HuntingMod_Squirrel", sprite = "Item_Squirrel", dead = "Base.DeadSquirrel"},
        },
        ["BigGame"] = {
            {name = "IGUI_HuntingMod_Pig",dead = "HuntingMod.HuntingModPigCorpse",meat = "Steak"},
            {name = "IGUI_HuntingMod_Deer",dead = "HuntingMod.HuntingModDeerCorpse",meat = "Steak"},
        },
    },
    HuntingConditions = {
        ["TinyGame"] = {
            huntingCaliber = {
                ["Bullet"] = {
                    Emin = 160,
                    Emax = 1500,
                    Diameter = 6,
                    impact = 5,
                },
                ["Shotgun"] = {
                    Diameter = 10,
                    shredDiameter = 20,
                    kill = true,
                    impact = 10,
                },
                ["Projectile"] = {
                    Emin = 50,
                    Emax = 800,
                    Diameter = 25,
                    impact = 10,
                },
                ["Other"] = {
                    impact = 5,
                },
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
                    -- ["Improvised"] = 3,
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
            canBeShrededDiameter = true,
            canBeShrededEnergy = true,
        },
        ["Bird"] = {
            huntingCaliber = {
                ["Bullet"] = {
                    Emin = 160,
                    Emax = 1500,
                    Diameter = 6,
                    impact = 5,
                },
                ["Shotgun"] = {
                    Diameter = 10,
                    shredDiameter = 20,
                    kill = true,
                    impact = 10,
                },
                ["Projectile"] = {
                    Emin = 50,
                    Emax = 800,
                    Diameter = 25,
                    impact = 10,
                },
                ["Other"] = {
                    impact = 5,
                },
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
                    -- ["Improvised"] = 3,
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
            canBeShrededDiameter = true,
            canBeShrededEnergy = true,
        },
        ["SmallGame"] = {
            huntingCaliber = {
                ["Bullet"] = {
                    Emin = 200,
                    Emax = 4500,
                    Diameter = 11.5,
                    impact = 9,
                },
                ["Shotgun"] = {
                    Diameter = 16,
                    shredDiameter = 20,
                    kill = true,
                    impact = 8,
                },
                ["Projectile"] = {
                    Emin = 200,
                    Emax = 1600,
                    Diameter = 25,
                    impact = 10,
                },
                ["Other"] = {
                    impact = 5,
                },
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
                    -- ["Improvised"] = 3,
                    ["SmallBlunt"] = 3,
                    ["Blunt"] = 2,
                    ["Axe"] = 2,
                    ["SmallBlade"] = 7,
                    ["LongBlade"] = 4,
                    ["Spear"] = 10,
                },
                noMeleeTwoHanded = {
                    ["Blunt"] = true,
                    ["Axe"] = true,
                    -- ["LongBlade"] = true,
                },
            },
            canBeShrededDiameter = true,
            canBeShrededEnergy = true,
        },
        ["BigGame"] = {
            huntingCaliber = {
                ["Bullet"] = {
                    Emin = 400,
                    Emax = 4500,
                    Diameter = 16,
                    impact = 10,
                },
                ["Shotgun"] = {
                    Diameter = 16,
                    shredDiameter = 30,
                    kill = true,
                    impact = 6,
                },
                ["Projectile"] = {
                    Emin = 300,
                    Emax = 2000,
                    Diameter = 25,
                    impact = 8,
                },
                ["Other"] = {
                    impact = 5,
                },
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
                    -- ["Improvised"] = 3,
                    ["SmallBlunt"] = 1,
                    ["Blunt"] = 1,
                    ["Axe"] = 6,
                    ["SmallBlade"] = 1,
                    ["LongBlade"] = 6,
                    ["Spear"] = 7,
                },
                noMeleeTwoHanded = {
                    ["Blunt"] = true,
                    -- ["Axe"] = true,
                    -- ["LongBlade"] = true,
                },
            },
            canBeShrededDiameter = true,
            canBeShrededEnergy = false,
        },
    },

    -- traits impact
    TraitsToName = {
        ["EagleEyed"] = getText("UI_trait_eagleeyed"),
        ["Outdoorsman"] = getText("UI_trait_outdoorsman"),
        ["Desensitized"] = getText("UI_trait_Desensitized"),
        ["Formerscout"] = getText("UI_trait_Scout"),
        ["Hunter"] = getText("UI_trait_Hunter"),
        ["ShortSighted"] = getText("UI_trait_shortsigh"),
        ["Clumsy"] = getText("UI_trait_clumsy"),
    },
    TraitsToCheck = {
        ["EagleEyed"] = 0.2,
        ["Outdoorsman"] = 0.1,
        ["Desensitized"] = 0.1,
        ["Formerscout"] = 0.1,
        ["Hunter"] = 0.2,
        ["ShortSighted"] = -0.2,
        ["Clumsy"] = -0.2,
    },
}

return HuntingMod