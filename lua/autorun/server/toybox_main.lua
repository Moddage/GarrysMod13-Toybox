util.AddNetworkString("ToyboxLoadGMA")
util.AddNetworkString("ToyboxSpawnWep")
util.AddNetworkString("ToyboxSpawnEnt")

function ToyboxPrint(str)
	if CLIENT then
		chat.AddText(Color(64, 150, 238), "Toybox: ", Color(54, 57, 61), str)
	end
end

net.Receive("ToyboxLoadGMA", function(len, ply)
	ToyboxLoadDat(net.ReadString())
end)

net.Receive("ToyboxSpawnWep", function(len, ply)
	local swep = net.ReadString()
	ply:Give(swep)
	ply:SelectWeapon(swep)
end)

net.Receive("ToyboxSpawnEnt", function(len, ply)
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
	ToyboxPrint("Starting load of "..id..".dat as a gma")

	local success, tab = game.MountGMA("data/Toybox/"..id..".dat")
	

	if success then
		table.insert(game.GetWorld():GetTable().ToyboxGMADownloadsFiles,id,tab)
		ToyboxPrint("Loaded "..id..".dat as a gma")
		ToyboxParseAddonTable(tab)
	else
		ToyboxPrint("Failed to load "..id..".dat as a gma")
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
end
