local me = entities.GetLocalPlayer()

local IN_ATTACK2 = 1 << 11
local DELAY_TIME = 0.2

local function onCreateMove(cmd)
    local ActivateThreshold = 0.50 --EDIT THIS NUMBER TO ADJUST AT WHICH HEALTH PERCENTAGE DEADRINGER IS ACTIVATED

    local healthRatio = me:GetHealth() / me:GetMaxHealth()

    if skipHealthCheck then
        if os.clock() > skipHealthCheckTime then
            skipHealthCheck = false
        else
            return
        end
    end

    if healthRatio < ActivateThreshold then
        cmd.buttons = cmd.buttons | IN_ATTACK2
        attack2timer = os.clock() + DELAY_TIME
        skipHealthCheck = true
        skipHealthCheckTime = os.clock() + 5.0
    end

    if os.clock() > attack2timer then
        cmd.buttons = cmd.buttons & ~IN_ATTACK2
    end
end

callbacks.Register("CreateMove", onCreateMove)
