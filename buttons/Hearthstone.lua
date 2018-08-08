local E, F, C = unpack(select(2, ...))

local toys = {}
local hearthstoneToys = {
	93672, -- Dark Portal
	54452, -- Ethereal Portal
	142542, -- Tome of Town Portal
	64488, -- The Innkeeper's Daughter
	163045, -- Headless Horeseman's Hearthstone
	162973, -- Greatfather Winter's Hearthstone
}

local Button = CreateFrame('Button', C.Name .. 'HearthstoneButton', nil, 'SecureActionButtonTemplate')

function E:TOYS_UPDATED()
	if(InCombatLockdown()) then
		return
	end

	local toys = ''
	for _, itemID in next, hearthstoneToys do
		if(PlayerHasToy(itemID)) then
			toys = toys .. 'item:' .. itemID .. ', '
		end
	end

	if(#toys > 0) then
		-- Pick a random toy
		Button:SetAttribute('type', 'macro')
		Button:SetAttribute('macrotext', '/castrandom ' .. strtrim(toys, ', '))
	else
		-- Hearthstone
		Button:SetAttribute('type', 'item')
		Button:SetAttribute('item', 6948)
	end
end
