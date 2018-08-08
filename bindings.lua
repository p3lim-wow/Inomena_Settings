local E, F, C = unpack(select(2, ...))

-- Bind keys
function E:PLAYER_LOGIN()
	SetBinding('END', 'DISMOUNT')
	SetBindingClick('SHIFT-`', C.Name .. 'EjectButton')
	SetBindingClick('F12', C.Name .. 'ReloadButton')
	SetBindingClick('BACKSPACE', C.Name .. 'ProfessionButton')
	SetBindingClick('SHIFT-BACKSPACE', C.Name .. 'HearthstoneButton')
	SetBindingSpell('CTRL-F', GetSpellInfo(80451))
end
