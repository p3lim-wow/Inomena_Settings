local E, F, C = unpack(select(2, ...))

CreateFrame('Button', C.Name .. 'EjectButton'):SetScript('OnClick', function()
	for index = 1, UnitVehicleSeatCount('player') do
		if(CanEjectPassengerFromSeat(index)) then
			EjectPassengerFromSeat(index)
		end
	end
end)
