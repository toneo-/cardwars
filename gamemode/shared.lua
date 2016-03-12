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

--[[
	Name:	GM:Initialize()
	Desc:	Called when the gamemode first initialises. At this point many entities placed in the map (in
				particular, Lua entities) have not been properly initialised.
]]
function GM:Initialize()
end