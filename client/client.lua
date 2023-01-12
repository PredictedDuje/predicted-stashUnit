local QBCore = exports['qb-core']:GetCoreObject()

local function CreateBlip(blipType, x, y, z, sprite, size, color, name)
  local blip 
  local blip2
    if blipType then 
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
   else
     blip2 = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip2, sprite)
    SetBlipDisplay(blip2, 4)
    SetBlipScale(blip2, size)
    SetBlipColour(blip2, color)
    SetBlipAsShortRange(blip2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip2)
   end
    RegisterNetEvent(Config.RemoveBlipClientEvent, function(whichBlip)
            if whichBlip == "blip" then 
                    RemoveBlip(blip)
                elseif whichBlip =='blip2' then
                    RemoveBlip(blip2)
            else
        end
    end)
end 


AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    local playerId = GetPlayerServerId(PlayerId())
        if playerId ~= nil then
            for _, v in pairs(Config.StashLocations) do 
                if v.blip then 
                    QBCore.Functions.TriggerCallback(Config.getPlayerStashesCallBack,function(hasStorage)
                        if hasStorage then
                            CreateBlip(false, v.stashCoords.x, v.stashCoords.y, v.stashCoords.z, v.blipSprite, v.blipSize, v.blipColor, v.blipName)
                        end
                    end, GetPlayerServerId(PlayerId()))
                end
            end
        end
            for _, v in pairs(Config.StashShopLocation) do
                if v.blip then 
                CreateBlip(true, v.shopCoords.x, v.shopCoords.y, v.shopCoords.z, v.blipSprite, v.blipSize, v.blipColor, v.blipName)
                end
            end
    end
end)


AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    for _, v in pairs(Config.StashLocations) do 
        if v.blip then 
            QBCore.Functions.TriggerCallback(Config.getPlayerStashesCallBack,function(hasStorage)
                if hasStorage then
                    CreateBlip(false, v.shopCoords.x, v.shopCoords.y, v.shopCoords.z, v.blipSprite, v.blipSize, v.blipColor, v.blipName)
                end
            end, GetPlayerServerId(PlayerId()))
        end
    end
end)



AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent(Config.RemoveBlipClientEvent, "blip")
        TriggerEvent(Config.RemoveBlipClientEvent, "blip2")
     for _, v in pairs(Config.StashShopLocation) do 
        exports['qb-target']:RemoveZone(v.polyName)
     end
     for _, k in pairs(Config.StashLocations) do 
        exports['qb-target']:RemoveZone(k.polyName)
     end
    end
 end)

local function LogFunction(webhook, message, style)
    if Config.Logs then
        TriggerServerEvent(Config.sendNewLogToDiscordServerEvent, webhook, message, style)   
    end 
end
local function openInventoryStash(stashName, weightMax, storageSlots)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {maxweight = weightMax, slots = storageSlots})
    TriggerEvent("inventory:client:SetCurrentStash", stashName)
end

local function dPrint(query)
    if Config.Debug then 
        print(query)
    end
end

CreateThread(function ()
    for _, v in pairs(Config.StashShopLocation) do
        exports['qb-target']:AddBoxZone(v.polyName, vector3(v.shopCoords.x, v.shopCoords.y, v.shopCoords.z), v.polyWidth, v.polyHeight, {
        name = v.polyName,
        heading = v.shopCoords.w,
        debugPoly = v.debugPoly,
        minZ = v.shopCoords.z - 1.5,
        maxZ = v.shopCoords.z + 1.5,
        }, 
        {
        options = {
        {
        type = v.eventType,
        event = v.eventName,
        icon = v.targetIcon,
        label = TranslationCall().target.buyStashLabel,
        }
        },
        distance = v.interactDistance
        })
    end

    for _, v in pairs(Config.StashLocations) do
        exports['qb-target']:AddBoxZone(v.polyName, vector3(v.stashCoords.x, v.stashCoords.y, v.stashCoords.z), v.polyWidth, v.polyHeight, {
        name = v.polyName,
        heading = v.stashCoords.w,
        debugPoly = v.debugPoly,
        minZ = v.stashCoords.z - 1.5,
        maxZ = v.stashCoords.z + 1.5,
        }, 
        {
        options = {
        {
        type = v.eventType,
        event = v.eventName,
        icon = v.targetIcon,
        label = TranslationCall().target.openStashLabel,
        }
        },
        distance = v.interactDistance
        })
    end
end)

RegisterNetEvent(Config.openStashBuyMenuEvent, function()
       local StashBuyMenu1 = {
                {
                    header = TranslationCall().menu.StashShopBuyMenuHeader,
                    isMenuHeader = true, 
                },
                {
                    header = TranslationCall().menu.StashShopBuyMenuBuyStorage,
                    txt = TranslationCall().menu.StashShopBuyMenuBuyStorageTxT,
                    params = {
                        event = Config.buyNewStorageUnitEvent,}
                },
                {
                    header = TranslationCall().menu.StashShopBuyMenuCloseMenu,
                    txt = TranslationCall().menu.StashShopBuyMenuCloseMenuTxT,
                    params = { event = Config.closeStashBuyMenuEvent, }
                },
            }
        exports["qb-menu"]:openMenu(StashBuyMenu1)
end)

RegisterNetEvent(Config.closeStashBuyMenuEvent, function() end)



