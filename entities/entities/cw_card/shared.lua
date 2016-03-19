--[[
	File:		cw_card/shared.lua
	Author:	toneo
	Realm:	Shared
	
	This represents a card in Card Wars. Lots of stuff here.
]]--
ENT.Type = "anim"
ENT.Base = "base_anim"
 
ENT.PrintName		= "Card"
ENT.Author			= "toneo"
ENT.Information		= "A playable card in Card Wars"
ENT.Category		= "Fun + Games"

ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	
	-- The card ID is sent over the network as a cached string.
	self:NetworkVar( "Int", 0, "CardIDString" )
	
end


--[[
	Name:	ENT:GetCardID()
	Desc:	Gets the ID of this card, for example 'combine-soldier'.
]]
function ENT:GetCardID()
	
	local cachedID = self:GetCardIDString()
	if ( cachedID == 0 ) then return end
	
	return util.NetworkIDToString( cachedID )
	
end