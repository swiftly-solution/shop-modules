local Itms = {}
local ItmsMap = {}

AddEventHandler("OnAllPluginsLoaded", function (event)
    config:Reload("shop/speed")
    exports["shop-core"]:RegisterItems("speed", "shop-speed.menu.title", config:Fetch("shop.speed.items"), true)
    Itms = config:Fetch("shop.speed.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/speed")
    exports["shop-core"]:RegisterItems("speed", "shop-speed.menu.title", config:Fetch("shop.speed.items"), true)
    Itms = config:Fetch("shop.speed.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("speed")
end)

AddEventHandler("OnPostPlayerSpawn", function (event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end

    local items = exports["shop-core"]:GetItemsFromCategory(playerid, "speed")
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
            local speed = Itms[i].value
            NextTick(function()
                if not player:CCSPlayerPawn():IsValid() then return end
                player:CCSPlayerPawn().VelocityModifier = (speed)
                playermanager:SendMsg(MessageType.Chat, "Speed is: " .. player:CCSPlayerPawn().VelocityModifier)
            end)
        end
    end
end)

AddEventHandler("shop:core:ItemEquipStateChange", function (event, playerid, item_id, state)
    if not ItmsMap[item_id] then return end
    local player = GetPlayer(playerid)
    if not player then return end

    if state == false then
        player:CCSPlayerPawn().VelocityModifier = (1.0)
    else
        for i=1,#Itms do
            if Itms[i].id == item_id then
                local speed = Itms[i].value
                if not player:CCSPlayerPawn():IsValid() then return end
                player:CCSPlayerPawn().VelocityModifier = (speed)
                print("modifying speed to: " .. speed)
            end
        end
    end
end)
