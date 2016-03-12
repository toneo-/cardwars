--[[
	File:		init.lua
	Author:	toneo
	Realm:	Server
	
	This file handles server-side gamemode initialisation.
]]--

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


--[[
	Name:	GM:PlayerSpawn( ply )
	Desc:	Called when a player needs spawning.
]]
function GM:PlayerSpawn( ply )
	
	local spawnpoints = ents.FindByClass( "cw_spawn_red" )
	ply:SetPos( spawnpoints[1]:GetPos() )
	
end