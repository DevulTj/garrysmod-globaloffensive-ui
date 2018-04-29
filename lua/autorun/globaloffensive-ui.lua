--[[
  Global Offensive UI
  Created by http://steamcommunity.com/id/Devul/
  Do not redistribute this software without permission from authors
]]--

goUI = goUI or {}

local function findInFolder( currentFolder )
	currentFolder = currentFolder or rootFolder

	local files, folders = file.Find( currentFolder .. "*", "LUA" )

	for _, File in pairs( files ) do
		if SERVER and File:find( "sv_" ) then
			include( currentFolder .. File )
		elseif File:find( "cl_" ) then
			if SERVER then AddCSLuaFile( currentFolder .. File )
			else include( currentFolder .. File ) end
		elseif File:find( "sh_" ) then
			if SERVER then AddCSLuaFile( currentFolder .. File ) end
			include( currentFolder .. File )
		end
	end

	for _, folder in pairs( folders ) do
		findInFolder( currentFolder .. folder .. "/" )
	end
end

findInFolder( "globaloffensive-ui/" )

if SERVER then
	resource.AddWorkshop( "1373295374" )
end
