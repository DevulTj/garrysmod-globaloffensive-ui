--[[
  Global Offensive UI
  Created by http://steamcommunity.com/id/Devul/
  Do not redistribute this software without permission from authors


]]--

goUI.dataChecks = {}

function goUI.addDataCheck( varToCheck, callback )
    goUI.dataChecks[ varToCheck ] = callback
end

goUI.addDataCheck( "showURL", function( data, frame )
    local html = frame.panel:Add( "HTML" )
    html:Dock( FILL )
    html:OpenURL( data.showURL )
end )

goUI.addDataCheck( "text", function( data, frame )
    local label = frame.panel:Add( "DLabel" )
    label:Dock( FILL )
    label:SetText( data.text or "" )
    label:SetFont( "goUIMedium" )
    label:SetTextColor( color_white )
    label:SetContentAlignment( 7 )
    label:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )
end )

goUI.addDataCheck( "callback", function( data, frame )
    if data.callback then data.callback( frame.panel ) end
end )

goUI.addDataCheck( "staff", function( data, frame )
    local staffGroups = data.staff
    if not staffGroups then return end

    local scroll = frame.panel:Add( "DScrollPanel" )
    scroll:Dock( FILL )

    local layout = scroll:Add( "DIconLayout" )
    layout:Dock( FILL )

    layout:SetSpaceX( 4 )
    layout:SetSpaceY( 4 )

    local groupUsers = {}
    for Id, client in ipairs( player.GetAll() ) do
        local usergroup = client:GetUserGroup()
        if not staffGroups[ usergroup ] then continue end

        if not groupUsers[ usergroup ] then groupUsers[ usergroup ] = {} end
        groupUsers[ usergroup ][ Id ] = client
    end

    for userGroup, clients in SortedPairs( groupUsers ) do
        local groupData = staffGroups[ userGroup ]

        local _layout = layout:Add( "DIconLayout" )
        _layout:Dock( TOP )
        _layout:DockMargin( 0, 0, 0, 4 )
        _layout:SetTall( 158 )

        _layout:SetSpaceX( 4 )
        _layout:SetSpaceY( 4 )

        local label = _layout:Add( "DLabel" )
        label:Dock( TOP )
        label:SetText( groupData.name or userGroup )
        label:SetFont( "goUIMedium" )
        label:SetTextColor( groupData.color or color_white )
        label:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )

        for _, client in pairs( clients ) do
            local usergroup = client:GetUserGroup()

            if groupData then
                local avatar = _layout:Add( "AvatarImage" )
                avatar:SetSize( 128, 128 )
                avatar:Center()
                avatar:SetPlayer( client, 128 )

                local button = avatar:Add( "DButton" )
                button:SetSize( 128, 128 )
                button:SetText( client:Nick() )
                button:SetFont( "goUIMedium" )
                button:SetContentAlignment( 2 )
                button:SetExpensiveShadow( 1, color_black )
                button:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )

                button.textCol = 255
                button.boxY = button:GetTall() / 2
                button.Paint = function( self, w, h )
                    local buttonColor = groupData.color

                    local hovered = self:IsHovered()

                    self.boxY = math.Clamp( hovered and ( self.boxY - 2 ) or ( self.boxY + 2 ), 0, self:GetTall() / 2 )
                    surface.SetDrawColor( Color( buttonColor.r, buttonColor.g, buttonColor.b, 75 ) )
                    surface.SetMaterial( Material( "vgui/gradient_up" ) )
                    surface.DrawTexturedRect( 0, self.boxY, w, h )

                    surface.SetDrawColor( Color( buttonColor.r, buttonColor.g, buttonColor.b, 255 ) )
                    surface.DrawOutlinedRect( 0, 0, w, h )

                    self:SetTextColor( color_white )
                end
            end
        end
    end
end )

goUI.addDataCheck( "servers", function( data, frame )
    local servers = data.servers
    if not servers then return end

    local label = frame.panel:Add( "DLabel" )
    label:SetText( "Click one of the server buttons below to join our servers!" )
    label:SetFont( "goUILarge-Secondary" )
    label:SetTextColor( color_white )
    label:Dock( TOP )
    label:DockMargin( 0, 0, 0, 12 )
    label:SizeToContents()
    label:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )

    local layout = frame.panel:Add( "DIconLayout" )
    layout:Dock( FILL )
    layout:SetSpaceX( 4 )
    layout:SetSpaceY( 4 )

    for serverName, serverInfo in pairs( servers ) do
        local server = layout:Add( "goUIServerButton" )
        server:SetSize( 320, 256 )
        server:setText( serverName )
        server:setDesc( serverInfo.desc )
        server:setJoinText( serverInfo.joinText )
        server:setServerIcon( serverInfo.icon )
        server:setIP( serverInfo.ip )

        server:setUp()
    end
