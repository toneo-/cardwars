--[[
	File:		shared.lua
	Author:	toneo
	Realm:	Shared
	
	This file handles initialisation logic which is needed on both the server and client sides.
]]--

GM.Name	= "Card Wars"
GM.Author	= "toneo"
GM.Email	= "Don't, see github"
GM.Website	= "https://github.com/toneo-/cardwars"

GM.TEAM_RED = 1002
GM.TEAM_BLUE = 1003



--[[
	Name:	GM:Initialize()
	Desc:	Called when the gamemode first initialises. At this point many entities placed in the map (in
				particular, Lua entities) have not been properly initialised.
]]
function GM:Initialize()
	
	team.SetUp( TEAM_RED, "Red Team", Color(255, 0, 0), false )
	team.SetUp( TEAM_BLUE, "Blue Team", Color(0, 0, 255), false )
	
	team.SetSpawnpoint( TEAM_RED, "cw_spawn_red" )
	team.SetSpawnpoint( TEAM_BLUE, "cw_spawn_blue" )
	
end