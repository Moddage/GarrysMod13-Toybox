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
	print("sweatg")
	local ent = net.ReadString()
	local sent = ents.Create(ent)
	sent:SetPos(ply:GetEyeTrace().HitPos)
	sent:Spawn()
end)

function ToyboxLoadDat(id)
	//load .dat as gma
	ToyboxPrint("Starting load of "..id..".dat as a gma")

	local success, tab = game.MountGMA("data/toybox/"..id..".dat")

	if success then
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
	if (GetConVar("toybox_allowweapons"):GetBool() == false) then return end
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
	if (GetConVar("toybox_allowentities"):GetBool() == false) then return end
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