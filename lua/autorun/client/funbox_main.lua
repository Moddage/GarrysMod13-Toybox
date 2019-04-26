if !game.SinglePlayer() then return end

local PrefixColor = Color(64, 150, 238)
local MainColor = Color(54, 57, 61)
local ErrorColor = Color(255, 0, 0)
local HighlightColor = Color(230, 126, 34)
local printtext = CreateClientConVar("funbox_print_text", "0", true)

function FunboxPrint(...)
	if CLIENT and printtext:GetBool() then
		local vargs = {...}

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

		RunString(cmdStr)
	end
end

function FunboxDownload(id, user, name, date)
	print(date, "date")
	if !id then
		notification.AddLegacy("INVALID ID! How did you even do this?!", NOTIFY_ERROR, 3)
		return
	end

	//Check for addon existing
	if (file.Exists("Funbox/"..id..".dat", "DATA")) then
		local time = date or "2019-04-10 00:20:03"
		local montht = string.sub(time, 6, 7)
		local dayt = string.sub(time, 9, 10)
		local yeart = string.sub(time, 1, 4)
		local hourt = string.sub(time, 12, 13)
		local minutet = string.sub(time, 15, 16)
		local secondt = string.sub(time, 18, 19)
		local unix = os.time{year=yeart, month=montht, day=dayt, hour=hourt, min=minutet, sec=secondt} -- there HAS to be a better way to this.
		local localtime = file.Time("Funbox/"..id..".dat", "DATA")
		local osdiff = os.difftime(localtime, unix)
		print(osdiff)
		if osdiff > 0 or unix == 1554880803 or time == "2019-04-10 00:31:03" then
			FunboxPrint("Already downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
			FunboxPreLoadDat(id, true)
		else
			notification.AddProgress("funbox_Downloading", "Updating...")
			FunboxPrint("Attempting to update ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
			FunboxDownloadHttp(id, user, name, true)
		end
	elseif (file.Exists("Funbox/Saves/"..id..".dat", "DATA")) then
		local map = string.sub(file.Read("funbox/saves/"..id..".dat", "DATA"), 5, #game.GetMap() + 5)
		--[[print(map)
		print(map == "gm_construct")
		local maps = file.Find("maps/*.bsp", "GAME")
		local maps2 = {}
		for k, v in pairs(maps) do
			maps2[v] = true
		end
		--PrintTable(maps2)
		if map == game.GetMap() then	]]	
		FunboxPrint("Already downloaded save ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		RunConsoleCommand("gm_load", "data/funbox/saves/"..id..".dat")
		--[[else
			--FunboxPrint("Save ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " uses ", HighlightColor, map, MainColor, "!")
			surface.PlaySound("buttons/button8.wav")
			notification.AddLegacy("\""..name.."\" uses map \""..map.."\", but you are using \""..game.GetMap().."\"!", NOTIFY_ERROR, 3)
		end]]
	else
		//Show a gui here
		notification.AddProgress("funbox_Downloading", "Downloading...")
		FunboxPrint("Attempting to download ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		FunboxDownloadHttp(id, user, name)
	end
end

function FunboxDownloadHttp(id, user, name, update)
	http.Fetch("https://funbox.moddage.site/client/download.php?id="..id,
		function(body, len, headers, code)
			print(body, len, headers, code)
			if (body ~= "Unknown addon") then
				if (string.sub(body, 1, 3) == "GMS") then
					if (file.Exists("Funbox", "DATA") == false) then
						file.CreateDir("Funbox")
					end
					if (file.Exists("Funbox/Saves", "DATA") == false) then
						file.CreateDir("Funbox/Saves")
					end
					file.Write("Funbox/Saves/"..id..".dat", body)
					RunConsoleCommand("gm_load", "data/funbox/saves/"..id..".dat")
					FunboxPrint("Downloaded save ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
					notification.Kill("funbox_Downloading")
					return
				end
				FunboxPrint("Downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
				if (file.Exists("Funbox", "DATA") == false) then
					file.CreateDir("Funbox")
				end
				file.Write("Funbox/"..id..".dat", body)

				FunboxPrint("Saved addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " as "..id..".dat")
				notification.Kill("funbox_Downloading")
				FunboxPreLoadDat(id)
			else
				FunboxPrint(ErrorColor, "Error: ", MainColor, "No addon file")
				notification.Kill("funbox_Downloading")
			end

			if update then
				notification.Kill("funbox_Downloading")
				surface.PlaySound("buttons/button1.wav")
				notification.AddLegacy("If you have already mounted "..name..", restart your game and select it again!", NOTIFY_GENERIC, 10)
			end
		end,
		function(error)
			FunboxPrint(ErrorColor, "Error: ", MainColor, "Download for addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " failed ("..error..")")
			FunboxPrint("Retrying the download for ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
			FunboxDownloadHttp(id, user, name)
			notification.Kill("funbox_Downloading")
		end
	)
end

function FunboxPreLoadDat(id, alreadyd)
	net.Start("FunboxLoadGMA")
		net.WriteString(id)
	net.SendToServer()
	if alreadyd then
		FunboxLoadDat(id)
	else
		timer.Simple(1, function()
			FunboxLoadDat(id)
		end)	
	end
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
	FunboxPrint("Starting load of ", HighlightColor, id..".dat", MainColor, " as a gma")

	local success, tab = game.MountGMA("data/Funbox/"..id..".dat")
	table.insert(game.GetWorld():GetTable().FunboxGMADownloadsFiles,id,tab)

	if success then
		FunboxPrint("Loaded ", HighlightColor, id..".dat", MainColor, " as a gma")
		FunboxParseAddonTable(tab)
		--RunConsoleCommand("spawnmenu_reload")
	else
		FunboxPrint("Failed to load ", HighlightColor, id..".dat", MainColor, " as a gma")
	end
end

function FunboxParseAddonTable(tab)
	print("parsing")
	for k,v in pairs(tab) do
		local fileFolder = string.Split(v, "/")
		print(fileFolder[1], "folder")
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
			elseif string.find(v, ".mdl") then -- last chance measure
				RunConsoleCommand("gm_spawn", v)
			end
		elseif ((table.Count(fileFolder) >= 1) && (fileFolder[1] == "maps")) then
			if ((table.Count(fileFolder) >= 2) && (string.EndsWith(fileFolder[2], ".bsp"))) then
				RunConsoleCommand("changelevel", string.Replace(fileFolder[2], ".bsp", ""))
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
