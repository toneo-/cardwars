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

local LONG_VISIBILITY = 256
local FADE_CORPSE = 512
local THINK_OUTSIDE_PVS = 1024
local DONT_DROP_WEAPONS = 8192
local DONT_GIVE_WAY = 16834

local CommonFlags = LONG_VISIBILITY + FADE_CORPSE + THINK_OUTSIDE_PVS + DONT_DROP_WEAPONS + DONT_GIVE_WAY

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
	SpawnFlags = CommonFlags,
	
	WeaponClass = "weapon_smg1",
	WeaponProficiency = WEAPON_PROFICIENCY_GOOD,
		
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
	Health = 200,
	Count = 2,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/combine-elite",
	SquadGroup = "overwatch",
	ChangeModel = "models/combine_super_soldier.mdl",
	
	SpawnClass = "npc_combine_s",
	SpawnFlags = CommonFlags,
	
	WeaponClass = "weapon_ar2",
	WeaponProficiency = WEAPON_PROFICIENCY_VERY_GOOD,
	
	DamageSettings = {
		MeleeDamage = 20
	},
	
	
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
	SpawnFlags = CommonFlags,
	
	WeaponClass = "weapon_pistol",
	WeaponProficiency = WEAPON_PROFICIENCY_GOOD,
	
	DamageSettings = {
		MeleeDamage = 10
	},
	
} )

GAMEMODE:DefineCard( "zombie",
{
	Name = "Zombie",
	Description = "Abominations created after a headcrab fuses with the nervous system of its victim. Zombies are very slow, but extremely durable.",
	Health = 300,
	Count = 4,
	IsHero = false,
	
	PortraitMaterial = "cardwars/portraits/zombie",
	
	SpawnClass = "npc_zombie",
	SpawnFlags = CommonFlags,
	
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
	
	SpawnClass = "npc_zombine",
	SpawnFlags = CommonFlags,
	
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
	SpawnFlags = CommonFlags,
	
	DamageSettings = {
		MeleeDamage = 50,
		RangedDamage = 6 -- Reduced damage, because Hunters are insanely OP otherwise
	}
} )