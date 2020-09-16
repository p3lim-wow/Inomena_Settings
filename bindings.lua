local E, F, C = unpack(select(2, ...))

-- Bind keys
function E:PLAYER_LOGIN()
	SetBinding('END', 'DISMOUNT')
	SetBindingClick('SHIFT-`', C.Name .. 'EjectButton')
	SetBindingClick('F12', C.Name .. 'ReloadButton')
	SetBindingClick('BACKSPACE', C.Name .. 'ProfessionButton')
	SetBindingClick('SHIFT-BACKSPACE', C.Name .. 'HearthstoneButton')
	SetBindingSpell('CTRL-F', GetSpellInfo(80451)) -- Survey, Archaelogy
end

local function TalentTree()
	PlayerTalentTab_OnClick(_G['PlayerTalentFrameTab' .. TALENTS_TAB])
end

function E:ADDON_LOADED(addon)
	if(addon == 'Blizzard_TalentUI') then
		hooksecurefunc('PlayerTalentFrame_Toggle', TalentTree)
	end
end
