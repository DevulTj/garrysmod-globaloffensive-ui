--[[
  Global Offensive UI
  Created by http://steamcommunity.com/id/Devul/
  Do not redistribute this software without permission from authors


]]--

hook.Add( "loadFonts" , "fonts", function()
	local fontFace = goUI.getClientData( "font", "Stratum2-Medium" )
	local secondaryFontFace = goUI.getClientData( "font_secondary", "Stratum2-Medium" )

	surface.CreateFont( "goUIHuge-Secondary", {
		font = secondaryFontFace,
		size = 48,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "goUILarge", {
		font = fontFace,
		size = 32,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "goUILarge-Secondary", {
		font = secondaryFontFace,
		size = 32,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "goUIMediumLarge-Secondary", {
		font = secondaryFontFace,
		size = 28,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "goUIMediumLarge-Secondary-Blurred", {
		font = secondaryFontFace,
		size = 28,
		weight = 500,
		antialias = true,
		blursize = 2
	} )

	surface.CreateFont( "goUILargeThin", {
		font = fontFace,
		size = 30,
		weight = 0,
		antialias = true
	} )

	surface.CreateFont( "goUIMedium", {
		font = fontFace,
		size = 24,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "goUIMedium-Secondary", {
		font = secondaryFontFace,
		size = 24,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "goUIMedium-Blurred", {
		font = fontFace,
		size = 24,
		weight = 500,
		antialias = true,
		blursize = 2
	} )

	surface.CreateFont( "goUIMedium-Secondary-Blurred", {
		font = secondaryFontFace,
		size = 24,
		weight = 500,
		antialias = true,
		blursize = 2
	} )

	surface.CreateFont( "goUISmall", {
		font = fontFace,
		size = 16,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "goUISmall-Secondary", {
		font = secondaryFontFace,
		size = 18,
		weight = 500,
		antialias = true
	} )
end )

hook.Call( "loadFonts" )

local blur = Material( "pp/blurscreen" )
function goUI.drawBlurAt( x, y, w, h, amount, passes )
	amount = amount or 4

	surface.SetMaterial( blur )
	surface.SetDrawColor( color_white )

	local scrW, scrH = ScrW(), ScrH()
	local _x, _y = x / scrW, y / scrH
	local _w, _h = ( x + w ) / scrW, ( y + h ) / scrH

	for i = - passes or 0.15, 1, 0.15 do
		blur:SetFloat( "$blur", i * amount )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _w, _h )
	end
end
