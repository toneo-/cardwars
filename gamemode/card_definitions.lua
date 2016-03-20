--[[
	File:		card_definitions.lua
	Author:	toneo
	Realm:	Shared
	
	Defines a series of cards for use by the gamemode.
	Each card represents an NPC (or group of NPCs)
]]--

GM.CardDefinitions = {}


function GM:DefineCard( id, definition )
	self.CardDefinitions[ id ] = definition
	
	-- Cache the ID which will be sent over the network to identify cards
	if SERVER then
		util.AddNetworkString( id )
	end
end

function GM:LookupDefinition( id )
	return self.CardDefinitions[ id ]
end

local GAMEMODE = GM

GAMEMODE:DefineCard( "combine-soldier",
{
	Name = "Combine Soldier",
	Description = "Combine soldiers are aggressive and throw grenades.",
	Health = 100,
	Count = 3,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/combine-soldier",
	
	SpawnClass = "npc_combine_s",
	WeaponClass = "weapon_ar2",
	
	KeyValues = {
		Numgrenades = 200
	}
} )

GAMEMODE:DefineCard( "combine-elite",
{
	Name = "Combine Elite",
	Description = "The elite forces of the ruling Combine regime. Elite soldiers are more durable, more aggressive, more damaging.",
	Health = 150,
	Count = 2,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/combine-elite",
	
	SpawnClass = "npc_combine_s",
	WeaponClass = "weapon_ar2",
	
	SpawnFlags = 16834,
	
	KeyValues = {
		Numgrenades = 200
	}
} )

GAMEMODE:DefineCard( "zombie",
{
	Name = "Zombie",
	Description = "Abominations created after a headcrab fuses with the nervous system of its victim. Zombies are very slow, but extremely durable.",
	Health = 250,
	Count = 4,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/zombie",
	
	SpawnClass = "npc_zombie",
} )