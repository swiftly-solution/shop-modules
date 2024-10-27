local Itms = {}
local ItmsMap = {}

AddEventHandler("OnAllPluginsLoaded", function (event)
    config:Reload("shop/antiflash")
    exports["shop-core"]:RegisterItems("antiflash", "shop-antiflash.menu.title", config:Fetch("shop.antiflash.items"), true)
    Itms = config:Fetch("shop.antiflash.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/antiflash")
    exports["shop-core"]:RegisterItems("antiflash", "shop-antiflash.menu.title", config:Fetch("shop.antiflash.items"), true)
    Itms = config:Fetch("shop.antiflash.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("antiflash")
end)

AddEventHandler("OnPlayerBlind", function (event)
    local playerid = event:GetInt("attacker")
    local player = GetPlayer(playerid)
    if not player then return end

    local items = exports["shop-core"]:GetItemsFromCategory(playerid, "antiflash")
    local item = nil
    for i=1,#items do
        if exports["shop-core"]:HasItemEquipped(playerid, items[i]) then
            item = items[i]
            break
        end
    end
    if not item then return end

    for i=1,#Itms do
        if Itms[i].id == item then
            if not player:CCSPlayerPawnBase():IsValid() then return end
            player:CCSPlayerPawnBase().BlindUntilTime = server:GetCurrentTime()
        end
    end
end)
