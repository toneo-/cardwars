--[[
	File:		round.lua
	Author:	toneo
	Realm:	Server
	
	Round module. Handles starting/finishing rounds.
]]--

-- Which round we're on
GM.RoundNumber = 0
GM.RoundInProgress = false

--[[
	Name:	GM:StartRound()
	Desc:	Starts the next round.
]]
function GM:StartRound()
	if self:IsRoundInProgress() then
		error( "Attempt to start round when round was already in progress!", 2 )
	end
	
	local roundNo = self.RoundNumber + 1
	
	self.RoundNumber = roundNo
	self.RoundInProgress = true
	
	-- For each team, find all their cards
	local redCards = {}
	local blueCards = {}
	
	local function extractDefinitions( holderList, defList )
		
		for _, holder in pairs( holderList ) do
		
			if holder:IsHoldingCard() then
				local cardID = holder:GetHeldCard():GetCardID()
				
				-- If card has a valid definition ID, add to definition list
				if cardID then
					local definition = self:LookupDefinition( cardID )
					
					if definition then
						table.insert( defList, definition )
					end
				end
			end
			
		end
		
	end
	
	extractDefinitions( self.RedHolders, redCards )
	extractDefinitions( self.BlueHolders, blueCards )
	
	print( "Card Wars: Round " .. roundNo .. " started" )
	
end


--[[
	Name:	GM:EndRound()
	Desc:	Called to start a round.
]]
function GM:EndRound()
	if not self:IsRoundInProgress() then
		error( "Attempt to end round when round was not already in progress!", 2 )
	end
	
	self.RoundInProgress = false
	
	print( "Card Wars: Round " .. self.RoundNumber .. " ended" )
	
end

function GM:IsRoundInProgress()
	return self.RoundInProgress
end