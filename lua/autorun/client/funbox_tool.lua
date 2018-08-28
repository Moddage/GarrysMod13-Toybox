CreateClientConVar("Funbox_showurl", "1", true)
CreateClientConVar("Funbox_sizetype", "KB", true)
CreateClientConVar("Funbox_sizedecimals", "0", true)
CreateClientConVar("Funbox_key", "", true)
CreateConVar("Funbox_allowweapons", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED)
CreateConVar("Funbox_allowentities", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED)
CreateConVar("Funbox_allowprops", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED)

local displayTypes = {{"Bytes", "B"}, {"Kilobytes", "KB"}, {"Megabytes", "MB"}, {"Gigabytes", "GB"}}

local function FunboxSettings(CPanel)
	CPanel:AddControl("Header", {Description = "Client Settings"})

	CPanel:AddControl("CheckBox", {Label = "Show URL bar", Command = "Funbox_showurl"})

	CPanel:AddControl("Header", {Description = "Shared Settings"})

	CPanel:AddControl("CheckBox", {Label = "Allow weapons", Command = "Funbox_allowweapons"})

	CPanel:AddControl("CheckBox", {Label = "Allow entities", Command = "Funbox_allowentities"})	

    CPanel:AddControl("TextBox", {Label = "Funbox key", Command = "Funbox_key", Type="String",  Min = 0, Max = 32})

	CPanel:Button("Reload spawnmenu", "spawnmenu_reload")
end

local function FunboxFormatSize(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

local function FunboxAddons(CPanel)
	local displayTypesSingle = {}
	for k,v in pairs(displayTypes) do
		displayTypesSingle[k] = v[2]
	end

	if (!table.HasValue(displayTypesSingle, GetConVar("Funbox_sizetype"):GetString())) then
		GetConVar("Funbox_sizetype"):SetString("KB")
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
		format = GetConVar("Funbox_sizetype"):GetString()
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
		for k,v in pairs(file.Find( "Funbox/*.dat", "DATA" )) do
			opt[v] = FunboxFormatSize(math.Round(file.Size("Funbox/"..v, "DATA")/num, GetConVar("Funbox_sizedecimals"):GetInt()))..format
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
	//table.RemoveByValue(displayTypesTmp, GetConVar("Funbox_sizetype"):GetString())
	for k,v in pairs(displayTypes) do
		if (GetConVar("Funbox_sizetype"):GetString() == v[2]) then
			lstBox:AddChoice(v[1], v[2], true)
		else
			lstBox:AddChoice(v[1], v[2])
		end
	end

	function lstBox:OnSelect(index, value, data)
		GetConVar("Funbox_sizetype"):SetString(data)
	end

	CPanel:AddPanel(lstBox)



	CPanel:AddControl("Slider", {Label = "No. of decimals", Command = "Funbox_sizedecimals", Type="Integer",  Min = 0, Max = 4})	



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
	spawnmenu.AddToolMenuOption("Utilities", "Funbox", "FunboxSettings", "Settings", "", "", FunboxSettings)
	spawnmenu.AddToolMenuOption("Utilities", "Funbox", "FunboxAddons", "Addons", "", "", FunboxAddons)
end
hook.Add("PopulateToolMenu", "FunboxPopulateUtilityMenus", PopulateUtilityMenus)


local function CreateUtilitiesCategories()
	spawnmenu.AddToolCategory("Utilities", "Funbox", "Funbox")
end	
hook.Add("AddToolMenuCategories", "FunboxCreateUtilitiesCategories", CreateUtilitiesCategories)