local timer = 0
local interval = 0.5
 
local function bind()
    if timer <= globals.RealTime() and input.IsButtonDown(KEY_PAD_1) then
        timer = globals.RealTime() + interval
        AntiAimEnabled = not AntiAimEnabled
        gui.SetValue("Anti-Aim", AntiAimEnabled and 1 or 0)
    end
end
 
callbacks.Register("Draw", bind)