Config = {}

SD.Locale.LoadLocale('en')

Config.Interaction = 'target' -- 'target' = qb-target/qtarget/ox_target or 'textui' = cd_drawtextui/qb-core/ox_lib textui
Config.PropCooldown = 750 -- Cooldown in seconds for props to respawn after being taken

-- Config.Loot defines the possible loot items, each with a weighted chance.
-- The 'chance' value represents the relative probability of each item being selected.
Config.Loot = {
    amount = math.random(1, 3), -- Number of different items that can be received from one package
    items = {
        { item = 'goldbar', minAmount = 1, maxAmount = 2, chance = 10 },
        { item = 'lockpick', minAmount = 1, maxAmount = 2, chance = 30 },
        { item = 'gold_watch', minAmount = 1, maxAmount = 2, chance = 30 },
        { item = 'goldchain', minAmount = 1, maxAmount = 2, chance = 30 },
        { item = 'thermite', minAmount = 1, maxAmount = 1, chance = 2 },
        { item = 'gang-keychain', minAmount = 1, maxAmount = 1, chance = 5 },
        { item = 'stolen_toaster_01', minAmount = 1, maxAmount = 1, chance = 15 },
        { item = 'stolen_laptop_01a', minAmount = 1, maxAmount = 1, chance = 25 },
        { item = 'stolen_mixer_01', minAmount = 1, maxAmount = 1, chance = 25 },
        { item = 'stolen_coffemac_02', minAmount = 1, maxAmount = 1, chance = 25 },
        { item = 'purse', minAmount = 1, maxAmount = 1, chance = 30 },
    }
}


Config.PoliceAlert = {
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
        message = "Sightings of a person stealing packages from porches", -- Additional message or information
        -- Blip information is used for ALL dispatches besides ps_dispatch, please reference dispatchcodename below.
        sprite = 310,                            -- The blip sprite for oilrig or related icon
        scale = 1.0,                             -- The size of the blip on the map
        colour = 1,                              -- The color of the blip on the map (red, for example)
        blipText = "Parcel Theft",               -- Text that appears on the Blip
        -- ps-dispatch
        dispatchcodename = "parcel_theft"        -- This is the name used by ps-dispatch users for the sv_dispatchcodes.lua or config.lua under the Config.Blips entry. (Depending on Version)
    })
end -- This is the function that is called when the police are meant to be alerted. You can modify this in any way.

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
    },
    {
        coords = vector3(-374.62, 6190.97, 31.73),
        heading = 226.54,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-356.98, 6207.49, 31.84),
        heading = 226.31,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-347.54, 6225.34, 31.88),
        heading = 226.98,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-379.95, 6252.66, 31.85),
        heading = 317.37,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-360.19, 6260.57, 31.90),
        heading = 136.28,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-449.92, 6261.68, 30.04),
        heading = 67.62,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-442.47, 6197.88, 29.55),
        heading = 94.57,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-302.12, 6326.95, 32.89),
        heading = 42.01,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-227.23, 6377.42, 31.76),
        heading = 47.65,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-105.58, 6528.65, 30.17),
        heading = 305.62,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-8.41, 6653.31, 31.11),
        heading = 291.92,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(35.45, 6663.22, 32.19),
        heading = 166.79,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-272.57, 6401.05, 31.50),
        heading = 210.52,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(-213.60, 6396.30, 33.09),
        heading = 40.42,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    -- Sandy Shores
    {
        coords = vector3(1371.92, 3647.19, 34.34),
        heading = 15.12,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1392.07, 3659.32, 34.29),
        heading = 16.49,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1631.71, 3720.50, 34.39),
        heading = 127.86,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1735.13, 3809.95, 34.84),
        heading = 33.46,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1925.16, 3824.65, 32.44),
        heading = 31.29,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1898.85, 3781.72, 32.88),
        heading = 298.80,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1824.66, 3743.32, 34.72),
        heading = 16.94,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1797.48, 3721.86, 34.64),
        heading = 306.19,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1639.21, 3731.31, 35.07),
        heading = 325.65,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1437.14, 3605.43, 35.07),
        heading = 207.48,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1437.14, 3639.62, 36.17),
        heading = 7.91,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    },
    {
        coords = vector3(1382.57, 3605.43, 35.07),
        heading = 207.48,
        distance = 25.0,
        prop = 'hei_prop_heist_box',
        debug = false
    }
}
