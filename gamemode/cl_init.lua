--[[
	File:		cl_init.lua
	Author:	toneo
	Realm:	Client
	
	This file handles client-side gamemode initialisation.
]]--
include( "shared.lua" )
include( "card_definitions.lua" )
include( "sh_chat.lua" )
include( "sh_sound.lua" )

local hitmarker = Material( "cardwars/hitsplat.png", "unlitgeneric alphatest" )

function GM:HUDPaint()
	self:DrawNPCHealthbars()
	--self:DebugShowEntities()
	
		self:HandleDankModeUI()
end

function GM:DrawNPCHealthbars()
	
	local healthbarWidth = 80
	local healthbarHeight = 10
	local halfWidth = healthbarWidth / 2
	
	for k, npc in pairs( ents.FindByClass( "npc_*" ) ) do
		
		-- Ignore grenades / dead NPCs
		if npc:GetClass() ~= "npc_grenade_frag" and npc:Health() > 0 then
			local healthbarPos = (npc:GetPos() + Vector(0, 0, 80)):ToScreen()
			local frac = npc:Health() / npc:GetMaxHealth()
			
			-- Red/Green bar
			draw.RoundedBox( 4, healthbarPos.x - halfWidth, healthbarPos.y, healthbarWidth, healthbarHeight, Color(100, 20, 20) )
			draw.RoundedBox( 4, healthbarPos.x - halfWidth, healthbarPos.y, healthbarWidth * frac, healthbarHeight, Color(100, 240, 100) )
			
			-- HP
			draw.RoundedBox( 0, healthbarPos.x - 20, healthbarPos.y, 40, healthbarHeight, Color(0, 0, 0, 50) )
			draw.SimpleText( math.Round(frac * 100) .. "%", "Default", healthbarPos.x, healthbarPos.y - 1.5, Color(150, 80, 20, 255), TEXT_ALIGN_CENTER )
		end
		
	end
	
end

function GM:DebugShowEntities()
	
	local classes = {
		"cw_npc_spawn_red",
		"cw_npc_spawn_blue",
		"cw_card"
	}
	
	for _, class in pairs( classes ) do
		
		for k, v in pairs( ents.FindByClass(class) ) do
			
			local pos = v:GetPos()
			local scrPos = pos:ToScreen()
			
			local x, y, z = math.Round( pos.x ), math.Round( pos.y ), math.Round( pos.z )
			
			draw.SimpleText( class, "Default", scrPos.x, scrPos.y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( x .. ", " .. y .. ", " .. z, "Default", scrPos.x, scrPos.y + 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end
		
	end
	
end


-- Handle damage notify messages
net.Receive( "DamageNotify", function( length )
	local ent = net.ReadEntity()
	local hitPos = net.ReadVector()
	local damage = net.ReadInt( 17 )
	local newHealth = net.ReadInt( 17 )
	
	ent:SetHealth( newHealth )
	
	if GAMEMODE:IsDankModeEnabled() then
		ent:EmitSound( "cardwars/effects/cod-hitsound.mp3", 120 )
		GAMEMODE:MakeHitMarker( ent, ent:WorldToLocal( hitPos ), damage, 0.4 )
	end
end )

-- secret
GM.HitMarkers = {}

function GM:MakeHitMarker( ent, pos, dmg, duration )
	local marker = { ent = ent, pos = pos, dmg = dmg, endtime = CurTime() + duration }
	table.insert( self.HitMarkers, marker )
end

function GM:HandleDankModeUI()
	surface.SetMaterial( hitmarker )
	
	local now = CurTime()
	local HitMarkers = self.HitMarkers
		
	for k, marker in pairs( HitMarkers ) do
		
		if marker.endtime < now then
			HitMarkers[k] = nil
		else
		
			local scrPos = marker.ent:LocalToWorld( marker.pos ):ToScreen()
			local splatColor = Color( 255, 0, 0, 255 )
			
			if marker.dmg < 1 then splatColor = Color( 0, 100, 255, 255 ) end
			
			surface.SetDrawColor( splatColor.r, splatColor.g, splatColor.b, splatColor.a )
			surface.DrawTexturedRect( scrPos.x - 16, scrPos.y - 16, 32, 32 )
			
			draw.SimpleText( tostring( marker.dmg ), "BudgetLabel", scrPos.x, scrPos.y, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.SimpleText( tostring( marker.dmg ), "BudgetLabel", scrPos.x - 2, scrPos.y - 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end
	end
end