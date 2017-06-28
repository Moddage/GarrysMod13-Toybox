util.AddNetworkString("funboxLoadGMA")
util.AddNetworkString("funboxSpawnWep")
util.AddNetworkString("funboxSpawnEnt")

function funboxPrint(str)
	if CLIENT then
		chat.AddText(Color(64, 150, 238), "funbox: ", Color(54, 57, 61), str)
	end
end

net.Receive("funboxLoadGMA", function(len, ply)
	funboxLoadDat(net.ReadString())
end)

net.Receive("funboxSpawnWep", function(len, ply)
	local swep = net.ReadString()
	ply:Give(swep)
	ply:SelectWeapon(swep)
end)

net.Receive("funboxSpawnEnt", function(len, ply)
local ent = net.ReadString()
local spawnfunc
local vStart = ply:EyePos()
local vForward = ply:GetAimVector()
    local trace = {}
trace.start = vStart
trace.endpos = vStart + ( vForward * 4096 )
trace.filter = ply

tr = util.TraceLine( trace )
local sent = scripted_ents.GetStored( EntityName )
local SpawnFunction = scripted_ents.GetMember( ent, "SpawnFunction" )
if ( !SpawnFunction ) then return end

    spawnfunc = SpawnFunction( sent, ply, tr, ent )
undo.Create( spawnfunc.PrintName )
    undo.AddEntity( spawnfunc )
    undo.SetPlayer( ply )
    undo.SetCustomUndoText( "Undone " .. spawnfunc.PrintName)
    undo.Finish()
if ( IsValid( spawnfunc ) ) then
spawnfunc:SetCreator( ply )
end


end)

local function funboxCheckForGma(id)
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

local function funboxGetAddonFiles(tab,id)
	tab = game.GetWorld():GetTable().FunboxGMADownloadsFiles[tonumber(id)]
	return tab
end

function funboxLoadDat(id)
	//load .dat as gma
	if funboxCheckForGma(id) then
	local tab
	tab = funboxGetAddonFiles(tab,id)
	funboxParseAddonTable(tab)
	return
	end
	funboxPrint("Starting load of "..id..".dat as a gma")

	local success, tab = game.MountGMA("data/funbox/"..id..".dat")
	table.insert(game.GetWorld():GetTable().FunboxGMADownloadsFiles,id,tab)

	if success then
		funboxPrint("Loaded "..id..".dat as a gma")
		funboxParseAddonTable(tab)
	else
		funboxPrint("Failed to load "..id..".dat as a gma")
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
end
