local Itms = {}
local ItmsMap = {}


AddEventHandler("OnAllPluginsLoaded", function (event)
    Itms = config:Fetch("shop.smokecolor.items")
    for i=1, #Itms do
        precacher:PrecacheModel(Itms[i].model)
        ItmsMap[Itms[i].id] = true
    end
    config:Reload("shop/smokecolor")
    exports["shop-core"]:RegisterItems("smokecolor", "shop-smokecolor.menu.title", config:Fetch("shop.smokecolor.items"), true)
    precacher:PrecacheModel("particles/particle_1.vpcf")
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/smokecolor")
    exports["shop-core"]:RegisterItems("smokecolor", "shop-smokecolor.menu.title", config:Fetch("shop.smokecolor.items"), true)
    Itms = config:Fetch("shop.smokecolor.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("smokecolor")
end)

AddEventHandler("OnEntitySpawned", function(event, entityptr --[[ string ]])

    local entityInstance = CEntityInstance(entityptr)
    local entityBase = CBaseEntity(entityInstance:ToPtr())

    if entityInstance == nil or not entityInstance:IsValid() then
        return EventResult.Continue
    end
    if entityBase == nil or not entityBase:IsValid() then
        return EventResult.Continue
    end

    if entityInstance.Entity.DesignerName ~= "smokegrenade_projectile" then
        return EventResult.Continue
    end

    if entityInstance.Entity.DesignerName == "smokegrenade_projectile" then
        local player = FindPlayerByPointer(CBaseEntity(entityptr).OwnerEntity:ToPtr())
        if not player then
            return
        end
        local playerid = player:GetSlot()

        local items = exports["shop-core"]:GetItemsFromCategory(playerid, "smokecolor")
        local item = nil
        for i = 1, #items do
            if exports["shop-core"]:HasItemEquipped(playerid, items[i]) then
                item = items[i]
                break
            end
        end
        if not item then return end

        for i = 1, #Itms do
            if Itms[i].id == item then
                local colors = string.split(Itms[i].value, ",")

                local entitySmokeProjectile = CSmokeGrenadeProjectile(entityBase:EHandle():ToPtr())

                if entitySmokeProjectile == nil or not entitySmokeProjectile:IsValid() then
                    return EventResult.Continue
                end
                

                NextTick(function()
                    entitySmokeProjectile.SmokeColor = Vector((tonumber(colors[1]) or 255) + 0.0, (tonumber(colors[2]) or 255) + 0.0, (tonumber(colors[3]) or 255) + 0.0)
                end)
            end
        end
    end
end)

