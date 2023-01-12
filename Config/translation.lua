local moneyTypeCRO
local resellPercentage = Config.ReselPercentage*100 
local stashResoldFor = math.tointeger(Config.StoragePrice*Config.ReselPercentage)

function TranslationCall()
    if Config.TranslationEN then
        return(Config.enTranslation)
        else if Config.TranslationCRO then 
           return(Config.croTranslation)
        end
    end
end
if Config.MoneyType == 'cash' then
    moneyTypeCRO = " U Kesu"
elseif Config.MoneyType ==  "bank" then
    moneyTypeCRO = " Na Banci"
elseif Config.MoneyType == "crypto" then
    moneyTypeCRO = " U Crypto"
end


Config.enTranslation = {
    notificationPropperties = {
        length = 7500,
        notifTypeError = "error",
        notifTypeSuccess = "success",
    },
    target = {
        buyStashLabel = "Access Stash Buy Menu",
        openStashLabel = "Access Your Storage Unit",
    },
    inputMenu = {
        header = "Stash Buy Menu",
        submitText = "Submit",
        storageNamePlaceholder = "Enter a Stash Name",
        storageNameInputName = "stashName", -- BEST LEFT DEFAULT -- MUST BE MUUUST BE UNIQUE AND NOT MENTIONED ANYWHERE ELSE SO THERE'S NO CONFLICT
        storageNameInputType = "text", -- BEST LEFT DEFAULT -- INPUT TYPE FOR THE QB-INPUT 
        storageNameIsRequired = true, -- DON'T MESS WITH THIS ONE IT's IMPORTANT THAT IT'S TRUE
    },
    menu = {
        StashShopBuyMenuHeader = "Stash Buy Menu",
        StashShopBuyMenuCloseMenu = "Close Menu",
        StashShopBuyMenuCloseMenuTxT = "",
        StashShopBuyMenuBuyStorage = "Buy Storage Unit",
        StashShopBuyMenuBuyStorageTxT = "Get yourself a neat place to keep your valuable items away from robbers",
        PersonalStashUnitHeader = "Personal Stash Unit",
        PersonalStashUnitStorageOptionsHeader = "Storage Options",
        PersonalStashUnitStorageOptionsHeaderTxt = "Open your personal stash unit",
        PersonalStorageUnitSellStorageHeader = "Sell Your Unit",
        PersonalStorageUnitSellStorageHeaderTxt = "Sell Your Personal Storage Unit and get "..resellPercentage.."% of the original Price!",
    },
    noMoney = {
        youDontHaveEnoughMoney = "You don't have enough money! You need: "..Config.StoragePrice.." | "..Config.MoneyType,
    },
    logs = {
        stashBought = "Player bought a stash!",
        stashPrice = "Price: ",
        stashBoughtStyle = true,
        player = "Player:",
        license = "License:",
        steam = "Steam:",
        discord = "DiscordId:",
        citizenid = "CitizenID:",
        firstName = "First Name:",
        lastName = "Last Name:",
        phone = "Phone Number:",
        cash = "Cash Balance:",
        bank = "Bank Balance:",
        crypto = "Crypto Balance:",
        job = "Player Job:",
        gang = "Player Gang:",
        sellStashDescription = "Player has sold their stash: ",
        sellStashDescription2 = "For: ",
    },
    
    success = {
        buyStashRMReason = "Bought a stash",
        youHaveBoughtAStash = "You have bought a storage unit for "..Config.StoragePrice..""..Config.YourCurrencySymbol.." with "..Config.MoneyType,
        stashSoldFor = "You have sold your personal stash for: "..stashResoldFor.."$",
    },
    error = {
        stashNotAccessible = "For some reason stash is not accessible right now! Try again!",
        stashNotFound = "Sorry but your stash wasn't found in the database! Maybe you shall purchase one first!?",
        stashAlreadyPurchased = "You already have a storage unit!",
        stashNotFoundCannotBeSold = "You can't sell something you don't own!?",
    },
}

Config.croTranslation = {
    notificationPropperties = {
        length = 7500,
        notifTypeError = "error",
        notifTypeSuccess = "success",
    },
    target = {
        buyStashLabel = "Pristupi Prodaji Spremista",
        openStashLabel = "Pristupi ",
    },
    inputMenu = {
        header = "Stash Buy Menu",
        submitText = "Submit",
        storageNamePlaceholder = "Enter a Stash Name",
        storageNameInputName = "stashName", -- BEST LEFT DEFAULT -- MUST BE MUUUST BE UNIQUE AND NOT MENTIONED ANYWHERE ELSE SO THERE'S NO CONFLICT
        storageNameInputType = "text", -- BEST LEFT DEFAULT -- INPUT TYPE FOR THE QB-INPUT 
        storageNameIsRequired = true, -- DON'T MESS WITH THIS ONE IT's IMPORTANT THAT IT'S TRUE
    },
    menu = {
        StashShopBuyMenuHeader = "Stash Buy Menu",
        StashShopBuyMenuCloseMenu = "Close Menu",
        StashShopBuyMenuCloseMenuTxT = "",
        StashShopBuyMenuBuyStorage = "Buy Storage Unit",
        StashShopBuyMenuBuyStorageTxT = "Get yourself a neat place to keep your valuable items away from robbers",
        PersonalStashUnitHeader = "Personal Stash Unit",
        PersonalStashUnitStorageOptionsHeader = "Storage Options",
        PersonalStashUnitStorageOptionsHeaderTxt = "Open your personal stash unit",
        PersonalStorageUnitSellStorageHeader = "Sell Your Unit",
        PersonalStorageUnitSellStorageHeaderTxt = "Sell Your Personal Storage Unit and get "..resellPercentage.."% of the original Price!",
    },
    noMoney = {
        youDontHaveEnoughMoney = "Nemate dovoljno novca! Treba vam ukupno: "..Config.StoragePrice.." | "..moneyTypeCRO,
    },
    logs = {
        stashBought = "Player bought a stash!",
        stashPrice = "Price: ",
        stashBoughtStyle = true,
        player = "Player:",
        license = "License:",
        steam = "Steam:",
        discord = "DiscordId:",
        citizenid = "CitizenID:",
        firstName = "First Name:",
        lastName = "Last Name:",
        phone = "Phone Number:",
        cash = "Cash Balance:",
        bank = "Bank Balance:",
        crypto = "Crypto Balance:",
        job = "Player Job:",
        gang = "Player Gang:",
        sellStashDescription = "Player has sold their stash: ",
        sellStashDescription2 = "For: ",
    },
    
    success = {
        buyStashRMReason = "Bought a stash",
        youHaveBoughtAStash = "You have bought a storage unit for "..Config.StoragePrice..""..Config.YourCurrencySymbol.." with "..Config.MoneyType,
        stashSoldFor = "You have sold your personal stash for: "..stashResoldFor.."$",
    },
    error = {
        stashNotAccessible = "For some reason stash is not accessible right now! Try again!",
        stashNotFound = "Sorry but your stash wasn't found in the database! Maybe you shall purchase one first!?",
        stashAlreadyPurchased = "You already have a storage unit!",
        stashNotFoundCannotBeSold = "You can't sell something you don't own!?",
    },
}