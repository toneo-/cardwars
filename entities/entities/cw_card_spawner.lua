--[[
	File:		cw_card_spawner.lua
	Author:	toneo
	Realm:	Server
	
	This represents a card spawner, which spawns cards on demand.
]]--

-- Point entities have no model and are extremely cheap.
ENT.Type = "point"

--[[
	Name:	ENT:Think()
	Desc:	Called when this entity needs to think.
]]
function ENT:Think()
	-- Spawn points never need to do anything.
	self:NextThink( CurTime() + 50000 )
end


--[[
	Name:	ENT:AcceptInput( inputName, activator, caller, data )
	Desc:	Called when an input is triggered.
]]
function ENT:AcceptInput( inputName, activator, caller, data )
	
	if inputName == "SpawnCard" then
		self:SpawnCard()
	end
end

function ENT:SpawnCard()
	
	local definitions = GAMEMODE.CardDefinitions
	if not definitions then
		error( "GAMEMODE.CardDefinitions is nil! Oops!" )
	end
	
	-- If we need to spawn into a given entity check it exists - if it doesn't we can exit
	local spawnInto = self.SpawnInto
	local placeInto
	
	if spawnInto then
		
		local matches = ents.FindByName( spawnInto )
		
		-- Remove all invalid matches
		for k, v in pairs( matches ) do
			if v:GetClass() ~= "cw_card_holder" or v:IsHoldingCard() then
				matches[k] = nil
			end
		end
		
		local numMatches = table.Count( matches )
		
		if numMatches == 0 then
			print( "Mapping error: Unable to spawn card as the name " .. tostring(spawnInto) .. " does not refer to a card holder." )
			return
		elseif numMatches > 1 then
			print( "Mapping error: Refusing to spawn card as the name " .. tostring(spawnInto) .. " is shared by more than one entity." )
			return
		end
		
		-- We have a single card holder - store it!
		placeInto = matches[1]
		
	end
	
	local count = table.Count( definitions )
	local selectIndex = math.random( 1, count ) -- Choose random card
	local chosenID
	
	local card = ents.Create( "cw_card" )
	
	card:SetPos( self:GetPos() )
	card:SetAngles( self:GetAngles() )
	
	-- Grab the selected card from the definition list
	local i = 1
	for k, def in pairs( definitions ) do
	
		if i == selectIndex then
			print( "Selecting random card " .. k )
			chosenID = k
			break
		end
		
		i = i + 1
		
	end
	
	-- Associate this card definition with this card
	card:SetCardID( chosenID )
	card:Spawn()
	
	-- Are we to place the card into a holder?
	if placeInto then
		placeInto:HoldCard( card )
	end
	
end

--[[
	Name:	ENT:KeyValue( key, value )
	Desc:	Called when this entity has a key/value changed.
]]--
function ENT:KeyValue( key, value )
	
	if key == "spawnInto" then
		self.SpawnInto = value
	end
	
end