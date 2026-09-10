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
    inventoryCheckInterval = 5000 -- Check inventory every 5 seconds
}

local lastMineTime = 0
local lastEatDrinkTime = 0
local lastInventoryCheckTime = 0
local wagonCalled = false

-- Initialize Steam ID on script load
Citizen.CreateThread(function()
    Wait(1000)
    playerSteamId = GetPlayerIdentifier(PlayerId(), 0) or "UNKNOWN"
    print("^2[AutoFarm Bot] Steam ID: " .. playerSteamId .. "^7")
end)

-- Main bot loop
Citizen.CreateThread(function()
    lastEatDrinkTime = GetGameTimer()
    
    while true do
        Wait(100)
        
        if botActive then
            local currentTime = GetGameTimer()
            
            -- Check inventory every 5 seconds
            if currentTime - lastInventoryCheckTime >= botConfig.inventoryCheckInterval then
                if IsInventoryFull() then
                    CallWagon()
                end
                lastInventoryCheckTime = currentTime
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
                print("^2[AutoFarm Bot] Bot started! Press F5 to stop.^7")
                NotifyPlayer("Bot started! Press F5 to stop.", 3)
            else
                print("^1[AutoFarm Bot] Bot stopped.^7")
                NotifyPlayer("Bot stopped.", 3)
            end
        end
    end
end)

-- Mining function
function Mine()
    local playerPed = PlayerPedId()
    
    -- Hold down the G key for mining
    local mineStartTime = GetGameTimer()
    while GetGameTimer() - mineStartTime < botConfig.miningHoldDuration do
        SetControlNormal(0, GetHashKey(botConfig.miningKey), 1.0)
        Wait(50)
    end
    
    -- Release the key
    SetControlNormal(0, GetHashKey(botConfig.miningKey), 0.0)
    
    print("^3[AutoFarm Bot] Mining...^7")
end

-- Eat and drink function
function EatAndDrink()
    print("^3[AutoFarm Bot] Eating and drinking...^7")
    NotifyPlayer("Eating and drinking...", 3)
    
    -- Eat (press 1)
    SetControlNormal(0, GetHashKey(botConfig.eatKey), 1.0)
    Wait(500)
    SetControlNormal(0, GetHashKey(botConfig.eatKey), 0.0)
    Wait(2000)
    
    -- Drink (press 2)
    SetControlNormal(0, GetHashKey(botConfig.drinkKey), 1.0)
    Wait(500)
    SetControlNormal(0, GetHashKey(botConfig.drinkKey), 0.0)
    Wait(1000)
end

-- Call wagon function
function CallWagon()
    if wagonCalled then
        return -- Don't call wagon again if already called
    end
    
    wagonCalled = true
    print("^5[AutoFarm Bot] Inventory full! Calling wagon...^7")
    NotifyPlayer("Inventory full! Calling wagon...", 5)
    
    -- Press J to call wagon
    SetControlNormal(0, GetHashKey(botConfig.callWagonKey), 1.0)
    Wait(500)
    SetControlNormal(0, GetHashKey(botConfig.callWagonKey), 0.0)
    
    print("^2[AutoFarm Bot] Wagon called! It will appear on your map.^7")
    NotifyPlayer("Wagon called! Moving to wagon location...", 5)
    
    -- Wait for wagon to appear and player to navigate to it
    Wait(8000)
    
    -- Try to place items in wagon
    PlaceItemsInWagon()
    
    -- Reset for next cycle
    Wait(3000)
    wagonCalled = false
end

-- Place items in wagon
function PlaceItemsInWagon()
    print("^5[AutoFarm Bot] Placing items in wagon...^7")
    NotifyPlayer("Placing items in wagon...", 5)
    
    -- Simulate interaction with wagon (press E multiple times to place items)
    for i = 1, 5 do
        SetControlNormal(0, GetHashKey('E'), 1.0)
        Wait(800)
        SetControlNormal(0, GetHashKey('E'), 0.0)
        Wait(800)
    end
    
    print("^2[AutoFarm Bot] Items placed! Continuing to farm...^7")
    NotifyPlayer("Items placed! Continuing to farm...", 3)
end

-- Check if inventory is full (using game natives)
function IsInventoryFull()
    local playerPed = PlayerPedId()
    local maxSlots = 20 -- Adjust based on your server's max slots
    
    -- This uses RedM's inventory check
    -- The actual implementation depends on your server's inventory system
    -- This is a placeholder that checks periodically
    
    -- You can customize this based on your inventory script
    -- For now, it will check if player has certain items
    
    return CheckInventoryStatus()
end

-- Check inventory status (simplified)
function CheckInventoryStatus()
    -- This checks if player appears to have many items
    -- In a real scenario, you'd integrate with your inventory system
    
    -- For now, return false to let it farm indefinitely
    -- You can modify this based on your server's inventory API
    return false
end

-- Notify player with on-screen message
function NotifyPlayer(message, duration)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"AutoFarm Bot", message}
    })
end

print("^2[AutoFarm Bot] Loaded successfully!^7")
print("^3Press F5 to toggle the bot on/off^7")
