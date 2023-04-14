local function onCreateMove( cmd )

    local ActivateThreshold = 0.50 -- EDIT THIS NUMBER TO CHANGE AT WHAT HEALTH PERCENTAGE DEAD RINGER IS ACTIVATED

    local me = entities.GetLocalPlayer()
    local health = me:GetHealth()
    local maxHealth = me:GetMaxHealth()
    local healthRatio = (health / maxHealth)

    if skipHealthCheck then
        if os.clock() > skipHealthCheckTime then
            skipHealthCheck = false
        else
            return
        end
    end

    if healthRatio < ActivateThreshold then
        cmd.buttons = cmd.buttons | IN_ATTACK2
        attack2timer = os.clock() + 0.2
        skipHealthCheck = true
        skipHealthCheckTime = os.clock() + 5.0
    end

    if os.clock() > attack2timer then
        cmd.buttons = cmd.buttons & ~IN_ATTACK2
    end
end

callbacks.Register( "CreateMove", onCreateMove )
