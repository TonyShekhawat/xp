Config = {}

Config.Bossman = {
    ["networked"] = false,
    ["model"] = "a_m_m_og_boss_01",
    ["scenario"] = { -- A random scenario will be chosen
        [1] = "WORLD_HUMAN_DRUG_DEALER", 
        [2] = "WORLD_HUMAN_STAND_MOBILE", 
        [3] = "WORLD_HUMAN_AA_SMOKE", 
    },
    ["locations"] = { -- A random location will be chosen
        [1] = vector4(325.33, -212.6, 54.09 - 1, 165.93),
    },
}

Config.XPGroups = {
    [1] = {
        GroupName = "oxy",
        MaxLevel = 10,
        MaxReputation = 100000,
        CurrentLevel = 1,
        CurrentRep = 10001
    },
    [2] = {
        GroupName = "house",
        MaxLevel = 10,
        MaxReputation = 100000,
        CurrentLevel = 1,
        CurrentRep = 10001
    }
}