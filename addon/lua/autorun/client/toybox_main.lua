local PrefixColor = Color(64, 150, 238)
local MainColor = Color(54, 57, 61)
local ErrorColor = Color(255, 0, 0)
local HighlightColor = Color(230, 126, 34)

function funboxPrint(...)
	if CLIENT then
		local vargs = {...}

		local cmdStr = 'chat.AddText(Color('..PrefixColor.r..', '..PrefixColor.g..', '..PrefixColor.b..', '..PrefixColor.a..'), "funbox: ", Color('..MainColor.r..', '..MainColor.g..', '..MainColor.b..', '..MainColor.a..'), '
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

function funboxDownload(id, user, name)
	print(id)
	print(user)
	print(name)
	//Check for addon existing
	if (file.Exists("funbox/"..id..".dat", "DATA")) then
		funboxPrint("Allready downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		funboxPreLoadDat(id)
	else
		//Show a gui here

		funboxPrint("Attempting to download addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
		funboxDownloadHttp(id, user, name)
	end
end

function funboxDownloadHttp(id, user, name)
	http.Fetch("http://funbox.lethal-direct.com/client/download.php?id="..id,
		function(body, len, headers, code)
			if (body ~= "Unknown addon") then
				funboxPrint("Downloaded addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
				if (file.Exists("funbox", "DATA") == false) then
					file.CreateDir("funbox")
				end
				file.Write("funbox/"..id..".dat", body)

				funboxPrint("Saved addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " as "..id..".dat")

				funboxPreLoadDat(id)
			else
				funboxPrint(ErrorColor, "Error: ", MainColor, "No addon file")
			end
		end,
		function(error)
			funboxPrint(ErrorColor, "Error: ", MainColor, "Download for addon ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor, " failed ("..error..")")
			funboxPrint("Retrying the download for ", HighlightColor, name, MainColor, " by ", HighlightColor, user, MainColor)
			funboxDownloadHttp(id, user, name)
		end
	)
end

function funboxPreLoadDat(id)
	net.Start("funboxLoadGMA")
		net.WriteString(id)
	net.SendToServer()
	timer.Simple(1, function()
		funboxLoadDat(id)
	end)	
end

function funboxLoadDat(id)
	//load .dat as gma
	funboxPrint("Starting load of ", HighlightColor, id..".dat", MainColor, " as a gma")

	local success, tab = game.MountGMA("data/funbox/"..id..".dat")

	if success then
		funboxPrint("Loaded ", HighlightColor, id..".dat", MainColor, " as a gma")
		funboxParseAddonTable(tab)
		RunConsoleCommand("spawnmenu_reload")
	else
		funboxPrint("Failed to load ", HighlightColor, id..".dat", MainColor, " as a gma")
	end
end

function funboxParseAddonTable(tab)
	for k,v in pairs(tab) do
		local fileFolder = string.Split(v, "/")

		if ((table.Count(fileFolder) >= 1) && (fileFolder[1] == "lua")) then
			if ((table.Count(fileFolder) >= 2) && (fileFolder[2] == "weapons")) then
				if ((table.Count(fileFolder) >= 3) && (string.EndsWith(fileFolder[3], ".lua"))) then
					funboxLoadSWEP(fileFolder[3])
				end
			end

			if ((table.Count(fileFolder) >= 2) && (fileFolder[2] == "entities")) then
				if ((table.Count(fileFolder) >= 3) && (string.EndsWith(fileFolder[3], ".lua"))) then
					funboxLoadENT(fileFolder[3])
				end
			end
		end
	end
end

function funboxLoadSWEP(filename)
	if (GetConVar("funbox_allowweapons"):GetBool() == false) then return end
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

	

	net.Start("funboxSpawnWep")
		net.WriteString(wep)
	net.SendToServer()
end

function funboxLoadENT(filename)
	if (GetConVar("funbox_allowentities"):GetBool() == false) then return end
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

	

	net.Start("funboxSpawnEnt")
		net.WriteString(sent)
	net.SendToServer()
end