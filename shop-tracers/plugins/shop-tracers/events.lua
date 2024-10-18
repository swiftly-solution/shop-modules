local Itms = {}
local ItmsMap = {}


AddEventHandler("OnAllPluginsLoaded", function (event)
    Itms = config:Fetch("shop.tracers.items")
    for i=1, #Itms do
        precacher:PrecacheModel(Itms[i].model)
        ItmsMap[Itms[i].id] = true
    end
    config:Reload("shop/tracers")
    exports["shop-core"]:RegisterItems("tracers", "shop-tracers.menu.title", config:Fetch("shop.tracers.items"), true)
end)

AddEventHandler("shop:core:RegisterItems", function (event)
    config:Reload("shop/tracers")
    exports["shop-core"]:RegisterItems("tracers", "shop-tracers.menu.title", config:Fetch("shop.tracers.items"), true)
    Itms = config:Fetch("shop.tracers.items")
    for i=1,#Itms do
        ItmsMap[Itms[i].id] = true
    end
end)

AddEventHandler("OnPluginStop", function (event)
    exports["shop-core"]:UnregisterItems("tracers")
end)

AddEventHandler("OnBulletImpact", function (event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end

    local items = exports["shop-core"]:GetItemsFromCategory(playerid, "tracers")
    local item = nil
    for i=1,#items do
        if exports["shop-core"]:HasItemEquipped(playerid, items[i]) then
            item = items[i]
            break
        end
    end
    if not item then return end

    for i=1, #Itms do
        if Itms[i].id == item then
            local beamModel = Itms[i].model

            local beam = CBeam(CreateEntityByName("beam"):ToPtr())
            if not beam:IsValid() then return end
            CBaseModelEntity(beam:ToPtr()):SetModel(beamModel)
            local baseentity = CBaseEntity(beam:ToPtr())
            baseentity:Spawn()
            baseentity:AcceptInput("Start", CEntityInstance("0x0"), CEntityInstance("0x0"), "", 0)

            local playerCBaseEntity = CBaseEntity(player:CCSPlayerPawn():ToPtr())
            if not playerCBaseEntity:IsValid() then return end

            local playerCoords = playerCBaseEntity.CBodyComponent.SceneNode.AbsOrigin
            local cameraService = player:CBasePlayerPawn().CameraServices

            local eyePosition = Vector(playerCoords.x, playerCoords.y, playerCoords.z + cameraService.OldPlayerViewOffsetZ)
            baseentity:Teleport(eyePosition, QAngle(0.0, 0.0, 0.0))
            beam.EndPos = Vector(event:GetFloat("x"), event:GetFloat("y"), event:GetFloat("z"))

            local colors = string.split(Itms[i].value, ",")
            local colorObj = Color(colors[1], colors[2], colors[3], colors[4])
            beam.Parent.Render = colorObj

            SetTimeout(500, function ()
                if baseentity and baseentity:IsValid() then
                    baseentity:Despawn()
                end
            end)
        end
    end
end)