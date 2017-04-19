CreateClientConVar("toybox_showurl", "1", true)
CreateClientConVar("toybox_sizetype", "KB", true)
CreateClientConVar("toybox_sizedecimals", "0", true)
CreateConVar("toybox_allowweapons", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED)
CreateConVar("toybox_allowentities", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED)

local displayTypes = {{"Bytes", "B"}, {"Kilobytes", "KB"}, {"Megabytes", "MB"}, {"Gigabytes", "GB"}}

local function ToyboxSettings(CPanel)
	CPanel:AddControl("Header", {Description = "Client Settings"})

	CPanel:AddControl("CheckBox", {Label = "Show URL bar", Command = "toybox_showurl"})

	CPanel:AddControl("Header", {Description = "Shared Settings"})

	CPanel:AddControl("CheckBox", {Label = "Allow weapons", Command = "toybox_allowweapons"})

	CPanel:AddControl("CheckBox", {Label = "Allow entities", Command = "toybox_allowentities"})	

	CPanel:Button("Reload spawnmenu", "spawnmenu_reload")
end

local function ToyboxFormatSize(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

local function ToyboxAddons(CPanel)
	local displayTypesSingle = {}
	for k,v in pairs(displayTypes) do
		displayTypesSingle[k] = v[2]
	end

	if (!table.HasValue(displayTypesSingle, GetConVar("toybox_sizetype"):GetString())) then
		GetConVar("toybox_sizetype"):SetString("KB")
	end

	CPanel:AddControl("Header", {Description = "Downloaded addons"})

	local ctrl = vgui.Create("DListView")
	ctrl:SetMultiSelect(false)
	ctrl:AddColumn("Filename")
	ctrl:AddColumn("Filesize")

	local format = ""
	local num = 0
	local opt = {}
	function ctrl:UpdateValues()
		format = GetConVar("toybox_sizetype"):GetString()
		num = (tonumber(table.KeyFromValue(displayTypesSingle, format))-1)

		if (num <= 0) then
			num = 1
		elseif(num ~= 1) then
			local tmpNum = 1024
			for i=1,(num-1) do
				tmpNum = tmpNum*1024
			end
			num = tmpNum
		else
			num = 1024
		end

		opt = {}
		for k,v in pairs(file.Find( "toybox/*.dat", "DATA" )) do
			opt[v] = ToyboxFormatSize(math.Round(file.Size("toybox/"..v, "DATA")/num, GetConVar("toybox_sizedecimals"):GetInt()))..format
		end
	end
	ctrl:UpdateValues()

	function ctrl:CreateItems()
		if (opt) then
			for k, v in pairs(opt) do
				local line = ctrl:AddLine(k, v)
			end	
		end

		ctrl:SortByColumn(1, false)
	end
	ctrl:CreateItems()
	
	ctrl:SetTall("300")
	CPanel:AddPanel(ctrl)



	local lstBox = vgui.Create("DComboBox")

	//local displayTypesTmp = displayTypes
	//table.RemoveByValue(displayTypesTmp, GetConVar("toybox_sizetype"):GetString())
	for k,v in pairs(displayTypes) do
		if (GetConVar("toybox_sizetype"):GetString() == v[2]) then
			lstBox:AddChoice(v[1], v[2], true)
		else
			lstBox:AddChoice(v[1], v[2])
		end
	end

	function lstBox:OnSelect(index, value, data)
		GetConVar("toybox_sizetype"):SetString(data)
	end

	CPanel:AddPanel(lstBox)



	CPanel:AddControl("Slider", {Label = "No. of decimals", Command = "toybox_sizedecimals", Type="Integer",  Min = 0, Max = 4})	



	local btnRefresh = vgui.Create("DButton")
	btnRefresh:SetText("Refresh list")

	function btnRefresh:DoClick()
		ctrl:Clear()
		ctrl:UpdateValues()
		ctrl:CreateItems()
	end

	CPanel:AddPanel(btnRefresh)
end


local function PopulateUtilityMenus()
	spawnmenu.AddToolMenuOption("Utilities", "Toybox", "ToyboxSettings", "Settings", "", "", ToyboxSettings)
	spawnmenu.AddToolMenuOption("Utilities", "Toybox", "ToyboxAddons", "Addons", "", "", ToyboxAddons)
end
hook.Add("PopulateToolMenu", "ToyboxPopulateUtilityMenus", PopulateUtilityMenus)


local function CreateUtilitiesCategories()
	spawnmenu.AddToolCategory("Utilities", "Toybox", "Toybox")
end	
hook.Add("AddToolMenuCategories", "ToyboxCreateUtilitiesCategories", CreateUtilitiesCategories)