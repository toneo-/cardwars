--[[
	File:		cw_card_holder/init.lua
	Author:	toneo
	Realm:	Server
	
	This represents a card holder.
]]--
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Think()
	
	if not self.HeldCard then
	
		local globalGrab = self:LocalToWorld( self.GrabPoint )
		local near = ents.FindInSphere( globalGrab, self.GrabDistance )
		
		for _, v in pairs(near) do
			if v:GetClass() == "cw_card" then
				
				local pos = v:GetPos()
				local phys = v:GetPhysicsObject()
				
				-- The first card we see we grab and attach
				-- TODO: Don't grab cards from other holders
				self.HeldCard = v
				
				DropEntityIfHeld( v )
				
				v:SetPos( globalGrab )
				v:SetAngles( self:LocalToWorldAngles(self.HoldAngle) )
				
				phys:Sleep()
				
				self:EmitSound( "items/battery_pickup.wav" )
				
				-- Thinking can happen far more slowly now
				self:NextThink( CurTime() + 3 )
				return true
			end
		end
		
		self:NextThink( CurTime() )
		
	else
		
		local card = self.HeldCard
		
		if not card or not IsValid(card) then
			self.HeldCard = nil
			self:NextThink( CurTime() )
			
			return true
		end
		
		local phys = card:GetPhysicsObject()
		
		if not phys:IsAsleep() then
			self.HeldCard = nil
			self:NextThink( CurTime() )
		else
			self:NextThink( CurTime() + 3 )
		end
		
	end
	
	return true
end

function ENT:Use( activator )
	
	local card = self.HeldCard
	if not card or not IsValid(card) then return end
	
	local phys = card:GetPhysicsObject()
	
	phys:Wake()
	
	self.HeldCard = nil
	self:NextThink( CurTime() + 3 )
	
	self:EmitSound( "physics/metal/metal_sheet_impact_soft2.wav" )
	
end