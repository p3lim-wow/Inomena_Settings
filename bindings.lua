local E, F, C = unpack(select(2, ...))

-- Professions/artifact button
local Profession = CreateFrame('Button', C.Name .. 'ProfessionButton', nil, 'SecureActionButtonTemplate')
Profession:SetAttribute('type', 'spell')
function E:SKILL_LINES_CHANGED()
	local profession, secondProfession = GetProfessions()
	if(not InCombatLockdown()) then
		local professionID = 1
		if(not profession) then
			profession = secondProfession
			professionID = 2
		end

		if(profession) then
			local name, _, _, _, numSpells, spellOffset = GetProfessionInfo(profession)
			if(profession == 6) then
				-- Herbalism
				name = GetSpellBookItemName(professionID + spellOffset, 'professions')
			end

			Profession:SetAttribute('spell', name)
		end
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
	elseif(PlayerHasToy(142542)) then
		-- Tome of Town Portal
		Hearthstone:SetAttribute('type', 'toy')
		Hearthstone:SetAttribute('toy', 142542)
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

-- Petbattle select-pet overrides
local function SwitchPet()
	PetBattleFrame_PetSelectionFrameUpdateVisible(IsShiftKeyDown())
end

function E:PET_BATTLE_OPENING_START()
	E:RegisterEvent('MODIFIER_STATE_CHANGED', SwitchPet)
end

function E:PET_BATTLE_OVER()
	E:UnregisterEvent('MODIFIER_STATE_CHANGED', SwitchPet)
end

local function OnClick(self)
	if(C_PetBattles.CanPetSwapIn(self:GetID())) then
		C_PetBattles.ChangePet(self:GetID())
	end
end

local selectButtons = {}
for index = 1, NUM_BATTLE_PETS_IN_BATTLE do
	local Button = CreateFrame('Button', C.Name .. 'PetSelectButton' .. index)
	Button:SetScript('OnClick', OnClick)
	Button:SetID(index)

	selectButtons[index] = Button
end

PetBattleFrame.BottomFrame.PetSelectionFrame:HookScript('OnShow', function()
	for index = 1, NUM_BATTLE_PETS_IN_BATTLE do
		local Button = selectButtons[index]
		SetOverrideBindingClick(Button, true, 'SHIFT-' .. index, Button:GetName())
	end
end)

PetBattleFrame.BottomFrame.PetSelectionFrame:HookScript('OnHide', function()
	for index = 1, NUM_BATTLE_PETS_IN_BATTLE do
		ClearOverrideBindings(selectButtons[index])
	end
end)

-- OPie and Alt modifier for mages
function E:ADDON_LOADED(addon)
	if(addon ~= 'OPie') then
		return
	end

	if(select(2, UnitClass('player')) ~= 'MAGE') then
		return
	end

	-- Create and register a ring
	local macro = '/cast [mod:shift] {{spell:%s}}; {{spell:%s}}'
	local ring = {
		name=' Mage Portals and Teleports', limit='MAGE',
		{id = 193759, c = 'd000ff'}, -- Hall of the Guardian
		{id = macro:format(224871, 224869), c = '83ff61'}, -- Dalaran - Broken Isles
		{id = macro:format(53142, 53140), c = 'a54cff'}, -- Dalaran - Northrend
		{id = macro:format(120146, 120145), c = 'a54cff'}, -- Ancient Dalaran
		{id = macro:format(132626, 132627), c = 'ffc34d'}, -- Vale of Eternal Blossoms
		{id = macro:format(88346, 88344), c = 'f03c00'}, -- Tol Barad
		{id = macro:format(35717, 35715), c = '4dffc3'}, -- Shattrath

		{id = macro:format('176244', '176242'), c = '00abf0'}, -- Warspear
		{id = macro:format('49361', '49358'), c = 'b0ff26'}, -- Stonard
		{id = macro:format('32267', '32272'), c = 'f00e00'}, -- Silvermoon
		{id = macro:format('11420', '3566'), c = '4cddff'}, -- Thunder Bluff
		{id = macro:format('11418', '3563'), c = '88ff4d'}, -- Undercity
		{id = macro:format('11417', '3567'), c = 'ff8126'}, -- Orgrimmar

		{id = macro:format('176246', '176248'), c = 'f03000'}, -- Stormshield
		{id = macro:format('49360', '49359'), c = 'f09d00'}, -- Theramore
		{id = macro:format('32266', '32271'), c = 'f024e2'}, -- Exodar
		{id = macro:format('11419', '3565'), c = '9d0df0'}, -- Darnassus
		{id = macro:format('11416', '3562'), c = '6ecff0'}, -- Ironforge
		{id = macro:format('10059', '3561'), c = '0d54f0'}, -- Stormwind
	}

	(OneRingLib and OneRingLib.ext and OneRingLib.ext.RingKeeper):SetRing('TelePortal', ring)

	return true
end

