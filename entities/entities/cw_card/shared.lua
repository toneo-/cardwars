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
	
	self:NetworkVar( "Int", 0, "CardName" )
	self:NetworkVar( "Int", 1, "CardDescription" )
	self:NetworkVar( "Int", 2, "CardHP" )
	self:NetworkVar( "Int", 3, "CardNPCCount" )
	
end