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

GM.RedHolders = {}
GM.BlueHolders = {}

--[[
	Name:	GM:PlayerInitialSpawn( ply )
	Desc:	Called when a player spawns for the first time.
]]
function GM:PlayerInitialSpawn( ply )
		
end


--[[
	Name:	GM:PlayerSpawn( ply )
	Desc:	Called when a player needs spawning.
]]
function GM:PlayerSpawn( ply )
	self.BaseClass:PlayerSpawn( ply )
end


--[[
	Name:	GM:InitPostEntity()
	Desc:	Called when all the entities on the map have been initialised.
]]
function GM:InitPostEntity()
	
	local holders = ents.FindByClass( "cw_card_holder" )
	
	for _, holder in pairs( holders ) do
		
		local assignedTeam = holder:GetAssignedTeam()
		
		-- Separate into red/blue card holders and store for later		
		if assignedTeam == self.TEAM_RED then
			table.insert( self.RedHolders, holder )
		elseif assignedTeam == self.TEAM_BLUE then
			table.insert( self.BlueHolders, holder )
		end
		
	end
	
end


--[[
	Name:	GM:PlayerLoadout()
	Desc:	Called when all the entities on the map have been initialised.
]]
function GM:PlayerLoadout()	
end


--[[
	Name:	GM:PlayerSwitchFlashlight( ply )
	Desc:	Called when a player attempts to switch their flashlight on/off.
]]
function GM:PlayerSwitchFlashlight( ply )
	-- Allow
	return true
end