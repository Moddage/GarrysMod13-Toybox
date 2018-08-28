local PrefixColor = Color(64, 150, 238)
local MainColor = Color(54, 57, 61)
local ErrorColor = Color(255, 0, 0)
local HighlightColor = Color(230, 126, 34)

function FunboxPrint(...)
	if CLIENT then
	--[[	local vargs = {...}

		local cmdStr = 'chat.AddText(Color('..PrefixColor.r..', '..PrefixColor.g..', '..PrefixColor.b..', '..PrefixColor.a..'), "Funbox: ", Color('..MainColor.r..', '..MainColor.g..', '..MainColor.b..', '..MainColor.a..'), '
		for k,v in pairs(vargs) do
			if (IsColor(v)) then
				cmdStr = cmdStr.."Color("..v.r..", "..v.g..", "..v.b..", "..v.a.."), "
			else
				cmdStr = cmdStr.."\""..v.."\", "
			end
		end

		if (string.EndsWith(cmdStr, ", ")) then
			cmdStr = string.Trim(cmdStr, " ")
			cmdStr = string.Trim(cmdStr, ",")
		end
		cmdStr = cmdStr..")"

		RunString(cmdStr)]]
	end
end

function FunboxDownload(id, user, name)
	print(id)
	print(user)
	print(name)
	//Check for addon existing
	if (file.Exists("Funbox/"..id..".dat", "DATA")) then
	--	FunboxPrint("Allready downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		FunboxPreLoadDat(id)
	else
		//Show a gui here

	--	FunboxPrint("Attempting to download addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		FunboxDownloadHttp(id, user, name)
	end
end

function FunboxDownloadHttp(id, user, name)
	http.Fetch("https://lethaldirect.site.nfoservers.com/client/download.php?id="..id,
		function(body, len, headers, code)
			if (body ~= "Unknown addon") then
		--		FunboxPrint("Downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
				if (file.Exists("Funbox", "DATA") == false) then
					file.CreateDir("Funbox")
				end
				file.Write("Funbox/"..id..".dat", body)

		--		FunboxPrint("Saved addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " as "..id..".dat")

				FunboxPreLoadDat(id)
			else
		--		FunboxPrint(ErrorColor, "Error: ", MainColor, "No addon file")
			end
		end,
		function(error)
			--FunboxPrint(ErrorColor, "Error: ", MainColor, "Download for addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " failed ("..error..")")
		--	FunboxPrint("Retrying the download for ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
			FunboxDownloadHttp(id, user, name)
		end
	)
end

function FunboxPreLoadDat(id)
	net.Start("FunboxLoadGMA")
		net.WriteString(id)
	net.SendToServer()
	timer.Simple(1, function()
		FunboxLoadDat(id)
	end)	
end

local function FunboxCheckForGma(id)
	if game.GetWorld():GetTable().FunboxGMADownloads == nil then
	local FunboxGMADownloads={}
        game.GetWorld():GetTable().FunboxGMADownloads = {"empty"}
	end
	if game.GetWorld():GetTable().FunboxGMADownloadsFiles == nil then
	local FunboxGMADownloadsFiles={}
        game.GetWorld():GetTable().FunboxGMADownloadsFiles = {"empty"}
	end
	local isgmafound
	for i=1, #game.GetWorld():GetTable().FunboxGMADownloads, 1 do
        if game.GetWorld():GetTable().FunboxGMADownloads[i] == id then
	isgmafound = true
	end
	end
	if !isgmafound then
	table.insert(game.GetWorld():GetTable().FunboxGMADownloads,id)
	return false
	else
        return true
	end
end

local function FunboxGetAddonFiles(tab,id)
	tab = game.GetWorld():GetTable().FunboxGMADownloadsFiles[tonumber(id)]
	return tab
end

function FunboxLoadDat(id)
	//load .dat as gma
	if FunboxCheckForGma(id) then
	local tab
	tab = FunboxGetAddonFiles(tab,id)
	FunboxParseAddonTable(tab)
	return
	end
	--FunboxPrint("Starting load of ", HighlightColor, id..".dat", MainColor, " as a gma")

	local success, tab = game.MountGMA("data/Funbox/"..id..".dat")
	table.insert(game.GetWorld():GetTable().FunboxGMADownloadsFiles,id,tab)

	if success then
	--	FunboxPrint("Loaded ", HighlightColor, id..".dat", MainColor, " as a gma")
		FunboxParseAddonTable(tab)
		--RunConsoleCommand("spawnmenu_reload")
	else
	--	FunboxPrint("Failed to load ", HighlightColor, id..".dat", MainColor, " as a gma")
	end
end

function FunboxParseAddonTable(tab)
	print("parsing")
	for k,v in pairs(tab) do
		local fileFolder = string.Split(v, "/")

		if ((table.Count(fileFolder) >= 1) && (fileFolder[1] == "lua")) then
			if ((table.Count(fileFolder) >= 2) && (fileFolder[2] == "weapons")) then
				if ((table.Count(fileFolder) >= 3) && (string.EndsWith(fileFolder[3], ".lua"))) then
					FunboxLoadSWEP(fileFolder[3])
				end
			end
			if ((table.Count(fileFolder) >= 2) && (fileFolder[2] == "entities")) then
				if ((table.Count(fileFolder) >= 3) && (string.EndsWith(fileFolder[3], ".lua"))) then
					FunboxLoadENT(fileFolder[3])
				end
			end
		elseif ((table.Count(fileFolder) >= 1) && (fileFolder[1] == "models")) then
			if ((table.Count(fileFolder) >= 2) && (string.EndsWith(fileFolder[2], ".mdl"))) then
				FunboxLoadPROP(fileFolder[2])
			elseif ((table.Count(fileFolder) >= 2) && (fileFolder[2] == "weapons")) then
				if ((table.Count(fileFolder) >= 3) && (string.EndsWith(fileFolder[3], ".mdl"))) then
					FunboxLoadPROP(fileFolder[3], fileFolder[2])
				end
			end
		end
	end
end

function FunboxLoadSWEP(filename)
	if (GetConVar("Funbox_allowweapons"):GetBool() == false) then return end
	local wep = ""
	if(string.EndsWith(filename, ".lua")) then
		wep = string.sub(filename, 1, string.len(filename)-4)
	else
		wep = filename
	end

	SWEP = {}
	SWEP.Primary = {}
	SWEP.Secondary = {}

	include("weapons/"..wep..".lua")
	
	weapons.Register(SWEP, wep)

	SWEP = nil

	

	net.Start("FunboxSpawnWep")
		net.WriteString(wep)
	net.SendToServer()
end

function FunboxLoadENT(filename)
	if (GetConVar("Funbox_allowentities"):GetBool() == false) then return end
	local sent = ""
	if(string.EndsWith(filename, ".lua")) then
		sent = string.sub(filename, 1, string.len(filename)-4)
	else
		sent = filename
	end

	ENT = {}

	include("entities/"..sent..".lua")
	
	scripted_ents.Register(ENT, sent)

	ENT = nil

	

	net.Start("FunboxSpawnEnt")
		net.WriteString(sent)
	net.SendToServer()
end

function FunboxLoadPROP(filename, parentfolder)
	if (GetConVar("Funbox_allowprops"):GetBool() == false) then return end
	net.Start("FunboxSpawnProp")
	if parentfolder then
		net.WriteString("models/"..parentfolder.."/"..filename)
	else
		net.WriteString("models/"..filename)
	end

	net.SendToServer()
end
