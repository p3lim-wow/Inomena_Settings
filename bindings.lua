local E, F, C = unpack(select(2, ...))

-- Professions/artifact button
local Profession = CreateFrame('Button', C.Name .. 'ProfessionButton', nil, 'SecureActionButtonTemplate')
Profession:SetAttribute('type', 'spell')
function E:SKILL_LINES_CHANGED()
	if(not InCombatLockdown() and GetProfessions()) then
		Profession:SetAttribute('spell', GetProfessionInfo(GetProfessions()))
	end
end

local shown
Profession:HookScript('OnClick', function()
	if(AuctionFrame and AuctionFrame:IsShown()) then
		return
	end

	shown = not shown
	if(shown) then
		if(ArtifactFrame and ArtifactFrame:IsShown()) then
			HideUIPanel(ArtifactFrame)
		end
	else
		ArtifactFrame_LoadUI()
		SocketInventoryItem(16)
	end
end)

hooksecurefunc('CloseWindows', function()
	shown = false
end)

-- Eject passenger button
local Eject = CreateFrame('Button', C.Name .. 'EjectButton')
Eject:SetScript('OnClick', function()
	for index = 1, UnitVehicleSeatCount('player') do
		if(CanEjectPassengerFromSeat(index)) then
			EjectPassengerFromSeat(index)
		end
	end
end)

-- Reload UI button
local Reload = CreateFrame('Button', C.Name .. 'ReloadButton')
Reload:SetScript('OnClick', ReloadUI)

-- Hearthstone button
local Hearthstone = CreateFrame('Button', C.Name .. 'HearthstoneButton', nil, 'SecureActionButtonTemplate')
local function UpdateHearthstone()
	if(InCombatLockdown()) then
		return
	end

	if(PlayerHasToy(93672)) then
		-- Dark Portal
		Hearthstone:SetAttribute('type', 'toy')
		Hearthstone:SetAttribute('toy', 93672)
	elseif(PlayerHasToy(54452)) then
		-- Ethereal Portal
		Hearthstone:SetAttribute('type', 'toy')
		Hearthstone:SetAttribute('toy', 54452)

	elseif(PlayerHasToy(64488)) then
		-- The Innkeeper's Daughter
		Hearthstone:SetAttribute('type', 'toy')
		Hearthstone:SetAttribute('toy', 64488)
	else
		-- Hearthstone
		Hearthstone:SetAttribute('type', 'item')
		Hearthstone:SetAttribute('item', 6948)
	end
end

E:RegisterEvent('TOYS_UPDATED', UpdateHearthstone)

-- Bind keys
function E:PLAYER_LOGIN()
	UpdateHearthstone()

	SetBinding('END', 'DISMOUNT')
	SetBindingClick('SHIFT-`', Eject:GetName())
	SetBindingClick('F12', Reload:GetName())
	SetBindingClick('BACKSPACE', Profession:GetName())
	SetBindingClick('SHIFT-BACKSPACE', Hearthstone:GetName())
	SetBindingSpell('SHIFT-6', 'Garrison Ability')
	SetBindingSpell('CTRL-F', GetSpellInfo(80451))
end
