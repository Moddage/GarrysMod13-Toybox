if !game.SinglePlayer() then return end

util.AddNetworkString("FunboxLoadGMA")
util.AddNetworkString("FunboxSpawnWep")
util.AddNetworkString("FunboxSpawnEnt")
util.AddNetworkString("FunboxSpawnProp")

function FunboxPrint(str)
	if CLIENT then
		chat.AddText(Color(64, 150, 238), "Funbox: ", Color(54, 57, 61), str)
	end
end

net.Receive("FunboxLoadGMA", function(len, ply)
	FunboxLoadDat(net.ReadString())
end)

net.Receive("FunboxSpawnWep", function(len, ply)
	local swep = net.ReadString()
	ply:Give(swep)
	ply:SelectWeapon(swep)
end)

net.Receive("FunboxSpawnEnt", function(len, ply)
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

net.Receive("FunboxSpawnProp", function(len, ply)
	local prop = net.ReadString()
	print(prop)
	print("netsring recievd")
	ply:ConCommand("gm_spawn "..prop)
end)

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
	FunboxPrint("Starting load of "..id..".dat as a gma")

	local success, tab = game.MountGMA("data/Funbox/"..id..".dat")
	

	if success then
		table.insert(game.GetWorld():GetTable().FunboxGMADownloadsFiles,id,tab)
		FunboxPrint("Loaded "..id..".dat as a gma")
		FunboxParseAddonTable(tab)
	else
		FunboxPrint("Failed to load "..id..".dat as a gma")
	end
end

function FunboxParseAddonTable(tab)
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
end