--[[
	File:		init.lua
	Author:	toneo
	Realm:	Server
	
	This file handles server-side gamemode initialisation.
]]--

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "card_definitions.lua" )

include( "shared.lua" )
include( "card_definitions.lua" )
include( "round.lua" )
include( "damage.lua" )

resource.AddWorkshop( "651206066" )

GM.RedHolders = {}
GM.BlueHolders = {}

--[[
	Name:	GM:PlayerInitialSpawn( ply )
	Desc:	Called when a player spawns for the first time.
]]
function GM:PlayerInitialSpawn( ply )
	
	local numRed = team.NumPlayers( self.TEAM_RED )
	local numBlue = team.NumPlayers( self.TEAM_BLUE )
	
	-- Pick the team with the fewest players
	if numRed < numBlue then
		ply:SetTeam( self.TEAM_RED )
	elseif numBlue < numRed then
		ply:SetTeam( self.TEAM_BLUE )
	else
		-- Or failing that, a random one
		local picker = math.random( 1, 2 )
		
		if picker == 1 then
			ply:SetTeam( self.TEAM_RED )
		else 
			ply:SetTeam( self.TEAM_BLUE )
		end
		
	end
	
end


--[[
	Name:	GM:PlayerSpawn( ply )
	Desc:	Called when a player needs spawning.
]]
function GM:PlayerSpawn( ply )
	self.BaseClass:PlayerSpawn( ply )
	
	local plyTeam = ply:Team()
	local spawns = {}
	
	if plyTeam == self.TEAM_RED then
		spawns = ents.FindByClass( "cw_spawn_red" )
	elseif plyTeam == self.TEAM_BLUE then
		spawns = ents.FindByClass( "cw_spawn_blue" )
	else
		print( "** ERROR: Trouble spawning ", ply:Name(), ", they have not been assigned a team!" )
	end
	
	-- Pick a random spawn and try and spawn at it
	local found = false
	while not found do
		local spawn = table.Random( spawns )
		
		if not spawn then break end
		local pos = spawn:GetPos()
		
		-- Test and see if we can spawn on it
		local trace = {
			start = pos,
			endpos = pos
		}
		
		local result = util.TraceEntity( trace, ply )
		if not result.Hit then
			ply:SetPos( pos )
			found = true
			break
		end
		
		table.RemoveByValue( spawn )
	end
	
	if not found then
		print( "Unable to spawn player ", ply:Name(), " as no spawnpoints were suitable. Maybe the map doesn't support this many players?" )
	end
end


--[[
	Name:	GM:InitPostEntity()
	Desc:	Called when all the entities on the map have been initialised.
]]
function GM:InitPostEntity()
	
	-- Find all card holders, separate into red/blue holders and store for later
	local holders = ents.FindByClass( "cw_card_holder" )
	
	for _, holder in pairs( holders ) do
		
		local assignedTeam = holder:GetAssignedTeam()
		
		-- Separate into red/blue card holders and store
		if assignedTeam == self.TEAM_RED then
			table.insert( self.RedHolders, holder )
		elseif assignedTeam == self.TEAM_BLUE then
			table.insert( self.BlueHolders, holder )
		end
		
	end
	
end


--[[
	Name:	GM:PlayerLoadout( ply )
	Desc:	Called to set the player's loadout (i.e. which weapons they have)
]]
function GM:PlayerLoadout( ply )
	ply:Give( "weapon_physcannon" )
end


--[[
	Name:	GM:PlayerSwitchFlashlight( ply )
	Desc:	Called when a player attempts to switch their flashlight on/off.
]]
function GM:PlayerSwitchFlashlight( ply )
	-- Allow
	return true
end