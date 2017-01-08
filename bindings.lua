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
			if(numSpells > 1) then
				if(profession == 7) then
					-- Herbalism
					name = GetSpellBookItemName(professionID + spellOffset, 'professions')
				end
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
	local macro = '/cast {{spell:%s}}'
	local ring = {
		name=' Mage Teleports', limit='MAGE',
		{id = 193759}, -- Hall of the Guardian
		{id = macro:format(224869)}, -- Dalaran - Broken Isles
		{id = macro:format(53140)}, -- Dalaran - Northrend
		{id = macro:format(120145)}, -- Ancient Dalaran
		{id = macro:format(132627)}, -- Vale of Eternal Blossoms
		{id = macro:format(88344)}, -- Tol Barad
		{id = macro:format(35715)}, -- Shattrath
		{id = macro:format('176242/176248')}, -- Warspear/Stormshield
		{id = macro:format('49358/49359')}, -- Stonard/Theramore
		{id = macro:format('32272/32271')}, -- Silvermoon/Exodar
		{id = macro:format('3566/3565')}, -- Thunder Bluff/Darnassus
		{id = macro:format('3563/3562')}, -- Undercity/Ironforge
		{id = macro:format('3567/3561')}, -- Orgrimmar/Stormwind
	}

	(OneRingLib and OneRingLib.ext and OneRingLib.ext.RingKeeper):SetRing('TelePortal', ring)

	-- Toggle the ring on alt modifier
	local Portals = CreateFrame('Frame', C.Name .. 'OPiePortals', UIParent, 'SecureHandlerStateTemplate')
	RegisterStateDriver(Portals, 'teleportal', '[mod:alt] TelePortal; nil')
	ORL_RTrigger:WrapScript(Portals, "OnAttributeChanged", [[
		if(name == 'state-teleportal') then
			if(value == 'TelePortal') then
				owner:Run(ORL_OpenClick, value)
			elseif(activeRing) then
				owner:Run(ORL_CloseActiveRing)
			end
		end
	]])

	return true
end

