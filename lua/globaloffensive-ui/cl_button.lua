--[[
    Global Offensive UI
    Created by http://steamcommunity.com/id/Devul/
    Do not redistribute this software without permission from authors

  
]]--

local BUTTON = {}

function BUTTON:Init()
    self:SetFont( "goUIMedium-Secondary" )
    self:SetTextColor( Color( 0, 0, 0, 0 ) )
end

local topRight = Material( "goui/button/button_topright.png" )
local topRightW, topRightH = 16, 16

function math.clampColor( val )
    return math.Clamp( val, 0, 255 )
end

function BUTTON:Paint( w, h )
    local pCol = goUI.getClientData( "main_color", color_white )
    local sCol = goUI.getClientData( "secondary_color", Color( 255, 200, 0 ) )
    local color = self.isActive and Color( pCol.r, pCol.g, pCol.b ) 
        or self:IsDown() and Color( math.clampColor( sCol.r - 35 ), math.clampColor( sCol.g - 35 ), math.clampColor( sCol.b - 35 ) ) 
            or self:IsHovered() and sCol or Color( math.clampColor( pCol.r - 55 ), math.clampColor( pCol.g - 55 ), math.clampColor( pCol.b - 55 ) )
    local colorAlpha = 255

    color = Color( color.r, color.g, color.b, colorAlpha )


    draw.SimpleText( self:GetText(), "goUIMedium-Secondary", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( self:GetText(), "goUIMedium-Secondary-Blurred", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

derma.DefineControl( "goUIButton", nil, BUTTON, "DButton" )
