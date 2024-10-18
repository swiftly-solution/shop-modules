local Itms = {}
local ItmsMap = {}

AddEventHandler("OnAllPluginsLoaded", function (event)
    config:Reload("shop/name-colors")
    exports["shop-core"]:RegisterItems("name-colors", "shop-name-colors.menu.title", config:Fetch("shop.name-colors.items"), true)
    Itms = config:Fetch("shop.name-colors.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/name-colors")
    exports["shop-core"]:RegisterItems("name-colors", "shop-name-colors.menu.title", config:Fetch("shop.name-colors.items"), true)
    Itms = config:Fetch("shop.name-colors.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("name-colors")
    ItmsMap = {}
end)

AddEventHandler("OnPlayerSpawn", function (event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end

    local items = exports["shop-core"]:GetItemsFromCategory(playerid, "name-colors")
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
            player:SetNameColor(Itms[i].value)
        end
    end
end)

AddEventHandler("shop:core:ItemEquipStateChange", function (event, playerid, item_id, state)
    if not ItmsMap[item_id] then return end
    local player = GetPlayer(playerid)
    if not player then return end

    if state == false then
        player:SetNameColor("{TEAMCOLOR}")
    else
        for i=1,#Itms do
            if Itms[i].id == item_id then
                player:SetNameColor(Itms[i].value)
            end
        end
    end
end)