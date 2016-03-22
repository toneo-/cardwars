--[[
	File:		round.lua
	Author:	toneo
	Realm:	Server
	
	Round module. Handles starting/finishing rounds.
]]--

-- Which round we're on
GM.RoundNumber = 0
GM.RoundInProgress = false

GM.RedTeamNPCs = {}
GM.BlueTeamNPCs = {}

GM.RESULT_DRAW = 0

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
	
	self:GetAllDefinitions( self.RedHolders, redCards )
	self:GetAllDefinitions( self.BlueHolders, blueCards )
	
	local redSpawns = ents.FindByClass( "cw_npc_spawn_red" )
	local blueSpawns = ents.FindByClass( "cw_npc_spawn_blue" )
	
	local redNPCs = {}
	local blueNPCs = {}
	
	-- Spawn all cards
	self:SpawnCards( redCards, redSpawns, redNPCs, "red" )
	self:SpawnCards( blueCards, blueSpawns, blueNPCs, "blue" )
	
	-- Make red NPCs hate blue and vice versa, whilst also not teamkilling
	self:ModifyRelationships( redNPCs, blueNPCs )
	
	self.RedTeamNPCs = redNPCs
	self.BlueTeamNPCs = blueNPCs

	print( "Card Wars: Round " .. roundNo .. " started" )
	
end


--[[
	Name:	GM:EndRound( result )
	Desc:	Called the round has ended.
]]
function GM:EndRound( result )
	
	if not self:IsRoundInProgress() then
		error( "Attempt to end round when round was not already in progress!", 2 )
	end
	
	self.RoundInProgress = false
	
	print( "Card Wars: Round " .. self.RoundNumber .. " ended, result was ", result )
	
	-- Delete all straggler NPCs
	for k, v in pairs( self.RedTeamNPCs ) do
		if IsValid(v) then v:Remove() end
	end
	
	for k, v in pairs( self.BlueTeamNPCs ) do
		if IsValid(v) then v:Remove() end
	end
	
	self.RedTeamNPCs = {}
	self.BlueTeamNPCs = {}
	
end

function GM:IsRoundInProgress()
	return self.RoundInProgress
end

function GM:OnNPCKilled( npc, attacker, inflictor )
	
	-- Try and remove the npc from red team, and if that fails, from blue.
	if not	table.RemoveByValue( self.RedTeamNPCs, npc ) then
				table.RemoveByValue( self.BlueTeamNPCs, npc ) end
	
	self:CheckForWin()
	
end

function GM:CheckForWin()
	
	if not self:IsRoundInProgress() then return end
	
	-- Check how many NPCs are left in each team.
	local redCount = table.Count( self.RedTeamNPCs )
	local blueCount = table.Count( self.BlueTeamNPCs )
	
	local redLose = redCount == 0
	local blueLose = blueCount == 0
	
	-- Red win if blue lost and red didn't lose.
	-- Blue win if red lost and blue didn't lose.
	-- Draw if both lost.
	
	if redLose then
		if blueLose then
			self:EndRound( self.RESULT_DRAW )
		else
			self:EndRound( self.TEAM_BLUE )
		end
	elseif blueLose then
		self:EndRound( self.TEAM_RED )
	end
	
	-- If execution reaches this point, the game must go on
	
end

function GM:SpawnCards( cards, spawnList, npcList, team )

	-- For each card, pick a random spawnpoint
	for k, card in pairs( cards ) do
	
		local randomSpawn = table.Random( spawnList )
		local spawnedNPCs
		
		if not randomSpawn then
			print( "WARNING: Ran out of spawn points for NPCs! The game will run badly!" )
			return
		end
		
		-- Spawn the NPCs at the given point
		spawnedNPCs = self:SpawnCardNPC( card, randomSpawn, team )
		
		-- Keep track of the created NPCs
		for _, npc in pairs( spawnedNPCs ) do
			table.insert( npcList, npc )
		end
		
		-- Don't re-use this spawn point
		table.RemoveByValue( spawnList, randomSpawn )
		
	end
	
end

