--[[
	File:		sh_chat.lua
	Author:	toneo
	Realm:	Shared
	
	This file handles coloured chat messages.
]]--

if SERVER then
	
	module( "fancychat", package.seeall )

	util.AddNetworkString( "FancyChatMessage" )

	function Broadcast( ... )
		
		local parts = { ... }
		
		net.Start( "FancyChatMessage" )
			net.WriteTable( parts )
		net.Broadcast()
		
	end
	
else
	
	-- Client just needs to receive & pipe into chat.AddText
	net.Receive( "FancyChatMessage", function( length )
		
		local parts = net.ReadTable()
		chat.AddText( unpack( parts ) )
		
	end )
	
end