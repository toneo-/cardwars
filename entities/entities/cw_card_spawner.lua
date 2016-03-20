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
	
		local definitions = GAMEMODE.CardDefinitions
		if not definitions then
			error( "GAMEMODE.CardDefinitions is nil! Oops!" )
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
		
		-- Stores card 
		card:SetCardID( chosenID )
		
		card:Spawn()
		
	end
	
end

