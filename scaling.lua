local E, F, C = unpack(select(2, ...))

C.SizeMultiplier = 1

function E:PLAYER_LOGIN()
	local width, height = GetPhysicalScreenSize()
	if((768 / height) < (768 / 1200)) then
		-- Game can't scale further than 0.64
		-- Instead we change the UI scale to 1 and the UIParent scale to the correct one
		SetCVar('useuiscale', 1)
		SetCVar('uiscale', 1)

		local scale = 768 / height
		-- get a clean number at two decimal places to avoid weird backdrops
		scale = math.ceil(scale * 100 + 0.5) / 100
		UIParent:SetScale(scale)

		-- Multiplier to mimic 1080p scaling
		C.SizeMultiplier = 1080 / 768
	else
		SetCVar('useuiscale', 0)
	end
end
