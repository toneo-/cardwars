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
	
end


--[[
	Name:	GM:InitPostEntity()
	Desc:	Called when all the entities on the map have been initialised.
]]
function GM:InitPostEntity()	
end
