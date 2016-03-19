--[[
	File:		card_definitions.lua
	Author:	toneo
	Realm:	Shared
	
	Defines a series of cards for use by the gamemode.
	Each card represents an NPC (or group of NPCs)
]]--

GM.CardDefinitions = {}


local function DefineCard( id, name, health, count, isHero, portraitMaterial, description )
	
	-- Store all card data
	local def = {
		name = name,
		health = health,
		count = count,
		isHero = ( isHero == true ),
		portraitMaterial = portraitMaterial,
		description = description
	}
	
	GM.CardDefinitions[ id ] = def
	
	-- Cache the ID which will be sent over the network to identify cards
	util.AddNetworkString( id )
end

DefineCard( "combine-soldier",
	"Combine Soldier",
	"100", 3, false,
	"cardwars/portraits/combine-soldier",
	"Combine soldiers are aggressive and throw grenades." )