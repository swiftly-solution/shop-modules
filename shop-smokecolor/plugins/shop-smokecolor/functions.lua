function FindPlayerByPointer(ptr)
    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i - 1)
        if player then
            if not player:IsFakeClient() then
                if player:CBaseEntity():ToPtr() == ptr then
                    return player
                end
            end
        end
    end
    return nil
end