RegisterNetEvent(Config.buyNewStorageUnitEvent, function()
QBCore.Functions.TriggerCallback(Config.getPlayerStashesCallBack,function(hasStorage)
        if not hasStorage then
    
    QBCore.Functions.TriggerCallback(Config.doesPlayerHaveEnoughMoneyCallBack,function(hasMoney)
        local playerCitizenID = QBCore.Functions.GetPlayerData().citizenid
        if hasMoney then
            local dialog = exports['qb-input']:ShowInput({
                header = TranslationCall().inputMenu.header,
                submitText = TranslationCall().inputMenu.submitText,
                inputs = {
                    {
                        text = playerCitizenID..""..TranslationCall().inputMenu.storageNamePlaceholder, -- text you want to be displayed as a place holder
                        name = TranslationCall().inputMenu.storageNameInputName, -- name of the input should be unique otherwise it might override
                        type = TranslationCall().inputMenu.storageNameInputType, -- type of the input
                        isRequired = TranslationCall().inputMenu.storageNameIsRequired, -- Optional [accepted values: true | false] but will submit the form if no value is inputted    
                    }
                },
            })
             if dialog ~= nil then 
                for _,v in pairs(dialog) do  
                    dPrint(v)
            SendNotify(TranslationCall().success.youHaveBoughtAStash, TranslationCall().notificationPropperties.notifTypeSuccess, TranslationCall().notificationPropperties.length)
            local storageNameGsub = string.gsub(v," ","")
            TriggerServerEvent(Config.buyNewStorageUnitServerEvent, Config.StoragePrice, Config.MoneyType, playerCitizenID..""..storageNameGsub, Config.StorageSize)
            for _,c in pairs(Config.StashLocations) do 
                if c.blip then
                    CreateBlip(false, c.stashCoords.x, c.stashCoords.y, c.stashCoords.z, c.blipSprite, c.blipSize, c.blipColor, c.blipName)
                end
            end
            LogFunction(Config.StashBoughtHook, TranslationCall().logs.stashBought.."\nStash Name: "..v.."\n"..TranslationCall().logs.stashPrice..""..Config.StoragePrice.."$", TranslationCall().logs.stashBoughtStyle)
        end
            end
        else
            SendNotify(TranslationCall().noMoney.youDontHaveEnoughMoney, TranslationCall().notificationPropperties.notifTypeError, TranslationCall().notificationPropperties.length)
        end
    end)
        else
            SendNotify(TranslationCall().error.stashAlreadyPurchased, TranslationCall().notificationPropperties.notifTypeError, TranslationCall().notificationPropperties.length)
        end
end, GetPlayerServerId(PlayerId()))
end)

    RegisterNetEvent(Config.openPredictedStashEvent, function()
        local playerCitizenID = QBCore.Functions.GetPlayerData().citizenid
        QBCore.Functions.TriggerCallback(Config.getPlayerStashesCallBack,function(exists, citizenId, storageId, storageName, storageSize, playerLicense, field2)
        if exists then
            if storageName ~= nil then
                local StashBuyMenu1 = {
                    {
                        header = TranslationCall().menu.PersonalStashUnitStorageOptionsHeader, 
                        isMenuHeader = true, 
                    },
                    {
                        header = TranslationCall().menu.PersonalStashUnitHeader,
                        txt = TranslationCall().menu.PersonalStashUnitStorageOptionsHeaderTxt,
                        params = {
                            event = "OS", }
                    },
                    {
                        header = TranslationCall().menu.PersonalStorageUnitSellStorageHeader,
                        txt = TranslationCall().menu.PersonalStorageUnitSellStorageHeaderTxt,
                        params = {
                            event = Config.sellPersonalStorageEvent,}
                    },
                    {
                        header = TranslationCall().menu.StashShopBuyMenuCloseMenu,
                        txt = TranslationCall().menu.StashShopBuyMenuCloseMenuTxT,
                        params = { event = Config.closeStashBuyMenuEvent, }
                    },
                } exports["qb-menu"]:openMenu(StashBuyMenu1)
                    RegisterNetEvent("OS", function()
                        openInventoryStash(storageName, Config.StorageSize, Config.StorageSlots)
                    end)  
            else
                SendNotify(TranslationCall().error.stashNotAccessible, TranslationCall().notificationPropperties.notifTypeError, TranslationCall().notificationPropperties.length) 
            end
        else
            SendNotify(TranslationCall().error.stashNotFound, TranslationCall().notificationPropperties.notifTypeError, TranslationCall().notificationPropperties.length)
        end
        end, GetPlayerServerId(PlayerId()))
    end)

    RegisterNetEvent(Config.sellPersonalStorageEvent, function(data)
        QBCore.Functions.TriggerCallback(Config.getPlayerStashesCallBack,function(hasStorage)
            if not hasStorage then
                SendNotify(TranslationCall().error.stashNotFoundCannotBeSold, TranslationCall().notificationPropperties.notifTypeError, TranslationCall().notificationPropperties.length)
            else
                TriggerEvent(Config.RemoveBlipClientEvent, "blip2")
                TriggerServerEvent(Config.sellPersonalStorageServerEvent, GetPlayerServerId(PlayerId()))
                SendNotify(TranslationCall().success.stashSoldFor, TranslationCall().notificationPropperties.notifTypeSuccess, TranslationCall().notificationPropperties.length)
            end
        end, GetPlayerServerId(PlayerId()))    
    end)
