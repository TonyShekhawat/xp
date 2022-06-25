local Core = exports['qb-core']:GetCoreObject()

local resourceName = GetCurrentResourceName()

local bossEntity = 0

local function SpawnBoss()
    local model = Config.Bossman["model"]
    local location = Config.Bossman["locations"][math.random(1, #Config.Bossman["locations"])]
    local networked = Config.Bossman["networked"]
    local scenario = string.lower(Config.Bossman["scenario"][math.random(1, #(Config.Bossman["scenario"]))])

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    bossEntity = CreatePed(0, model, location.x, location.y, location.z, location.w, networked, true)
    FreezeEntityPosition(bossEntity, true)
    SetEntityInvincible(bossEntity, true)
    SetBlockingOfNonTemporaryEvents(bossEntity, true)
    TaskStartScenarioInPlace(bossEntity, scenario, 0, false)
end

local function TargetBoss(remove)
    if remove then
        exports["qb-target"]:RemoveZone("bossEntity")
    else
        exports["qb-target"]:AddEntityZone("bossEntity", bossEntity, {
            name = "bossEntity",
            heading = GetEntityHeading(bossEntity),
            debugPoly = false,
        }, {
            options = {
                {
                    icon = "",
                    label = "Get Level",
                    action = function()
                        --XP usage example, get current level
                        Core.Functions.TriggerCallback('exp:server:GetLevelInfo', function(info)
                            local currentLevel = info[1]
                            local currentRep = info[2]
                            local nextRep = info[3]
                            local levelInfo =  string.format("Level: %s - EXP: %s/%s", currentLevel, currentRep, nextRep)
                            print(levelInfo)
                        end)
                    end,
                },
                {
                    icon = "",
                    label = "Add XP",
                    action = function()
                        --XP usage example, add xp
                        TriggerServerEvent("exp:server:AddRep", 0.5)
                    end,
                },
                {
                    icon = "",
                    label = "Remove XP",
                    action = function()
                        --XP usage example, remove xp
                        TriggerServerEvent("exp:server:RemoveRep", 0.5)
                    end,
                },
            },
            distance = 1.5
        })
    end
end

CreateThread(function()
    SpawnBoss()
    TargetBoss(false)
    TriggerServerEvent("exp:server:SetupRep")
end)

/***************************************************/
/* Delete the bossman when the resource is stopped */
/***************************************************/

local function ResetBoss()
    TargetBoss(true)
    Wait(250)
    TargetBoss(false)
end

local function DeleteBoss()
    SetPedAsNoLongerNeeded(bossEntity)
    DeletePed(bossEntity)
    bossEntity = 0
end

AddEventHandler("onResourceStop", function(name)
	if name == resourceName then
        DeleteBoss()
        TargetBoss(true)
	end
end)

RegisterNetEvent("QBCore"..":".."OnPlayerUnload", function()
    DeleteBoss()
    TargetBoss(true)
end)