
        local QBCore = exports['qb-core']:GetCoreObject()

        local function ExtractIdentifiers(src)
            local identifiers = {}
        
            for i = 0, GetNumPlayerIdentifiers(src) - 1 do
                local id = GetPlayerIdentifier(src, i)
        
                if string.find(id, "steam:") then
                    identifiers['steam'] = id
                elseif string.find(id, "ip:") then
                    identifiers['ip'] = id
                elseif string.find(id, "discord:") then
                    identifiers['discord'] = id
                elseif string.find(id, "license:") then
                    identifiers['license'] = id
                elseif string.find(id, "license2:") then
                    identifiers['license2'] = id
                elseif string.find(id, "xbl:") then
                    identifiers['xbl'] = id
                elseif string.find(id, "live:") then
                    identifiers['live'] = id
                elseif string.find(id, "fivem:") then
                    identifiers['fivem'] = id
                end
            end
        
            return identifiers
        end

    local function dPrint(query)
        if Config.Debug then 
            print(query)
        end
    end

    QBCore.Functions.CreateCallback(Config.doesPlayerHaveEnoughMoneyCallBack,function(source,cb,args) 
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerMoney = Player.PlayerData.money[Config.MoneyType]
        if playerMoney >= Config.StoragePrice then
        cb(true) 
        else
        cb(false)
        end
    end)

    RegisterNetEvent(Config.buyNewStorageUnitServerEvent, function(storagePrice, moneyType, storageDbName, storageSize)
   local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local playerMoney, playerLicense = Player.PlayerData.money[Config.MoneyType], QBCore.Functions.GetIdentifier(src, 'license')
       local playerCitizenId = Player.PlayerData.citizenid
        local storageIDrandom1 = math.random(1111, 9999)
        local storageIDrandom2 = math.random(1111, 9999)
        local storageIDrandom = storageIDrandom1..""..storageIDrandom2
        if playerMoney >= Config.StoragePrice then  
            Player.Functions.RemoveMoney(moneyType, storagePrice, Config.TransactionReason)
            exports.oxmysql:insert('INSERT INTO '..Config.DatabaseTableName..' ('..Config.citizenIDColumn..', '..Config.StorageIDColumn..', '..Config.StorageNameColumn..', '..Config.StorageSizeColumn..', '..Config.PlayerLicenseColumn..') VALUES (?, ?, ?, ?, ?)', {playerCitizenId, storageIDrandom, storageDbName, storageSize, playerLicense}, function(id)
                dPrint("ID execute-a: ".. id)
            end)
        end
end)

QBCore.Functions.CreateCallback(Config.getPlayerStashesCallBack,function(source,cb,args) 
    local src = args 
    local Player = QBCore.Functions.GetPlayer(src)
    local r = MySQL.prepare.await('SELECT * from vaults WHERE citizenid = ?', {Player.PlayerData.citizenid})
    if r then 
    cb(true, r.citizenid, r.storageid, r.storagename, r.storage_size, r.player_license, r.field2)
    else
    cb(false) 
    end
end)

RegisterNetEvent(Config.sellPersonalStorageServerEvent, function(playerSource)
    local src = playerSource 
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid
    local r = MySQL.prepare.await('SELECT * from vaults WHERE citizenid = ?', {Player.PlayerData.citizenid})
    local sellPrice = math.tointeger(Config.StoragePrice*Config.ReselPercentage)
    local logMessage = TranslationCall().logs.sellStashDescription..""..r.storagename.."\n"..TranslationCall().logs.sellStashDescription2..""..sellPrice..""..Config.YourCurrencySymbol
    TriggerEvent(Config.sendNewLogToDiscordServerEvent, Config.StashSellHook, logMessage, true, playerSource)
    MySQL.Async.execute('DELETE FROM stashitems WHERE stash = ?', {r.storagename})
    MySQL.Async.execute('DELETE FROM vaults WHERE citizenid = ?', { citizenId })
        Wait(2000)
        Player.Functions.AddMoney(Config.MoneyType, sellPrice, Config.TransactionReason)
end)

RegisterNetEvent(Config.sendNewLogToDiscordServerEvent, function(webHook, description, style, playerSource)
    local newEmbed
    local src = playerSource or source
    local ids = ExtractIdentifiers(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local playerData = Player.PlayerData
    local playerLicense = playerData.license 
    local playerSteamHex = QBCore.Functions.GetIdentifier(src, 'steam')
    local playerCitizenId = playerData.citizenid
    local playerName = playerData.name
    local playerCharacterName = playerData.charinfo.firstname 
    local playerCharacterSurname = playerData.charinfo.lastname
    local playerPhone = playerData.charinfo.phone 
    local playerCash = Player.PlayerData.money['cash']
    local playerBank = Player.PlayerData.money['bank']
    local playerCrypto = Player.PlayerData.money['crypto']
    local jobName = playerData.job.label
    local gangName = playerData.gang.label
    local _steamURL ="https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..""
    local _discordTag =""..math.tointeger(tonumber(ids.discord:gsub("discord:", ""), 20))..""
    local logMessage = ""..TranslationCall().logs.player.." "..playerName.."\n"..TranslationCall().logs.license.." "..playerLicense.."\n"..TranslationCall().logs.steam.." "..playerSteamHex.."\n ".._steamURL.."\n"..TranslationCall().logs.discord.." "..ids.discord.." ( ".._discordTag..")\n"..TranslationCall().logs.citizenid.." "..playerCitizenId.."\n"..TranslationCall().logs.firstName.." "..playerCharacterName.."\n"..TranslationCall().logs.lastName.." "..playerCharacterSurname.."\n"..TranslationCall().logs.phone.." "..playerPhone.."\n"..TranslationCall().logs.cash.." "..playerCash.."\n"..TranslationCall().logs.bank.." "..playerBank.."\n"..TranslationCall().logs.crypto.." "..playerCrypto.."\n"..TranslationCall().logs.job.." "..jobName.."\n"..TranslationCall().logs.gang.." "..gangName.." "
    if Config.Logs then 
        if style then 

             newEmbed = {
                {
                    ["color"] = Config.Color,
                    ["title"] = Config.Title,
                    ["description"] = "```"..description.."```", 
                    ["footer"] = {
                        ["text"] = logMessage,
                        ["icon_url"] = Config.LogsLogo,
                    },
                }
            }
            PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({username = Config.LogsUsername, embeds = newEmbed}), { ['Content-Type'] = 'application/json' }) 
        else

     newEmbed = {
        {
            ["color"] = Config.Color,
            ["title"] = Config.Title,
            ["description"] = description, 
            ["footer"] = {
                ["text"] = logMessage,
                ["icon_url"] = Config.LogsLogo,
            },
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({username = Config.LogsUsername, embeds = newEmbed}), { ['Content-Type'] = 'application/json' })  
end
else
end
end)
