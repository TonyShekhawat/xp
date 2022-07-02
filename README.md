# A simple oxmysql XP system for QBCore

## Setup

1. Import the xp.sql file
2. Load XP data when the player joins
```
RegisterNetEvent("QBCore:OnPlayerLoaded", function()
    TriggerServerEvent("exp:server:LoadRep")
end)
```
OR

```
CreateThread(function()
    TriggerServerEvent("exp:server:LoadRep")
end)

```
3. Getting level info
```
Core.Functions.TriggerCallback('exp:server:GetLevelInfo', function(info)
    local currentLevel = info[1] -- Get the players level
    local currentRep = info[2] -- Get the players current XP amount
    local nextRep = info[3] -- Get the XP amount for the next level
    local levelInfo =  string.format("Level: %s - EXP: %s/%s", currentLevel, currentRep, nextRep)
end)

```
4. Adding/removing XP
```
local multi = 1.5 -- Change this if you want to increase/decrease the amount of XP given
Add XP - TriggerServerEvent("exp:server:AddRep", multi) 
Remove XP - TriggerServerEvent("exp:server:RemoveRep", multi)

```
