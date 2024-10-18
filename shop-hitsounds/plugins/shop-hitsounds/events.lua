local Itms = {}
local ItmsMap = {}


AddEventHandler("OnAllPluginsLoaded", function (event)
    config:Reload("shop/hitsounds")
    exports["shop-core"]:RegisterItems("hitsounds", "shop-hitsounds.menu.title", config:Fetch("shop.hitsounds.items"), true)
    Itms = config:Fetch("shop.hitsounds.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/hitsounds")
    exports["shop-core"]:RegisterItems("hitsounds", "shop-hitsounds.menu.title", config:Fetch("shop.hitsounds.items"), true)
    Itms = config:Fetch("shop.hitsounds.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("hitsounds")
end)

AddEventHandler("OnPlayerHurt", function (event)
    local playerid = event:GetInt("userid")
    local attackerid = event:GetInt("attacker")
    local player = GetPlayer(playerid)
    local attacker = GetPlayer(attackerid)
    if not attacker then return EventResult.Continue end

    local items = exports["shop-core"]:GetItemsFromCategory(attackerid, "hitsounds")
    local item = nil
    for i=1,#items do
        if exports["shop-core"]:HasItemEquipped(attackerid, items[i]) then
            item = items[i]
            break
        end
    end
    if not item then return end

    for i = 1, #Itms do
        if Itms[i].id == item then
            NextTick(function()
                attacker:ExecuteCommand("play " .. Itms[i].value)
            end)
        end
    end

end)