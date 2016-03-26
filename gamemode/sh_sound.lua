--[[
	File:		sh_sound.lua
	Author:	toneo
	Realm:	Shared
	
	This file handles sounds which are played directly on the client.
]]--

if SERVER then
	
	module( "netsound", package.seeall )

	util.AddNetworkString( "PlaySound" )

	function PlayToAll( sound )
		
		net.Start( "PlaySound" )
			net.WriteString( sound )
		net.Broadcast()
		
	end
	
else
	
	net.Receive( "PlaySound", function( length )
		
		local sound = net.ReadString()
		surface.PlaySound( sound )
		
	end )
	
end