-- inject Inomena
local E, F, C = unpack(Inomena)
local _, private = ...
private[1] = E
private[2] = F
private[3] = C

-- setup for settings injection
C.Settings = {}
local function Initialize()
	for _, update in next, C.Settings do
		update()
	end

	F:Print('Successfully initialized settings')
	InomenaSettings = true
end

local function Decline()
	F:Print('Settings not initialized, you can do so later with /init')
	InomenaSettings = true
end

StaticPopupDialogs[string.upper(C.Name) .. '_INITIALIZE'] = {
	text = '|cffff6000' .. C.Name .. ':|r Load settings?',
	button1 = YES,
	button2 = NO,
	OnAccept = Initialize,
	OnCancel = Decline,
	timeout = 0
}

function E:PLAYER_LOGIN()
	if(not InomenaSettings) then
		StaticPopup_Show(string.upper(C.Name) .. '_INITIALIZE')
	end
end

F:RegisterSlash('/init', Initialize)
