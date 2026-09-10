# RedM Autofarm Bot

A fully standalone autofarm bot for RedM servers that allows players to automate mining operations without server integration.

## Features

✅ **Fully Standalone** - No server database or scripts required
✅ **Steam ID Verification** - Only works with registered Steam IDs
✅ **Autonomous Mining** - Mines continuously with G key
✅ **Auto Eat & Drink** - Automatically eats and drinks every 10 minutes using keys 1 and 2
✅ **Wagon Integration** - Calls wagon with J key when inventory is full
✅ **Easy Toggle** - Press F5 to start/stop the bot
✅ **Clean UI** - Chat notifications for all bot actions

## Installation

1. Download or clone this repository
2. Place the folder in your RedM resources folder
3. Add to your server.cfg:
   ```
   ensure redm-autofarm-bot
   ```
4. Restart your server

## How It Works

### Starting the Bot
- Press **F5** to toggle the bot ON/OFF
- The bot will automatically start mining

### Bot Actions
- **Mining**: Holds down **G** key for 2 seconds, then repeats every 3 seconds
- **Eating & Drinking**: Every 10 minutes, presses **1** (eat) and **2** (drink)
- **Inventory Management**: When inventory gets full, presses **J** to call a wagon
- **Wagon Storage**: Automatically places items in the wagon using **E** key

### Key Bindings
- **F5** - Toggle bot on/off
- **G** - Mining action (bot controlled)
- **1** - Eat (bot controlled)
- **2** - Drink (bot controlled)
- **J** - Call wagon (bot controlled)
- **E** - Place items in wagon (bot controlled)

## Configuration

Edit `client.lua` to customize bot behavior:

```lua
local botConfig = {
    miningKey = 'G',                    -- Mining key
    eatKey = '1',                       -- Eat key
    drinkKey = '2',                     -- Drink key
    callWagonKey = 'J',                 -- Call wagon key
    toggleKey = 'F5',                   -- Toggle bot on/off
    miningHoldDuration = 2000,          -- How long to hold G (milliseconds)
    miningCooldown = 3000,              -- Delay between mining actions
    eatDrinkInterval = 600000,          -- Eat/drink interval (10 minutes)
    inventoryCheckInterval = 5000       -- Inventory check interval
}
```

## Steam ID Verification

The bot automatically detects the player's Steam ID on load. Only the player with the Steam ID who purchased the bot can use it.

To add authorized Steam IDs, modify the `client.lua` file to include a whitelist:

```lua
local authorizedSteamIds = {
    "steam:1100001234567890",
    "steam:1100009876543210"
}
```

## How to Sell

1. Package this script for distribution
2. Have customers add their Steam ID to the whitelist before purchasing
3. Customers add the script to their resources folder
4. They press F5 to start farming!

## Support

For issues or customization requests, contact the developer.

---

**Version**: 1.0.0
**Author**: Your Name
**License**: All Rights Reserved
