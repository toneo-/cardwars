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

--[[
	Name:	ENT:Initialize()
	Desc:	Called when this entity is first initialised.
]]
function ENT:Initialize()
	
	self:SetModel( "models/cardwars/card.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	-- Only use once when E pressed
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	if ( phys and phys:IsValid() ) then
		phys:Wake()
	end
	
end

--[[
	Name:	ENT:Use( activator )
	Desc:	Called when this entity is 'used', triggered by someone walking up to it and pressing E.
]]
function ENT:Use( activator )
	
	local holder = self:GetHolder()
	
	-- If attached to a holder, drop
	if IsValid( holder ) then
		
		-- If not locked, release card. Otherwise do nothing (and don't run that elseif either)
		if not holder:IsLocked() then
			holder:ReleaseCard()
			self:EmitSound( "physics/metal/metal_sheet_impact_soft2.wav" )
		end
		
	end
		
	-- The card should always be picked up when used, except if already held
	if not self:IsPlayerHolding() then
	
		activator:PickupObject( self )
		self.PickerUpper = activator -- Mark who is holding this card so we can let just them drop it
		
	else
	
		-- We were used when held, only allow the current holder to drop it
		local pickerUpper = self.PickerUpper
		if ( IsValid(pickerUpper) and pickerUpper:IsPlayer() ) then
		
			pickerUpper:DropObject()
			self.pickerUpper = nil
			
		end
	
	end
	
end

--[[
	Name:	ENT:OnRemove()
	Desc:	Called just before the entity is removed.
]]
function ENT:OnRemove()
	
	local holder = self.Holder
	if holder and IsValid(holder) then
		
		-- The holder needs to begin thinking again. This wakes it up.
		holder:NextThink( CurTime() )
		
	end
	
end

--[[
	****************************************
	** Custom entity functions are defined below. **
	****************************************
]]--

--[[
	Name:	ENT:SetHolder( holder )
	Desc:	Sets the given entity as the card holder containing it.
]]
function ENT:SetHolder( holder )
	self.Holder = holder
end


--[[
	Name:	ENT:GetHolder()
	Desc:	Gets the card holder containing this entity.
	Returns: The card holder containing this entity. May be nil or an invalid entity.
]]
function ENT:GetHolder()
	return self.Holder
end

--[[
	Name:	ENT:SetCardID( id )
	Desc:	Sets the ID of this card, for example 'combine-soldier'.
]]
function ENT:SetCardID( id )
	
	local cachedID = util.NetworkStringToID( id )
	
	-- Just-in-case...
	if ( cachedID == 0 ) then
		print( "ENT:SetCardID() - Uncached id " .. id )
		cachedID = util.AddNetworkString( id )
	end
	
	-- Tell the client
	self:SetCardIDString( cachedID )
	
end