CreateClientConVar("funbox_showurl", "1", true)
CreateClientConVar("funbox_sizetype", "KB", true)
CreateClientConVar("funbox_sizedecimals", "0", true)
CreateConVar("funbox_allowweapons", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED)
CreateConVar("funbox_allowentities", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED)

local displayTypes = {{"Bytes", "B"}, {"Kilobytes", "KB"}, {"Megabytes", "MB"}, {"Gigabytes", "GB"}}

local function funboxSettings(CPanel)
	CPanel:AddControl("Header", {Description = "Client Settings"})

	CPanel:AddControl("CheckBox", {Label = "Show URL bar", Command = "funbox_showurl"})

	CPanel:AddControl("Header", {Description = "Shared Settings"})

	CPanel:AddControl("CheckBox", {Label = "Allow weapons", Command = "funbox_allowweapons"})

	CPanel:AddControl("CheckBox", {Label = "Allow entities", Command = "funbox_allowentities"})	

	CPanel:Button("Reload spawnmenu", "spawnmenu_reload")
end

local function funboxFormatSize(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

local function funboxAddons(CPanel)
	local displayTypesSingle = {}
	for k,v in pairs(displayTypes) do
		displayTypesSingle[k] = v[2]
	end

	if (!table.HasValue(displayTypesSingle, GetConVar("funbox_sizetype"):GetString())) then
		GetConVar("funbox_sizetype"):SetString("KB")
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
		format = GetConVar("funbox_sizetype"):GetString()
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
		for k,v in pairs(file.Find( "funbox/*.dat", "DATA" )) do
			opt[v] = funboxFormatSize(math.Round(file.Size("funbox/"..v, "DATA")/num, GetConVar("funbox_sizedecimals"):GetInt()))..format
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
	//table.RemoveByValue(displayTypesTmp, GetConVar("funbox_sizetype"):GetString())
	for k,v in pairs(displayTypes) do
		if (GetConVar("funbox_sizetype"):GetString() == v[2]) then
			lstBox:AddChoice(v[1], v[2], true)
		else
			lstBox:AddChoice(v[1], v[2])
		end
	end

	function lstBox:OnSelect(index, value, data)
		GetConVar("funbox_sizetype"):SetString(data)
	end

	CPanel:AddPanel(lstBox)



	CPanel:AddControl("Slider", {Label = "No. of decimals", Command = "funbox_sizedecimals", Type="Integer",  Min = 0, Max = 4})	



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
	spawnmenu.AddToolMenuOption("Utilities", "funbox", "funboxSettings", "Settings", "", "", funboxSettings)
	spawnmenu.AddToolMenuOption("Utilities", "funbox", "funboxAddons", "Addons", "", "", funboxAddons)
end
hook.Add("PopulateToolMenu", "funboxPopulateUtilityMenus", PopulateUtilityMenus)


local function CreateUtilitiesCategories()
	spawnmenu.AddToolCategory("Utilities", "funbox", "funbox")
end	
hook.Add("AddToolMenuCategories", "funboxCreateUtilitiesCategories", CreateUtilitiesCategories)