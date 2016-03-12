--[[
	File:		cw_spawn_blue.lua
	Author:	toneo
	Realm:	Server
	
	This represents one of blue team's spawn points.
]]--

-- Point entities have no model and are extremely cheap.
ENT.Type = "point"

--[[
	Name:	ENT:Initialize()
	Desc:	Called when this entity is first initialised.
]]
function ENT:Initialize()
end

--[[
	Name:	ENT:Think()
	Desc:	Called when this entity needs to think.
]]
function ENT:Think()
	-- Spawn points never need to do anything.
	self:NextThink( CurTime() + 50000 )
end