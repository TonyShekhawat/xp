local Core = exports['qb-core']:GetCoreObject()

local resourceName = GetCurrentResourceName()

local currentRep = 10001
local maxRep = 100000
local currentLevel = 1
local maxLevel = 10

--local levelLabel = "Level: %s - EXP: %s/%s"
--levelLabel = string.format("Level: %s - EXP: %s/%s", lvl, currentRep, nextRep)

RegisterNetEvent('exp:server:LoadRep', function()
    local src = source
    local player = Core.Functions.GetPlayer(src)
    if not player then return end
    local cid = player.PlayerData.citizenid
    local data = MySQL.Sync.prepare('SELECT * FROM boss_reputation where cid = ?', {cid})
    if not data then
        MySQL.query('SELECT * FROM boss_reputation', function(result)
            if result then
                if #(result) ~= 0 then id = #(result) + 1 end
                MySQL.insert('INSERT INTO boss_reputation (id, cid, rep) VALUES (?, ?, ?)', {id, cid, currentRep}, function(result) end)
            end
        end)
    else
        currentRep = data.rep
    end
end)

RegisterNetEvent('exp:server:AddRep', function(multiplier)
    local src = source
    local player = Core.Functions.GetPlayer(src)
    if not player then return end
    local cid = player.PlayerData.citizenid
    local rngRep = math.random(400, 500)
    local newRep = math.floor((rngRep - (rngRep / 100) * currentLevel * 10) * multiplier)
    if currentRep == maxRep then return end
    if currentRep + newRep > maxRep then newRep = maxRep % currentRep end
    currentRep = currentRep + newRep
    MySQL.update('UPDATE boss_reputation SET rep = ? WHERE cid = ?', {currentRep, cid}, function(result) end)
end)

RegisterNetEvent('exp:server:RemoveRep', function(multiplier)
    local src = source
    local player = Core.Functions.GetPlayer(src)
    if not player then return end
    local cid = player.PlayerData.citizenid
    local rngRep = math.random(400, 500)
    if currentRep - rngRep < 0 then return end
    currentRep = currentRep - rngRep
    MySQL.update('UPDATE boss_reputation SET rep = ? WHERE cid = ?', {currentRep, cid}, function(result) end)
end)

function getLevelInfo()
    for i = 1, maxLevel do
        lvl = i - 1
        nextRep = math.floor((maxRep / 100) * i * 10)
        if currentRep == maxRep then lvl = maxLevel break end
        if currentRep <= nextRep then break end
    end
    currentLevel = lvl
    return { currentLevel, currentRep, lvl == maxLevel and maxRep or nextRep }
end

Core.Functions.CreateCallback('exp:server:GetLevelInfo', function(_, cb)
    cb(getLevelInfo())
end)