--[[
	File:		damage.lua
	Author:	toneo
	Realm:	Server
	
	Damage module. Handles modifiers for damage dealt by NPCs and dealt to players.
]]--

util.AddNetworkString( "damage-notify" )

local avoidRecursion = false -- Used for hunter v hunter damage workaround

-- Modify npc damage
function GM:EntityTakeDamage( ent, dmginfo )
	if ent:IsPlayer() then return true end -- No player damage
	if avoidRecursion then return end
	
	if ent:IsNPC() then
		local attacker = dmginfo:GetAttacker()
		
		local attackerSettings = attacker.DamageSettings
		local defenderSettings = ent.DamageSettings
		
		local isMelee = dmginfo:IsDamageType( DMG_SLASH ) or dmginfo:IsDamageType( DMG_CLUB )
		
		-- Scale all explosion damage down to 50%
		if dmginfo:IsDamageType( DMG_BLAST ) then
			dmginfo:ScaleDamage( 0.5 )
		end
		
		-- TODO: Hunters cannot damage each other. RIP
		
		-- Attacker may modify their ranged/melee damage
		if attackerSettings then
			local meleeDamage = attackerSettings.MeleeDamage
			local rangedDamage = attackerSettings.RangedDamage
			
			if isMelee then
				if meleeDamage then
					dmginfo:SetDamage( meleeDamage )
				end
			elseif rangedDamage then
				dmginfo:SetDamage( rangedDamage )
			end
			
		end
		
		-- Defender may resist a portion of damage
		if defenderSettings then
			local meleeResist = defenderSettings.MeleeResist
			local rangedResist = defenderSettings.RangedResist
			
			if isMelee then
				if meleeResist then
					dmginfo:ScaleDamage( meleeResist )
				end
			elseif rangedResist then
				dmginfo:ScaleDamage( rangedResist )
			end
		end
		
		-- Hunters cannot damage hunters without this workaround.
		if ent:GetClass() == "npc_hunter" and attacker:GetClass() == "npc_hunter" then
			avoidRecursion = true
			ent:TakeDamage( dmginfo:GetDamage(), attacker )
			avoidRecursion = false
		end
		
		net.Start( "damage-notify" )
			net.WriteEntity( ent )
			net.WriteInt( dmginfo:GetDamage(), 17 )
		net.Broadcast()
	end
	
	return false
end