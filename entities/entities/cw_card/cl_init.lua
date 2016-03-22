--[[
	File:		cw_card/cl_init.lua
	Author:	toneo
	Realm:	Client
	
	This represents a card in Card Wars. Lots of stuff here.
]]--
include( "shared.lua" )

surface.CreateFont( "CardTitle", {
	font = "Arial",
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont( "CardDetail", {
	font = "Arial",
	size = 36,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

surface.CreateFont( "CardDesc", {
	font = "Trebuchet",
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

local function wrapLines( str, font, maxWidth )
	local lines = {}
	local lastSplit, lastSpace = 1, -1
	
	surface.SetFont( font )
	
	for i = 1, string.len(str) do
		local width = surface.GetTextSize( string.sub( str, lastSplit, i ) )
		
		if str[i] == ' ' then
			lastSpace = i
		end
		
		if width > maxWidth then
			-- Roll back to the last space if there is one...
			local line
			
			if lastSpace > -1 then
				line = string.sub( str, lastSplit, lastSpace )
				i = lastSpace
			else
				-- Otherwise wrap directly
				line = string.sub( str, lastSplit, i )
			end
			
			table.insert( lines, line:Trim() )
			
			lastSplit = i + 1
			lastSpace = -1
		end
	end
	
	table.insert( lines, string.sub( str, lastSplit ) )
	
	return lines
end

-- temp
function ENT:Initialize()
	
	self:SetMaterial( "models/cardwars/cards/base" )
	self.savedLines = false
	
	-- Set some card details to reasonable defaults
	self.ID = nil
	self.Name = "John Cena"
	self.DescLines = {}
	self.Health = 100
	self.Count = 1
	self.IsHero = true
	self.PortraitMaterial = Material( "debug/debugwhite" )
	
end

function ENT:Think()
	
	-- Think every tick until we get a valid ID. This is somewhat hacky, but is not an expensive method.
	if ( self:GetCardIDString() ~= 0 ) and not self.ID then
		
		local id = util.NetworkIDToString( self:GetCardIDString() )
		self:UpdateDetails( id )
		
		-- We won't need to think again
		self:NextThink( CurTime() + 50000 )
		return true
		
	else
		
		self:NextThink( CurTime() )
		return true
		
	end
	
end

function ENT:UpdateDetails( id )
	
	local definitions = GAMEMODE.CardDefinitions
	
	if not definitions then
		error( "FATAL: GAMEMODE.CardDefinitions is not defined!" )
	end
	
	-- Make sure the definition exists
	local entry = definitions[ id ]
	
	if not entry then
		--error( "Invalid id passed to ENT:UpdateDetails()! id=" .. tostring(id), 2 )
		return
	end
	
	-- Finally retrieve details
	self.ID = id
	self.Name = entry.Name
	self.CardHealth = entry.Health
	self.Count = entry.Count
	self.IsHero = entry.IsHero
	self.PortraitMaterial = Material( entry.PortraitMaterial or "missingtexture" )
	self.DescLines = wrapLines( entry.Description, "CardDesc", 350 )
	
end

function ENT:Draw()
	
	self:DrawModel()
	
	if self.ID then
		self:DrawOverlay()
	end
	
end

function ENT:DrawOverlay()
	
	local name = self.Name
	local hp = self.CardHealth
	local count = self.Count
	local portrait = self.PortraitMaterial
	local descLines = self.DescLines
	
	-- Don't draw if surface.SetMaterial() would fail. If we do try this we'll fuck up the camera and turn the world into nodraw.
	if not portrait or portrait:IsError() then
		print( "portrait=", portrait )
		return
	end
	
	local angles = self:GetAngles()
	local angles2D = Angle()
	
	local titleColor = Color(255, 255, 255, 255)
	if self.IsHero then
		titleColor = Color(150, 70, 150, 255)
	end
	
	-- Copy our angles in 3D space, rotate so that the draw plane faces outwards.
	angles2D:Set( angles )
	angles2D:RotateAroundAxis( angles:Up(), 90 )
	angles2D:RotateAroundAxis( angles:Right(), -90 )
	
	-- Reposition the draw plane so it is on the front of the model.
	local origin = self:GetPos() + angles:Forward() * 0.6 + angles:Up() * 15 + angles:Right() * 5
	
	cam.Start3D2D( origin, angles2D, 0.025 )
		draw.SimpleText( name, "CardTitle", 18, 120, titleColor )
		
		draw.SimpleText( tostring(hp), "CardDetail", 288, 71, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER )
		draw.SimpleText( "x" .. count, "CardDetail", 353, 71, Color(0, 130, 255, 255), TEXT_ALIGN_CENTER )
		
		surface.SetMaterial( portrait )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 120, 183, 160, 160 )
		
		for k, v in pairs( self.DescLines ) do
			draw.SimpleText( v, "CardDesc", 18, 360 + (k-1) * 30, Color(255, 255, 255, 255) )
		end
	cam.End3D2D()
	
end

function ENT:SetCardID( id )
	error( "ENT:SetCardID() called clientside! This will never work.", 2 )
end