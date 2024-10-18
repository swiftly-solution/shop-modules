local Itms = {}
local ItmsMap = {}

AddEventHandler("OnAllPluginsLoaded", function (event)
    config:Reload("shop/killscreen")
    exports["shop-core"]:RegisterItems("killscreen", "shop-killscreen.menu.title", config:Fetch("shop.killscreen.items"), true)
    Itms = config:Fetch("shop.killscreen.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/killscreen")
    exports["shop-core"]:RegisterItems("killscreen", "shop-killscreen.menu.title", config:Fetch("shop.killscreen.items"), true)
    Itms = config:Fetch("shop.killscreen.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("killscreen")
end)

AddEventHandler("OnPlayerDeath", function (event)
    local attackerid = event:GetInt("attacker")
    local attacker = GetPlayer(attackerid)
    if not attacker then return end

    local items = exports["shop-core"]:GetItemsFromCategory(attackerid, "killscreen")
    local item = nil
    for i=1,#items do
        if exports["shop-core"]:HasItemEquipped(attackerid, items[i]) then
            item = items[i]
            break
        end
    end
    if not item then return end

    for i=1,#Itms do
        if Itms[i].id == item then
            if not attacker:CCSPlayerPawn():IsValid() then return end
            attacker:CCSPlayerPawn().HealthShotBoostExpirationTime = server:GetCurrentTime() + 1
        end
    end
end)