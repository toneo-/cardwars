--[[
	File:		cw_card_holder/shared.lua
	Author:	toneo
	Realm:	Shared
	
	This represents a card holder.
]]--
ENT.Type = "point"
 
ENT.PrintName		= "Card Holder"
ENT.Author			= "toneo"
ENT.Information		= "Holds cards in Card Wars"
ENT.Category		= "Fun + Games"

ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:Initialize()
	
	if SERVER then
		self.HeldCard = nil
		
		self.HoldAngle = Angle(0, 0, 0)
		self.GrabDistance = 20
		
		self.GrabPoint = Vector(0, 0, 0)
	end
	
end