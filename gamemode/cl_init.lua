--[[
	File:		cl_init.lua
	Author:	toneo
	Realm:	Client
	
	This file handles client-side gamemode initialisation.
]]--
include( "shared.lua" )
include( "card_definitions.lua" )

function GM:HUDPaint()
	self:DrawNPCHealthbars()
	--self:DebugShowEntities()
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