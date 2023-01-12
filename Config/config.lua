local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}

--DISCORD LOGS 
Config.Logs = true
Config.LogsLogo = "https://i.imgur.com/Q7b7RCo.png" --must end with a .png or .jpg
Config.LogsUsername = GetCurrentResourceName()
Config.Color = "8663711"
Config.Title = "[ "..GetCurrentResourceName().." ] - LOGS"

-- WEBHOOKS 
Config.StashBoughtHook = "https://discord.com/api/webhooks/1062851589578170438/VxI7Y-eSadC959bgA9QoT9RnMGpptv-yVRKc-mjXcDlVIveV0iCzI2OfdXdRHHi6HMeY"
Config.StashSellHook = "https://discord.com/api/webhooks/1063078461259911259/hmOSpooMJ2nPukyNypHQkSMNoYnSlLEjipnUiH7ieeZOgNL0AOzr3iLnCGgH4bi4-cmk"

--DEV
Config.Debug = true


--TRANSLATION
Config.TranslationEN = true 
Config.TranslationCRO = false

--DATABASE ( NO NEED TO EDIT IF YOU'RE GOING TO USE THE SQL FILE PROVIDED)
Config.DatabaseTableName = 'vaults'
Config.citizenIDColumn = 'citizenid'
Config.StorageIDColumn = 'storageid'
Config.StorageNameColumn = 'storagename'
Config.StorageSizeColumn = 'storage_size'
Config.PlayerLicenseColumn = 'player_license'


--STORAGE / MONEY
Config.YourCurrencySymbol = "$" -- Doesn't have to be populated, it's just an option in which you can set your currency symbol that u use for ex. "$" 
Config.MoneyType = 'cash' -- available types are cash or bank (doesn't mean you can't use crypto but like why :D),
Config.TransactionReason = "Storage Unit" -- description for the transaction
Config.StoragePrice = 50000
Config.ReselPercentage = 0.5
Config.StorageSize = 50000 -- Storage inventory max weight 
Config.StorageSlots = 50

-- [ EVENTS ]

    -- [ CLIENT ]
Config.openStashBuyMenuEvent = "predicted-stashes:client:openStashBuyMenu"
Config.closeStashBuyMenuEvent = "predicted-stashes:client:closeStashBuyMenuEvent"
Config.buyNewStorageUnitEvent = "predicted-stashes:client:buyNewStorageUnitEvent"
Config.openPredictedStashEvent = "predicted-stashes:client:openPredictedStashEvent"
Config.sellPersonalStorageEvent = "predicted-stashes:client:sellPredictedStashEvent"
Config.RemoveBlipClientEvent = "predicted-stashes:client:RemoveBlipClientEvent"

-- [ SERVER ]
Config.buyNewStorageUnitServerEvent = "predicted-stashes:server:buyNewStorageUnitServerEvent"
Config.sendNewLogToDiscordServerEvent = "predicted-stashes:server:sendNewLogToDiscord"
Config.sellPersonalStorageServerEvent = "predicted-stashes:server:sellPersonalStorageServerEvent"

-- [ CALLBACKS ]
Config.doesPlayerHaveEnoughMoneyCallBack = "predicted-stashes:server:doesPlayerHaveEnoughMoneyCallBack"
Config.getPlayerStashesCallBack = "predicted-stashes:server:getPlayerStashesCallBack"


--Stash Shop Locations And Blips
Config.StashShopLocation = {
    {   
        blip = true,
        blipSprite = 351,
        blipSize = 1.1,
        blipColor = 2,
        blipName = "Stash Unit Shop",
        polyName = "predictedStashShopLocation1",
        polyWidth = 1.45,
        polyHeight = 1.45,
        debugPoly = false,
        eventType = 'client',
        eventName = Config.openStashBuyMenuEvent,
        targetIcon = 'fas fa-sign-in-alt',
        interactDistance = 1.5,
        shopCoords = vector4(1237.16, -2948.52, 9.32, 3.28),
    },
}

Config.StashLocations = {
    {
        blip = true,
        blipSprite = 479,
        blipSize = 0.75,
        blipColor = 2,
        blipName = "Personal Stash Unit",
        polyName = "predictedStashLocation1",
        polyWidth = 1.45,
        polyHeight = 1.45,
        debugPoly = false,
        eventType = 'client',
        eventName = Config.openPredictedStashEvent,
        targetIcon = 'fas fa-sign-in-alt',
        interactDistance = 1.5,
        stashCoords = vector4(1244.72, -2944.88, 9.32, 180.24),
    },
}


function SendNotify(text, notifyType, length) -- you can replace the inner part of the function with your own but it is qb-notify by default 
    QBCore.Functions.Notify(text, notifyType, length)
end