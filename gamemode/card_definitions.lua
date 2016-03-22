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
	SquadGroup = "overwatch",
	
	SpawnClass = "npc_combine_s",
	WeaponClass = "weapon_smg1",
	WeaponProficiency = WEAPON_PROFICIENCY_GOOD,
	
	SpawnFlags = 256 + 1024 + 16834, -- Long visibility + Think outside PVS + Don't give way to player
	
	DamageSettings = {
		MeleeDamage = 10
	},
	
	KeyValues = {
		Numgrenades = 200
	}
} )

GAMEMODE:DefineCard( "combine-elite",
{
	Name = "Combine Elite",
	Description = "The elite forces of the ruling Combine regime. Elite soldiers are more durable, more aggressive and more damaging.",
	Health = 150,
	Count = 2,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/combine-elite",
	SquadGroup = "overwatch",
	ChangeModel = "models/combine_super_soldier.mdl",
	
	SpawnClass = "npc_combine_s",
	WeaponClass = "weapon_ar2",
	WeaponProficiency = WEAPON_PROFICIENCY_VERY_GOOD,
	
	DamageSettings = {
		MeleeDamage = 15
	},
	
	SpawnFlags = 256 + 1024 + 16834, -- Long visibility + Think outside PVS + Don't give way to player
	
	KeyValues = {
		Numgrenades = 200
	}
} )

GAMEMODE:DefineCard( "metrocop",
{
	Name = "Metrocop",
	Description = "More ruthless than a Texan police officer in a bar full of black people. Metrocops are weak and rely on numbers.",
	Health = 75,
	Count = 5,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/metrocop",
	SquadGroup = "overwatch",
	
	SpawnClass = "npc_metropolice",
	WeaponClass = "weapon_pistol",
	WeaponProficiency = WEAPON_PROFICIENCY_VERY_GOOD,
	
	DamageSettings = {
		MeleeDamage = 10
	},
	
	SpawnFlags = 256 + 1024 + 16834, -- Long visibility + Think outside PVS + Don't give way to player
} )

GAMEMODE:DefineCard( "zombie",
{
	Name = "Zombie",
	Description = "Abominations created after a headcrab fuses with the nervous system of its victim. Zombies are very slow, but extremely durable.",
	Health = 250,
	Count = 4,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/zombie",
	SquadGroup = "zombies",
	
	SpawnClass = "npc_zombie",
	SpawnFlags = 256 + 1024 + 16834, -- Long visibility + Think outside PVS + Don't give way to player
	
	DamageSettings = {
		MeleeDamage = 35
	}
} )

GAMEMODE:DefineCard( "zombine",
{
	Name = "Zombine",
	Description = "Zombine are extremely fast and highly resistant to melee damage.",
	Health = 200,
	Count = 2,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/zombine",
	SquadGroup = "zombies",
	
	SpawnClass = "npc_zombine",
	SpawnFlags = 256 + 1024 + 16834, -- Long visibility + Think outside PVS + Don't give way to player
	
	DamageSettings = {
		MeleeDamage = 20,
		MeleeResist = 0.3 -- Take 70% less melee damage
	}
} )

GAMEMODE:DefineCard( "hunter",
{
	Name = "Hunter",
	Description = "Lethal synthetic creations of the Combine, armed with fletchettes and sharp limbs. Hunters can fight both at range and close-up.",
	Health = 400,
	Count = 1,
	IsHero = true,
	
	PortraitMaterial = "cardwars/portraits/hunter",
	SquadGroup = "overwatch",
	
	SpawnClass = "npc_hunter",
	SpawnFlags = 256 + 1024 + 16834, -- Long visibility + Think outside PVS + Don't give way to player
	
	DamageSettings = {
		MeleeDamage = 4,
		RangedDamage = 6 -- Reduced damage, because Hunters are insanely OP otherwise
	}
} )