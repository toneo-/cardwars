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
end

function ENT:Draw()
	
	self:DrawModel()
	self:DrawOverlay()
	
end

function ENT:DrawOverlay()
	
	local name = util.NetworkIDToString( self:GetCardName() )
	local desc = util.NetworkIDToString( self:GetCardDescription() )
	
	local descLines = self.savedLines
	
	-- Only wrap the description once.
	-- This does mean that it won't re-wrap if :SetCardDescription() is
	-- ever called again, but this is not a big deal.
	if not descLines then
		descLines = wrapLines( desc, "CardDesc", 350 )
		self.savedLines = descLines
	end
	
	
	local hp = self:GetCardHP()
	local count = self:GetCardNPCCount()
	
	local portrait = Material( "cardwars/portraits/combine-soldier" )
	
	local angles = self:GetAngles()
	local angles2D = Angle()
	angles2D:Set( angles )
	angles2D:RotateAroundAxis( angles:Up(), 90 )
	angles2D:RotateAroundAxis( angles:Right(), -90 )--0, 90, 90)
	
	local origin = self:GetPos() + angles:Forward() * 0.6 + angles:Up() * 15 + angles:Right() * 5
	
	cam.Start3D2D( origin, angles2D, 0.025 )
		draw.SimpleText( name, "CardTitle", 18, 120, Color(255, 255, 255, 255) )
		
		draw.SimpleText( tostring(hp), "CardDetail", 288, 71, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER )
		draw.SimpleText( "x" .. count, "CardDetail", 353, 71, Color(0, 130, 255, 255), TEXT_ALIGN_CENTER )
		
		surface.SetMaterial( portrait )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 120, 183, 160, 160 )
		
		for k, v in pairs(descLines) do
			draw.SimpleText( v, "CardDesc", 18, 360 + (k-1) * 30, Color(255, 255, 255, 255) )
		end
	cam.End3D2D()
	
end