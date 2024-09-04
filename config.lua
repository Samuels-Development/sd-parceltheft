Config = {}

SD.Locale.LoadLocale('en')

Config.Interaction = 'target' -- 'target' = qb-target/qtarget/ox_target or 'textui' = cd_drawtextui/qb-core/ox_lib textui
Config.PropCooldown = 600 -- Cooldown in seconds for props to respawn after being taken

-- Config.Loot defines the possible loot items, each with a weighted chance.
-- The 'chance' value represents the relative probability of each item being selected.
Config.Loot = {
    amount = math.random(1, 3), -- Number of different items that can be received from one package
    items = {
        { item = 'gold_bar', minAmount = 1, maxAmount = 3, chance = 50 },
        { item = 'diamond', minAmount = 1, maxAmount = 2, chance = 30 },
        { item = 'rolex', minAmount = 1, maxAmount = 2, chance = 30 },
        { item = '10kgoldchain', minAmount = 1, maxAmount = 2, chance = 30 },
    }
}


PoliceAlert = {
    Enabled = true, -- Toggle police alert on or off
    NightChance = 17, -- Chance of police alert at night
    DayChance = 35, -- Chance of police alert during the day
    NightStart = 22, -- Start of night time (hours)
    NightEnd = 5 -- End of night time (hours)
}

-- Police Alert for Oilrig Heist
policeAlert = function()
    SD.PoliceDispatch({ -- (SD.PoliceDispatch is a sd_lib module and it automatically supports ps-dispatch, cd_dispatch, core-dispatch, linden_outlawalert, and qs-dispatch )
        displayCode = "10-21C",                    -- Dispatch Code
        title = 'Parcel Theft',                   -- Title is used in cd_dispatch/ps-dispatch
        description = "Reported Parcel Theft",-- Description of the heist
        message = "Sightings of a person stealing packages from poarches", -- Additional message or information
        -- Blip information is used for ALL dispatches besides ps_dispatch, please reference dispatchcodename below.
        sprite = 310,                            -- The blip sprite for oilrig or related icon
        scale = 1.0,                             -- The size of the blip on the map
        colour = 1,                              -- The color of the blip on the map (red, for example)
        blipText = "Parcel Theft",               -- Text that appears on the Blip
        -- ps-dispatch
        dispatchcodename = "parcel_theft"        -- This is the name used by ps-dispatch users for the sv_dispatchcodes.lua or config.lua under the Config.Blips entry. (Depending on Version)
    })
  end -- This is the function that is called when the police are meant to be alerted. You can modify this in any way.

-- Locations for each package
Config.Locations = {
    {
        coords = vector3(1060.63, -378.30, 67.24),
        heading = 50.0,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1010.23, -423.59, 64.35),
        heading = -52.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1028.81, -409.67, 64.95),
        heading = -50.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1056.19, -449.07, 65.26),
        heading = -10.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(893.20, -540.62, 57.51),
        heading = -63.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(850.28, -532.66, 56.93),
        heading = -94.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(861.73, -583.54, 57.16),
        heading = 2.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(980.31, -627.75, 58.24),
        heading = 37.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(959.95, -669.93, 57.45),
        heading = -61.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(996.79, -729.64, 56.82),
        heading = -50.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1201.07, -575.49, 68.14),
        heading = -46.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1265.15, -704.05, 63.54),
        heading = -30.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1303.17, -527.39, 70.47),
        heading = -20.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1373.14, -555.82, 73.69),
        heading = 70.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1341.33, -597.35, 73.71),
        heading = 55.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1301.04, -574.35, 70.74),
        heading = -13.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1250.80, -515.48, 68.35),
        heading = -105.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1262.60, -429.84, 69.02),
        heading = -66.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1100.93, -411.39, 66.56),
        heading = -100.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1009.71, -572.51, 59.60),
        heading = -99.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(965.08, -543.30, 58.36),
        heading = -60.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1045.53, -497.57, 63.08),
        heading = -103.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(993.62, -620.83, 58.05),
        heading = -57.00,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    }
}