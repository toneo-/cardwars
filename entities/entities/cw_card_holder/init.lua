--[[
	File:		cw_card_holder/init.lua
	Author:	toneo
	Realm:	Server
	
	This represents a card holder.
]]--
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

print( "GM: " .. tostring(GM) )
print( "GAMEMODE: " .. tostring(GAMEMODE) )

local teamTranslations = {
	[0] = 0,
	[1] = GAMEMODE.TEAM_RED,
	[2] = GAMEMODE.TEAM_BLUE
}


--[[
	Name:	ENT:Initialize()
	Desc:	Called when this entity is first initialised.
]]
function ENT:Initialize()
	self.HeldCard = nil
	
	self.HoldAngle = Angle(0, 0, 0)
	
	self.GrabOffset = Vector(0, 0, 0)
	self.GrabDistance = 12
	
	self.RegrabDelay = 2
end


--[[
	Name:   ENT:Think()
	Desc:	Called when this entity needs to think.
]]
function ENT:Think()
	
	-- If not holding a card, look for one close nearby
	if not self:IsHoldingCard() then
	
		local grabPoint = self:LocalToWorld( self.GrabOffset )
		local near = ents.FindInSphere( grabPoint, self.GrabDistance )
		
		for _, v in pairs(near) do
			if self:CanHold( v ) then
				
				-- The first card we see we grab and attach
				self:HoldCard( v )
				self:EmitSound( "physics/metal/metal_grate_impact_hard3.wav" )
				
				-- Thinking is not necessary, we will be told when next to think
				self:NextThink( CurTime() + 50000 )
				return true
			end
		end
		
		self:NextThink( CurTime() + 0.5 )
		
	end
	
	return true
end


--[[
	Name:	ENT:Use( activator )
	Desc:	Called when this entity is 'used', triggered by someone walking up to it and pressing E.
]]
function ENT:Use( activator )
	
	-- Eject current held card and play a nice sound
	if self:IsHoldingCard() then
		self:ReleaseCard()
		self:EmitSound( "physics/metal/metal_sheet_impact_soft2.wav" )
	end
	
end


--[[
	Name:	ENT:AcceptInput( inputName, activator, caller, data )
	Desc:	Called when this entity has an input triggered, usually by something in the map.
]]
function ENT:AcceptInput( inputName, activator, caller, data )
	
	if inputName == "ReleaseCard" then
		
		-- Hm, I wonder what we should do
		self:ReleaseCard()
		
	elseif inputName == "RemoveCard" then
		
		-- Delete card if we have one
		if self:IsHoldingCard() then
			
			-- The card's OnRemove function will tell us to think immediately once we remove it
			self:GetHeldCard():Remove()
		
		end
		
	end
	
end

--[[
	Name:	ENT:KeyValue( key, value )
	Desc:	Called when this entity has an input triggered, usually by something in the map.
]]
function ENT:KeyValue( key, value )
	
	-- All of our outputs start with 'On'
	if string.Left( key ) == "On" then
	
		-- Store so they can be triggered later
		self:StoreOutput( key, value )
		
	else -- Must be an attribute
		
		if key == "team" then
			self:SetAssignedTeam( tonumber(value) )
		elseif key == "grabDistance" then
			self.GrabDistance = math.max( 0, tonumber(value) )
		end
		
	end
	
end

--[[
	****************************************
	** Custom entity functions are defined below. **
	****************************************
]]--

--[[
	Name:	ENT:SetAssignedTeam( teamNo )
	Desc:	Assigns this card holder to a given team. Any team number other than 0 will cause this
				card holder to be considered when spawning NPCs.
]]
function ENT:SetAssignedTeam( teamNo )
	local translation = teamTranslations[ teamNo ]
	if not translation then
		print( "!! Warning, cw_card_holder was assigned to invalid team number " .. tostring(teamNo) .. "! This should never happen. The card holder will be left unassigned." )
	else
		self.AssignedTeam = translation
	end
end


--[[
	Name:	ENT:GetAssignedTeam()
	Desc:	Finds out which team this card holder is assigned to.
]]
function ENT:GetAssignedTeam()
	return self.AssignedTeam or 0
end

--[[
	Name:	ENT:IsHoldingCard()
	Desc:	Used to find out if a card holder is holding a (valid) card.
	Returns:	true if holding a card, false otherwise
]]
function ENT:IsHoldingCard()
	return ( self.HeldCard and IsValid( self.HeldCard ) )
end


--[[
	Name:	ENT:CanHold()
	Desc:	Used to find out if a card holder can hold the given card. Filters out things that are not cards and cards that are already held in another holder.
	Returns:	true if the given entity can be held, false otherwise
]]
function ENT:CanHold( card )
	return ( IsValid(card) and card:GetClass() == "cw_card" and not IsValid( card:GetHolder() ) )
end


--[[
	Name:	ENT:GetHeldCard()
	Desc:	Used to retrieve the card held by a card holder.
	Returns:	Guess
]]
function ENT:GetHeldCard()
	return self.HeldCard
end


--[[
	Name:	ENT:HoldCard( card )
	Desc:	Puts the given card into the holder and freezes it. Does no validation beyond checking the holder isn't full and that the card is valid.
]]
function ENT:HoldCard( card )
	if self:IsHoldingCard() or not IsValid(card) or not self:CanHold(card) then
		error( "ENT:HoldCard() called improperly - card = " .. tostring(card) .. ", self.HeldCard = " .. tostring(self.HeldCard), 2 )
		return
	end
	
	local phys = card:GetPhysicsObject()
	
	-- Freeze card
	phys:Sleep()
	phys:EnableMotion( false )
	
	-- Drop if held by player's E, or gravity gun
	DropEntityIfHeld( card )
	
	-- Move to our hold point/angles & parent
	card:SetPos( self:LocalToWorld(self.GrabOffset) )
	card:SetAngles( self:LocalToWorldAngles(self.HoldAngle) )
	
	self.HeldCard = card
	card:SetHolder( self )
	
	-- TRIGGERED
	self:TriggerOutput( "OnCardGrabbed", self )
end


--[[
	Name:	ENT:ReleaseCard()
	Desc:	Releases the card currently being held, causing it to fall to the floor.
]]
function ENT:ReleaseCard()
	if not self:IsHoldingCard() then return end
	
	local card = self.HeldCard
	local phys = card:GetPhysicsObject()
	
	-- Unparent
	card:SetParent( nil )
	
	-- Unfreeze card
	phys:Wake()
	phys:EnableMotion( true )
	
	-- The card is no longer ours, think soon (to avoid grabbing it again)
	self.HeldCard = nil
	card:SetHolder( nil )
	
	self:TriggerOutput( "OnCardReleased", self )
	self:NextThink( CurTime() + self.RegrabDelay )
end