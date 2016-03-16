--[[
	File:		cw_card/init.lua
	Author:	toneo
	Realm:	Server
	
	This represents a card in Card Wars. Lots of stuff here.
]]--
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local soldier_name = util.AddNetworkString( "Combine Soldier" )
local soldier_desc = util.AddNetworkString( "Combine soldiers are aggressive and throw grenades." )

function ENT:Initialize()
	
	self:SetModel( "models/cardwars/card.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetCardName( soldier_name )
	self:SetCardDescription( soldier_desc )
	self:SetCardHP( 100 )
	self:SetCardNPCCount( 3 )
	
	local phys = self:GetPhysicsObject()
	if (phys and phys:IsValid()) then
		phys:Wake()
	end
	
end