local E, F, C = unpack(select(2, ...))

-- OPie and Alt modifier for mages
function E:ADDON_LOADED(addon)
	if(addon ~= 'OPie') then
		return
	end

	if(select(2, UnitClass('player')) ~= 'MAGE') then
		return true
	end

	-- Create and register a ring
	local macro = '/cast [mod:shift] {{spell:%d}}; {{spell:%d}}'
	local ring = {
		name=' Mage Portals and Teleports', limit='MAGE',

		-- Faction-agnostic
		{id = 193759, c = 'd000ff'}, -- Hall of the Guardian
		{id = macro:format(224871, 224869), c = '83ff61'}, -- Dalaran - Broken Isles
		{id = macro:format(53142, 53140), c = 'a54cff'}, -- Dalaran - Northrend
		{id = macro:format(120146, 120145), c = 'a54cff'}, -- Ancient Dalaran

		-- Horde-specific
		{id = macro:format(281402, 281404), c = 'f9e222'}, -- Dazar'alor
		{id = macro:format(176244, 176242), c = '00abf0'}, -- Warspear
		{id = macro:format(132626, 132627), c = 'ffc34d'}, -- Vale of Eternal Blossoms
		{id = macro:format(88346, 88344), c = 'f03c00'}, -- Tol Barad
		{id = macro:format(35717, 35715), c = '4dffc3'}, -- Shattrath
		{id = macro:format(49361, 49358), c = 'b0ff26'}, -- Stonard
		{id = macro:format(32267, 32272), c = 'f00e00'}, -- Silvermoon
		{id = macro:format(11420, 3566), c = '4cddff'}, -- Thunder Bluff
		{id = macro:format(11418, 3563), c = '88ff4d'}, -- Undercity
		{id = macro:format(11417, 3567), c = 'ff8126'}, -- Orgrimmar

		-- Alliance-specific
		{id = macro:format(281400, 281403), c = '21d2d5'}, -- Boralus
		{id = macro:format(176246, 176248), c = 'f03000'}, -- Stormshield
		{id = macro:format(132620, 132621), c = 'ffc34d'}, -- Vale of Eternal Blossoms
		{id = macro:format(88345, 88342), c = 'f03c00'}, -- Tol Barad
		{id = macro:format(33691, 33690), c = '4dffc3'}, -- Shattrath
		{id = macro:format(49360, 49359), c = 'f09d00'}, -- Theramore
		{id = macro:format(32266, 32271), c = 'f024e2'}, -- Exodar
		{id = macro:format(11419, 3565), c = '9d0df0'}, -- Darnassus
		{id = macro:format(11416, 3562), c = '6ecff0'}, -- Ironforge
		{id = macro:format(10059, 3561), c = '0d54f0'}, -- Stormwind
	}

	(OneRingLib and OneRingLib.ext and OneRingLib.ext.RingKeeper):SetRing('TelePortal', ring)

	return true
end