end )

local function DrawRoundedBox( _r, _x, _y, _w, _h )
	_r = _r > 8 and 16 or 8
	local _u = ( _x + _r * 1 ) - _x
	local _v = ( _y + _r * 1 ) - _y
	
	local points = 64
	local slices = ( 2 * math.pi ) / points
	local poly = {  }
	
	X, Y = _w-_r, _h-_r
	
	for i = 0, points-1 do
		local angle = ( slices * i ) % points
		local x = X + _r * math.cos( angle )
		local y = Y + _r * math.sin( angle )
		
		if i == points/4-1 then
			X, Y = _x+_r, _h-_r
			table.insert( poly, { x = X, y = Y, u = _u, v = _v } )
		elseif i == points/2-1 then
			X, Y = _x, _r
			table.insert( poly, { x = X, y = Y, u = _u, v = _v } )
			X = _x+_r
		elseif i == 3*points/4-1 then
			X, Y = _w-_r, 0
			table.insert( poly, { x = X, y = Y, u = _u, v = _v } )
			Y = _r
		end
		
		table.insert( poly, { x = x, y = y, u = _u, v = _v } )
	end
	
	return poly
end

local maskMaterial = Material( "effects/flashlight001" )
local function attachText( parent, blockInfo )
    local container = parent:Add( "Panel" )
    container:Dock( FILL )

    if blockInfo.image then
        local roundedPoly = DrawRoundedBox( 8, 0, 0, parent:GetWide(), parent:GetTall() )
        container.Paint = function( this, w, h )
            render.ClearStencil()
            render.SetStencilEnable(true)
        
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
        
            render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
            render.SetStencilPassOperation( STENCILOPERATION_ZERO )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
            render.SetStencilReferenceValue( 1 )
        
            surface.SetMaterial( maskMaterial )
            surface.SetDrawColor( color_black )
            surface.DrawPoly( roundedPoly )
                
            render.SetStencilFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
            render.SetStencilReferenceValue( 1 )
        
            surface.SetDrawColor( color_white )
            surface.SetMaterial( blockInfo.image )
            surface.DrawTexturedRect( 1, 1, w - 2, h - 2 )

            render.SetStencilEnable(false)
            render.ClearStencil()
        end
    end

    local pCol = goUI.getClientData( "main_color", color_white )

    local innerContainer = container:Add( "Panel" )
    innerContainer:Dock( FILL )
    innerContainer:DockMargin( 16, 16, 16, 16 )

    local sub = innerContainer:Add( "DLabel" )
    sub:SetText( blockInfo.sub or "" )
    sub:SetFont( "goUIMedium-Secondary" )
    sub:Dock( TOP )
    sub:SizeToContents()
    sub:SetTextColor( pCol )
    sub:SetExpensiveShadow( 2, Color( 0, 0, 0, 150 ) )

    local title = innerContainer:Add( "DLabel" )
    title:SetText( blockInfo.text or "" )
    title:SetFont( "goUIHuge-Secondary" )
    title:Dock( FILL )
    title:DockMargin( 0, 0, 80, 0 )
    title:SetContentAlignment( 7 )
    title:SetWrap( true )
    title:SetTextColor( pCol )
    title:SetExpensiveShadow( 2, Color( 0, 0, 0, 150 ) )
end

