local triggerSymbol = "!"
local lobbyOwnerOnly = false
local k_eTFPartyChatType_MemberChat = 1
local steamid64Ident = 76561197960265728
local partyChatEventName = "party_chat"
local commands = {}

local function SteamID64ToSteamID3(steamId64)
    return "[U:1:" .. steamId64 - steamid64Ident .. "]"
end

local function SplitString(input, separator)
    separator = separator or "%s"
    local t = {}
    for str in string.gmatch(input, "([^" .. separator .. "]+)") do
            t[#t+1] = str
    end
    return t
end

local function Contains(table, element)
    return table.indexOf(table, element) ~= nil
end

local function FireGameEvent(event)
    if event:GetName() ~= partyChatEventName or event:GetInt("type") ~= k_eTFPartyChatType_MemberChat then
        return
    end

    local partyMessageText = event:GetString("text")
    if string.sub(partyMessageText, 1, 1) ~= triggerSymbol then
        return
    end

    if lobbyOwnerOnly and party.GetLeader() ~= SteamID64ToSteamID3(event:GetString("steamid")) then
        return
    end

    local fullCommand = string.sub(partyMessageText, 2)
    local commandArgs = SplitString(fullCommand)

    local commandName = commandArgs[1]
    local commandCallback = commands[commandName]

    if commandCallback == nil then
        return
    end

    table.remove(commandArgs, 1)
    commandCallback(commandArgs)
end

local function KillCommand(args)
    client.Command("kill", true)
end

local function ExplodeCommand(args)
    client.Command("explode", true)
end

local function Say(args)
    local msg = args[1]

    if not msg then
        Respond("Usage: " .. triggerSymbol .. "say <text>")
        return
    end

    client.Command("say " .. msg, true)
end

local function Leave(args)
	gamecoordinator.AbandonMatch(true)
end

local function FollowOn()
	gui.SetValue("Follow Bot", "Friends Only")
end

local function FollowOff()
	gui.SetValue("Follow Bot", "Off")
end

local function FollowAll()
	gui.SetValue("Follow Bot", "All Players")
end

local function ReadyUp()
	client.Command("player_ready_toggle", true)
end

local function AimOn()
	gui.SetValue("Aim Bot", "On")
end

local function AimOff()
	gui.SetValue("Aim Bot", "Off")
end

-- Registers new command.
local function RegisterCommand(commandName, callback)
    if commands[commandName] ~= nil then
        error("Command with name " .. commandName .. " was already registered!")
    end
    commands[commandName] = callback
end

local function Initialize()
    RegisterCommand("kill", KillCommand)
    RegisterCommand("explode", ExplodeCommand)
    RegisterCommand("say", Say)
    callbacks.Register("FireGameEvent", FireGameEvent)
    
	RegisterCommand("leave", Leave)
	RegisterCommand("followme", FollowOn)
	RegisterCommand("followoff", FollowOff)
	RegisterCommand("followall", FollowAll)
	RegisterCommand("ready", ReadyUp)
	RegisterCommand("aimon", AimOn)
	RegisterCommand("aimoff", AimOff)
end

Initialize()