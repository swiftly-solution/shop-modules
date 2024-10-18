local Itms = {}
local ItmsMap = {}

AddEventHandler("OnAllPluginsLoaded", function (event)
    config:Reload("shop/nametags")
    exports["shop-core"]:RegisterItems("nametags", "shop-name-tags.menu.title", config:Fetch("shop.nametags.items"), true)
    Itms = config:Fetch("shop.nametags.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/nametags")
    exports["shop-core"]:RegisterItems("nametags", "shop-name-tags.menu.title", config:Fetch("shop.nametags.items"), true)
    Itms = config:Fetch("shop.nametags.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("nametags")
end)

AddEventHandler("OnPlayerSpawn", function (event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end

    local items = exports["shop-core"]:GetItemsFromCategory(playerid, "nametags")
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
            player:SetChatTag(Itms[i].value)
        end
    end
end)

    AddEventHandler("shop:core:ItemEquipStateChange", function (event, playerid, item_id, state)
        if not ItmsMap[item_id] then return end
        local player = GetPlayer(playerid)
        if not player then return end

        if state == false then
            player:SetChatTag("")
        else
            for i=1,#Itms do
                if Itms[i].id == item_id then
                    player:SetChatTag(Itms[i].value)
                end
            end
        end
    end)