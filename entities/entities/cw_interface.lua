--[[
	File:		cw_interface.lua
	Author:	toneo
	Realm:	Server
	
	cw_interface allows the map and the gamemode to communicate.
]]--

-- Point entities have no model and are extremely cheap.
ENT.Type = "point"


--[[
	Name:	ENT:AcceptInput( inputName, activator, caller, data )
	Desc:	Called when an input is triggered.
]]
function ENT:AcceptInput( inputName, activator, caller, data )
	
	if inputName == "StartRound" then
		
		if not GAMEMODE:IsRoundInProgress() then
			GAMEMODE:StartRound()
			
			self:TriggerOutput( "OnRoundStarted", self )
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
	
	end

end