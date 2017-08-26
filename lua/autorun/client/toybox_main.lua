local PrefixColor = Color(64, 150, 238)
local MainColor = Color(54, 57, 61)
local ErrorColor = Color(255, 0, 0)
local HighlightColor = Color(230, 126, 34)

function ToyboxPrint(...)
	if CLIENT then
		local vargs = {...}

		local cmdStr = 'chat.AddText(Color('..PrefixColor.r..', '..PrefixColor.g..', '..PrefixColor.b..', '..PrefixColor.a..'), "Toybox: ", Color('..MainColor.r..', '..MainColor.g..', '..MainColor.b..', '..MainColor.a..'), '
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

		RunString(cmdStr)
	end
end

function ToyboxDownload(id, user, name)
	print(id)
	print(user)
	print(name)
	//Check for addon existing
	if (file.Exists("Toybox/"..id..".dat", "DATA")) then
		ToyboxPrint("Allready downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		ToyboxPreLoadDat(id)
	else
		//Show a gui here

		ToyboxPrint("Attempting to download addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		ToyboxDownloadHttp(id, user, name)
	end
end

function ToyboxDownloadHttp(id, user, name)
	http.Fetch("http://funbox.website/client/download.php?id="..id,
		function(body, len, headers, code)
			if (body ~= "Unknown addon") then
				ToyboxPrint("Downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
				if (file.Exists("Toybox", "DATA") == false) then
					file.CreateDir("Toybox")
				end
				file.Write("Toybox/"..id..".dat", body)

				ToyboxPrint("Saved addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " as "..id..".dat")

				ToyboxPreLoadDat(id)
			else
				ToyboxPrint(ErrorColor, "Error: ", MainColor, "No addon file")
			end
		end,
		function(error)
			ToyboxPrint(ErrorColor, "Error: ", MainColor, "Download for addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " failed ("..error..")")
			ToyboxPrint("Retrying the download for ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
			ToyboxDownloadHttp(id, user, name)
		end
	)
end

function ToyboxPreLoadDat(id)
	net.Start("ToyboxLoadGMA")
		net.WriteString(id)
	net.SendToServer()
	timer.Simple(1, function()
		ToyboxLoadDat(id)
	end)	
end

local function ToyboxCheckForGma(id)
	if game.GetWorld():GetTable().ToyboxGMADownloads == nil then
	local ToyboxGMADownloads={}
        game.GetWorld():GetTable().ToyboxGMADownloads = {"empty"}
	end
	if game.GetWorld():GetTable().ToyboxGMADownloadsFiles == nil then
	local ToyboxGMADownloadsFiles={}
        game.GetWorld():GetTable().ToyboxGMADownloadsFiles = {"empty"}
	end
	local isgmafound
	for i=1, #game.GetWorld():GetTable().ToyboxGMADownloads, 1 do
        if game.GetWorld():GetTable().ToyboxGMADownloads[i] == id then
	isgmafound = true
	end
	end
	if !isgmafound then
	table.insert(game.GetWorld():GetTable().ToyboxGMADownloads,id)
	return false
	else
        return true
	end
end

local function ToyboxGetAddonFiles(tab,id)
	tab = game.GetWorld():GetTable().ToyboxGMADownloadsFiles[tonumber(id)]
	return tab
end

function ToyboxLoadDat(id)
	//load .dat as gma
	if ToyboxCheckForGma(id) then
	local tab
	tab = ToyboxGetAddonFiles(tab,id)
	ToyboxParseAddonTable(tab)
	return
	end
	ToyboxPrint("Starting load of ", HighlightColor, id..".dat", MainColor, " as a gma")

	local success, tab = game.MountGMA("data/Toybox/"..id..".dat")
	table.insert(game.GetWorld():GetTable().ToyboxGMADownloadsFiles,id,tab)

	if success then
		ToyboxPrint("Loaded ", HighlightColor, id..".dat", MainColor, " as a gma")
		ToyboxParseAddonTable(tab)
		--RunConsoleCommand("spawnmenu_reload")
	else
		ToyboxPrint("Failed to load ", HighlightColor, id..".dat", MainColor, " as a gma")
	end
end

function ToyboxParseAddonTable(tab)
	for k,v in pairs(tab) do
		local fileFolder = string.Split(v, "/")

		if ((table.Count(fileFolder) >= 1) && (fileFolder[1] == "lua")) then
			if ((table.Count(fileFolder) >= 2) && (fileFolder[2] == "weapons")) then
				if ((table.Count(fileFolder) >= 3) && (string.EndsWith(fileFolder[3], ".lua"))) then
					ToyboxLoadSWEP(fileFolder[3])
				end
			end

			if ((table.Count(fileFolder) >= 2) && (fileFolder[2] == "entities")) then
				if ((table.Count(fileFolder) >= 3) && (string.EndsWith(fileFolder[3], ".lua"))) then
					ToyboxLoadENT(fileFolder[3])
				end
			end
		end
	end
end

function ToyboxLoadSWEP(filename)
	if (GetConVar("Toybox_allowweapons"):GetBool() == false) then return end
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

	

	net.Start("ToyboxSpawnWep")
		net.WriteString(wep)
	net.SendToServer()
end

function ToyboxLoadENT(filename)
	if (GetConVar("Toybox_allowentities"):GetBool() == false) then return end
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

	

	net.Start("ToyboxSpawnEnt")
		net.WriteString(sent)
	net.SendToServer()
end
