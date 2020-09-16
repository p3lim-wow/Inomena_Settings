local E, F, C = unpack(select(2, ...))

local toys = {}
local hearthstoneToys = {
	93672, -- Dark Portal
	54452, -- Ethereal Portal
	142542, -- Tome of Town Portal
	64488, -- The Innkeeper's Daughter
	163045, -- Headless Horeseman's Hearthstone
	162973, -- Greatfather Winter's Hearthstone
	165669, -- Lunar Elder's Hearthstone
	166747, -- Brewfest Reveler's Hearthstone
	166746, -- Fire Eater's Hearthstone
	168907, -- Holographic Digitalization Hearthstone
	165802, -- Noble Gardener's Hearthstone
	165670, -- Peddlefeet's Lovely Hearthstone
	172179, -- Eternal Traveler's Hearthstone
}

local Button = CreateFrame('Button', C.Name .. 'HearthstoneButton', nil, 'SecureActionButtonTemplate')
Button:SetAttribute('type', 'macro') -- item doesn't like modifications in PreClick
Button:SetScript('PreClick', function()
	if(InCombatLockdown()) then
		return
	end

	table.wipe(toys)
	for _, itemID in next, hearthstoneToys do
		if(PlayerHasToy(itemID)) then
			table.insert(toys, itemID)
		end
	end

	if(#toys > 0) then
		-- Pick a random toy
		Button:SetAttribute('macrotext', '/cast item:' .. toys[math.random(#toys)])
		-- /castrandom is broken, has been for years
	else
		-- Hearthstone
		Button:SetAttribute('macrotext', '/cast item:' .. 6948)
	end
end)
