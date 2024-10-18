local Itms = {}
local ItmsMap = {}

AddEventHandler("OnAllPluginsLoaded", function (event)
    config:Reload("shop/bhop")
    exports["shop-core"]:RegisterItems("bhop", "shop-bhop.menu.title", config:Fetch("shop.bhop.items"), true)
    Itms = config:Fetch("shop.bhop.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/bhop")
    exports["shop-core"]:RegisterItems("bhop", "shop-bhop.menu.title", config:Fetch("shop.bhop.items"), true)
    Itms = config:Fetch("shop.bhop.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("bhop")
end)

AddEventHandler("OnPostPlayerSpawn", function (event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end

    local items = exports["shop-core"]:GetItemsFromCategory(playerid, "bhop")
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
           player:SetBunnyhop(true)
        end
    end

end)

AddEventHandler("shop:core:ItemEquipStateChange", function (event, playerid, item_id, state)
    if not ItmsMap[item_id] then return end
    local player = GetPlayer(playerid)
    if not player then return end

    if state == false then
        player:SetBunnyhop(false)
    else
        for i=1,#Itms do
            if Itms[i].id == item_id then
                player:SetBunnyhop(true)
            end
        end
    end
end)