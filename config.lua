-- ============================================================================
-- AUTOFARM BOT CONFIGURATION
-- ============================================================================
-- Customize the bot behavior using these settings
-- ============================================================================

Config = {}

-- Key Bindings
Config.Keys = {
    toggle = 'F5',           -- Toggle bot on/off
    mining = 'G',            -- Mining action key
    eat = '1',               -- Eat key
    drink = '2',             -- Drink key
    callWagon = 'J',         -- Call wagon key
    interact = 'E'           -- Interact/place items key
}

-- Mining Settings
Config.Mining = {
    holdDuration = 2000,     -- How long to hold mining key (ms)
    cooldown = 3000,         -- Delay between mining actions (ms)
    enabled = true           -- Enable/disable mining
}

-- Eating & Drinking Settings
Config.Survival = {
    eatDrinkInterval = 600000,  -- Every 10 minutes (ms)
    enabled = true              -- Enable/disable auto eat/drink
}

-- Wagon Settings
Config.Wagon = {
    callDuration = 8000,     -- Time to wait for wagon to appear (ms)
    placeDuration = 5000,    -- Time spent placing items (ms)
    itemsToPlace = 5,        -- Number of E key presses to empty inventory
    enabled = true           -- Enable/disable wagon integration
}

-- Inventory Settings
Config.Inventory = {
    checkInterval = 5000,    -- Check inventory every X ms
    maxSlots = 20,           -- Max inventory slots before calling wagon
    enabled = true           -- Enable/disable auto inventory check
}

-- Notifications
Config.Notifications = {
    enabled = true,          -- Enable/disable chat notifications
    showMining = false,      -- Show mining notifications
    showEating = true,       -- Show eating/drinking notifications
    showWagon = true,        -- Show wagon notifications
    showBot = true           -- Show bot status notifications
}

-- Steam ID Whitelist (Optional)
-- Leave empty to allow all Steam IDs
Config.AuthorizedSteamIds = {
    -- "steam:1100001234567890",
    -- "steam:1100009876543210"
}

-- Admin Features
Config.AdminFeatures = {
    enabled = true,          -- Enable admin commands
    command = '/botadmin',   -- Admin command
    allowAllSteamIds = false -- Allow all Steam IDs (for testing)
}

return Config
