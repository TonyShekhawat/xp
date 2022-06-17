local Core = exports['qb-core']:GetCoreObject()

local currentRep = 10001
local maxRep = 100000
local currentLevel = 1
local maxLevel = 10

RegisterNetEvent('pogu:server:SetupRep', function()
    local src = source
    local player = Core.Functions.GetPlayer(src)
    if not player then return end
    local cid = player.PlayerData.citizenid
    local amount = 1
    local data = MySQL.Sync.prepare('SELECT * FROM boss_reputation where cid = ?', {cid})
    if not data then
        MySQL.query('SELECT * FROM boss_reputation', function(result)
            if result then
                if #(result) ~= 0 then amount = #(result) + 1 end
                MySQL.insert('INSERT INTO boss_reputation (id, cid, rep) VALUES (?, ?, ?)', {amount, cid, currentRep}, function(result) end)
            end
        end)
    else
        currentRep = data.rep
    end
end)

RegisterNetEvent('pogu:server:AddRep', function(multiplier)
    local src = source
    local player = Core.Functions.GetPlayer(src)
    if not player then return end
    local cid = player.PlayerData.citizenid
    local newRep = math.random(400, 500) * multiplier
    currentRep = currentRep + newRep
    MySQL.update('UPDATE boss_reputation SET rep = ? WHERE cid = ?', {currentRep, cid}, function(result) end)
end)

RegisterNetEvent('pogu:server:RemoveRep', function(multiplier)
    local src = source
    local player = Core.Functions.GetPlayer(src)
    if not player then return end
    local cid = player.PlayerData.citizenid
    local newRep = math.random(400, 500) * multiplier
    currentRep = currentRep - newRep
    MySQL.update('UPDATE boss_reputation SET rep = ? WHERE cid = ?', {currentRep, cid}, function(result) end)
end)

function getLevel()
    for i = 1, maxLevel + 1 do
        lvl = i - 1
        local nextLvl = math.floor((maxRep / 100) * i * 10)
        if currentRep <= nextLvl then break end
    end
    currentLevel = lvl
    return currentLevel
end

Core.Functions.CreateCallback('pogu:server:GetLevel', function(_, cb)
    cb(getLevel())
end)