local blockContainerW, blockContainerH = 540 * 2, 450
goUI.addDataCheck( "blocks", function( data, frame )
    local blocks = data.blocks
    if not blocks then return end

    local parentContainer = frame.panel:Add( "Panel" )
    parentContainer:Dock( TOP )
    parentContainer:SetTall( blockContainerH )

    local blockContainer = parentContainer:Add( "DPanel" )
    blockContainer:SetSize( blockContainerW, blockContainerH )

    blockContainer.Paint = function( this, w, h )
        draw.RoundedBox( 8, 1, 1, w - 2, h - 2, Color( 200, 200, 200, 10 ) )
        draw.RoundedBox( 8, 2, 2, w - 4, h - 4, Color( 150, 150, 150, 255 ) )
    end

    local blockOne = blockContainer:Add( "DPanel" )
    blockOne:Dock( LEFT )
    blockOne:DockMargin( 4, 4, 0, 4 )
    blockOne:SetWide( blockContainerW / 2 )
    blockOne:InvalidateParent( true )

    blockOne.Paint = function( this, w, h )
        surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
        surface.DrawRect( w - 1, 0, 1, h )
    end

    attachText( blockOne, blocks[ 1 ] )

    local blockTwo = blockContainer:Add( "DPanel" )
    blockTwo:Dock( TOP )
    blockTwo:DockMargin( 0, 4, 4, 0 )
    blockTwo:SetTall( blockContainerH / 2 )
    blockTwo:InvalidateParent( true )

    blockTwo.Paint = function( this, w, h )
        surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
        surface.DrawRect( 0, 0, 1, h )

        surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
        surface.DrawRect( 0, h - 1, w, 1 )
    end

    attachText( blockTwo, blocks[ 2 ] )

    local blockThree = blockContainer:Add( "DPanel" )
    blockThree:Dock( FILL )
    blockThree:DockMargin( 0, 0, 4, 4 )
    blockThree:SetTall( blockContainerH / 2 )
    blockThree:InvalidateParent( true )

    blockThree.Paint = function( this, w, h )
        surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
        surface.DrawRect( 0, 0, 1, h )

        surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
        surface.DrawRect( 0, 0, w, 1 )
    end

    attachText( blockThree, blocks[ 3 ] )
end )

local gradient = Material( "gui/gradient" )
goUI.addDataCheck( "greeting", function( data, frame )
    frame.greeting = frame.panel:Add( "DLabel" )
    frame.greeting:Dock( TOP )
    frame.greeting:DockMargin( 0, 0, 0, 8 )
    frame.greeting:SetText( data.greeting )
    frame.greeting:SetFont( "goUILarge-Secondary" )
    frame.greeting:SetTextColor( goUI.getClientData( "main_color", color_white ) )
    frame.greeting:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )
    frame.greeting:SizeToContents()
end )

local funcs = {
    darkrp = function( player ) return player.getDarkRPVar and player:getDarkRPVar( "money", 0 ) or 20 end,
    pointshop = function( player ) return player.PS_GetPoints and player:PS_GetPoints() or 10 end
}

goUI.addDataCheck( "currency", function( data, frame )
    if IsValid( frame.currencyLayout ) then
        frame.currencyLayout:Remove()
    end
    
    frame.currencyLayout = frame:Add( "Panel" )
    frame.currencyLayout:SetSize( 400, 32 )
    frame.currencyLayout:SetPos( frame:GetWide() - frame.currencyLayout:GetWide() - 52, 32 )

    for _, currencyInfo in pairs( data.currency or {} ) do
        local button = frame.currencyLayout:Add( "DButton" )
        button:Dock( RIGHT )
        button:SetWide( 128 )
        button:SetText( "" )

        local pCol = goUI.getClientData( "main_color", color_white )
        button.Paint = function( this, w, h )
            surface.SetMaterial( currencyInfo.image )
            surface.SetDrawColor( pCol )
            surface.DrawTexturedRect( 0, 8, 16, 16 )

            local moneyText
            if currencyInfo.darkrp then
                moneyText = funcs.darkrp( LocalPlayer() ) or 30
            elseif currencyInfo.pointshop then
                moneyText = funcs.pointshop( LocalPlayer() ) or 20
            else
                moneyText = currencyInfo.callback( LocalPlayer() ) or 0
            end

            draw.SimpleText( moneyText, "goUIMedium-Secondary", w / 2, h / 2 + 1, pCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            //draw.SimpleText( moneyText, "goUIMedium-Secondary-Blurred", w / 2, h / 2, Color( 255, 255, 255, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
end )

goUI.addDataCheck( "options", function( data, frame )
    local settingsPanel = frame.panel:Add( "goUISettingsPanel" )
    settingsPanel:setUp()
end )

function goUI.getCallback( data, frame )
    if not data then return end
    if not IsValid( frame ) then return end

    for var, callback in pairs( goUI.dataChecks ) do
        if data[ var ] then callback( data, frame ) end
    end
end
