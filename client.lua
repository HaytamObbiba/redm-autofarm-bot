local botActive = false
local playerSteamId = nil
local botConfig = {
    miningKey = 'G',
    eatKey = '1',
    drinkKey = '2',
    callWagonKey = 'J',
    toggleKey = 'F5',
    miningHoldDuration = 2000, -- milliseconds
    miningCooldown = 3000, -- milliseconds between mining actions
    eatDrinkInterval = 600000, -- 10 minutes in milliseconds
    inventoryCheckInterval = 5000, -- Check inventory every 5 seconds
    maxInventorySlots = 20 -- Adjust based on your server
}

local lastMineTime = 0
local lastEatDrinkTime = GetGameTimer()
local isHoldingMiningKey = false

-- Initialize Steam ID on script load
Citizen.CreateThread(function()
    playerSteamId = GetPlayerIdentifier(PlayerId(), 0) -- Get Steam ID
    print("^2[AutoFarm Bot] Steam ID: " .. playerSteamId .. "^7")
end)

-- Main bot loop
Citizen.CreateThread(function()
    while true do
        Wait(100)
        
        if botActive then
            local currentTime = GetGameTimer()
            
            -- Check if inventory is full
            if IsInventoryFull() then
                CallWagon()
            end
            
            -- Eat and drink every 10 minutes
            if currentTime - lastEatDrinkTime >= botConfig.eatDrinkInterval then
                EatAndDrink()
                lastEatDrinkTime = currentTime
            end
            
            -- Mine continuously
            if currentTime - lastMineTime >= botConfig.miningCooldown then
                Mine()
                lastMineTime = currentTime
            end
        end
    end
end)

-- Toggle bot on/off with F5
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        if IsControlJustReleased(0, GetHashKey(botConfig.toggleKey)) then
            botActive = not botActive
            if botActive then
                TriggerEvent('chat:addMessage', {
                    color = {0, 255, 0},
                    multiline = true,
                    args = {"AutoFarm Bot", "Bot started! Press F5 to stop."}
                })
            else
                TriggerEvent('chat:addMessage', {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"AutoFarm Bot", "Bot stopped."}
                })
            end
        end
    end
end)

-- Mining function
function Mine()
    local playerPed = PlayerPedId()
    
    -- Play mining animation
    RequestAnimDict("combat@damage@rb_writhe")
    while not HasAnimDictLoaded("combat@damage@rb_writhe") do
        Wait(100)
    end
    
    TaskPlayAnim(playerPed, "combat@damage@rb_writhe", "rb_writhe_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Hold the mining key
    local mineStartTime = GetGameTimer()
    while GetGameTimer() - mineStartTime < botConfig.miningHoldDuration do
        -- Simulate holding G key
        SetControlNormal(0, GetHashKey(botConfig.miningKey), 1.0)
        Wait(100)
    end
    
    -- Release key
    SetControlNormal(0, GetHashKey(botConfig.miningKey), 0.0)
    
    -- Stop animation
    StopAnimTask(playerPed, "combat@damage@rb_writhe", "rb_writhe_loop", 1.0)
end

-- Eat and drink function
function EatAndDrink()
    local playerPed = PlayerPedId()
    
    -- Eat (press 1)
    SetControlNormal(0, GetHashKey(botConfig.eatKey), 1.0)
    Wait(500)
    SetControlNormal(0, GetHashKey(botConfig.eatKey), 0.0)
    Wait(2000)
    
    -- Drink (press 2)
    SetControlNormal(0, GetHashKey(botConfig.drinkKey), 1.0)
    Wait(500)
    SetControlNormal(0, GetHashKey(botConfig.drinkKey), 0.0)
    
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        multiline = true,
        args = {"AutoFarm Bot", "Eating and drinking..."}
    })
end

-- Call wagon function
function CallWagon()
    TriggerEvent('chat:addMessage', {
        color = {255, 165, 0},
        multiline = true,
        args = {"AutoFarm Bot", "Inventory full! Calling wagon..."}
    })
    
    -- Press J to call wagon
    SetControlNormal(0, GetHashKey(botConfig.callWagonKey), 1.0)
    Wait(500)
    SetControlNormal(0, GetHashKey(botConfig.callWagonKey), 0.0)
    
    -- Wait for wagon to appear on map
    Wait(5000)
    
    -- Navigate to wagon and place items
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"AutoFarm Bot", "Wagon called! Moving to wagon..."}
    })
    
    -- Wait for player to reach wagon (can be customized with pathfinding)
    Wait(10000)
    
    -- Empty inventory into wagon
    EmptyInventoryToWagon()
end

-- Empty inventory to wagon
function EmptyInventoryToWagon()
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"AutoFarm Bot", "Placing items in wagon..."}
    })
    
    -- Simulate placing items (press E or interact)
    SetControlNormal(0, GetHashKey('E'), 1.0)
    Wait(1000)
    SetControlNormal(0, GetHashKey('E'), 0.0)
    
    Wait(3000)
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"AutoFarm Bot", "Items placed! Returning to farm..."}
    })
end

-- Check if inventory is full
function IsInventoryFull()
    -- This needs to be customized based on your inventory system
    -- You may need to trigger a server event to check inventory
    TriggerServerEvent('autofarm:checkInventory')
    return false -- Placeholder
end

-- Receive inventory full status from server
RegisterNetEvent('autofarm:inventoryIsFull')
AddEventHandler('autofarm:inventoryIsFull', function(isFull)
    if isFull then
        CallWagon()
    end
end)