function GM:ModifyRelationships( redNPCs, blueNPCs )
	
	-- Change the relationship of each NPC.. this requires lots of iteration.
	for k, red in pairs( redNPCs ) do
	
		-- Make them like everything
		red:AddRelationship( "npc_* D_LI 50" )
		red:AddRelationship( "player D_LI 99" )
		
		-- Except enemy NPCs
		for l, blue in pairs( blueNPCs ) do
			red:AddEntityRelationship( blue, D_HT, 70 )
			red:SetEnemy( blue )
		end
		
	end
	
	for l, blue in pairs( blueNPCs ) do
	
		-- Make them like everything
		blue:AddRelationship( "npc_* D_LI 50" )
		blue:AddRelationship( "player D_LI 99" )
		
		-- Except enemy NPCs
		for k, red in pairs( redNPCs ) do
			blue:AddEntityRelationship( red, D_HT, 70 )
			blue:SetEnemy( red )
		end
		
	end
	
end

function GM:GetAllDefinitions( holderList, definitionList )
	for _, holder in pairs( holderList ) do
		
		-- Discard any without a card being held
		if holder:IsHoldingCard() then
			local cardID = holder:GetHeldCard():GetCardID()
			
			-- If card has a valid definition ID, add to definition list
			if cardID then
				local definition = self:LookupDefinition( cardID )
				
				if definition then
					table.insert( definitionList, definition )
				end
			end
		end
		
	end
end

-- Spawns 1 or more npcs on a card
function GM:SpawnCardNPC( cardDefinition, spawnpoint, team )
	
	local ChangeModel = cardDefinition[ "ChangeModel" ]
	local Count = 1 --cardDefinition[ "Count" ]
	local DamageSettings = cardDefinition[ "DamageSettings" ]
	local Health = cardDefinition[ "Health" ]
	local KeyValues = cardDefinition[ "KeyValues" ]
	local SpawnClass = cardDefinition[ "SpawnClass" ]
	local SpawnFlags = cardDefinition[ "SpawnFlags" ]
	local SquadGroup = cardDefinition[ "SquadGroup" ] or "nogroup"
	local WeaponClass = cardDefinition[ "WeaponClass" ]
	local WeaponProficiency = cardDefinition[ "WeaponProficiency" ]
	
	local spawnPos = spawnpoint:GetPos()
	
	-- TODO: Adjust position for multiple NPCs as otherwise things will be screwy
	local spawned = {}
	
	for i = 1, Count do
		local npc = ents.Create( SpawnClass )
		
		if not IsValid( npc ) then
			error( "Attempt to spawn invalid NPC class " .. tostring(SpawnClass) .. "!" )
		end
		
		-- TODO: Implement position offsets
		npc:SetPos( spawnPos )
		npc:SetAngles( spawnpoint:GetAngles() )
		
		npc:SetMaxHealth( Health )
		npc:SetHealth( Health )
		
		if ChangeModel then npc:SetModel( ChangeModel ) end
		if SpawnFlags then npc:SetKeyValue( "spawnflags", SpawnFlags ) end
		if WeaponClass then npc:SetKeyValue( "additionalequipment", tostring(WeaponClass) ) end
		
		-- Additional key values?
		if KeyValues then
			for k, v in pairs(KeyValues) do
				npc:SetKeyValue( tostring(k), tostring(v) )
			end
		end
		
		npc:SetKeyValue( "SquadName", "team_" .. tostring(team) .. "_" .. SquadGroup )
		npc:SetKeyValue( "wakeradius", "25000.00" )
		npc:SetKeyValue( "ignoreunseenenemies", "0" )
		
		npc:Spawn()
		npc:Activate()
		
		npc:DropToFloor()
		
		npc.DamageSettings = DamageSettings
		
		-- This should hopefully make npcs wake up
		
	--setpos 412.729614 8.207086 -447.968750;setang 10.094780 -104.384445 0.000000
	
		--
		timer.Simple( 0.5, function()
			npc:SetSaveValue( "m_vecLastPosition", Vector( 412, 8, -447.968750 ) )
			npc:SetSchedule( SCHED_ALERT_WALK )
		end )
		
		--npc:TakeDamage( 1 )
		
		if WeaponProficiency then npc:SetCurrentWeaponProficiency( WeaponProficiency ) end
		
		table.insert( spawned, npc )
	end
	
	return spawned
end