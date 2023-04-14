local timer = 0
local interval = 0.3

local function bind()
    if timer <= globals.RealTime() and input.IsButtonDown(MOUSE_5) then
        timer = globals.RealTime() + interval
        noisemakerSpamEnabled = not noisemakerSpamEnabled
        gui.SetValue("Noisemaker Spam", noisemakerSpamEnabled and 1 or 0)
    end
end

callbacks.Register("Draw", bind)