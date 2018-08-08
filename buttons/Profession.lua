local E, F, C = unpack(select(2, ...))

local offsets = {
	[182] = 1, -- Herbalism
	[186] = 1, -- Mining
	[393] = 1, -- Skinning
}

local Button = CreateFrame('Button', C.Name .. 'ProfessionButton', nil, 'SecureActionButtonTemplate')
Button:SetAttribute('type', 'spell')

function E:SKILL_LINES_CHANGED()
	if(InCombatLockdown()) then
		return
	end

	local profession, secondaryProfession = GetProfessions()
	local professionID = 1
	if(not profession) then
		profession = secondaryProfession
		professionID = 2
	end

	if(profession) then
		local name, _, _, _, numSpells, spellOffset, skillID = GetProfessionInfo(profession)
		local offset = offsets[skillID]
		if(offset) then
			name = GetSpellBookItemName(offset + spellOffset, 'professions')
		end

		Button:SetAttribute('spell', name)
	end
end
