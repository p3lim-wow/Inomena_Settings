local E, F, C = unpack(select(2, ...))

CreateFrame('Button', C.Name .. 'ReloadButton'):SetScript('OnClick', ReloadUI)
