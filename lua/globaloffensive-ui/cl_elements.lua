--[[
    Global Offensive UI
    Created by http://steamcommunity.com/id/Devul/
    Do not redistribute this software without permission from authors

  
]]--

local gradient = Material( "gui/gradient" )
local gradientr = Material( "vgui/gradient-r" )
local glowMat = Material( "particle/Particle_Glow_04_Additive" )
local blur = Material( "pp/blurscreen" )

function goUI.getMenu()
    return goUIMenu
end

goUI.toggleMenu = function()
    if IsValid( goUIMenu ) then
        goUIMenu:fadeOut()
    else
        goUIMenu = vgui.Create( "goUIFrame" )
        goUIMenu:fadeIn()
    end
end

local FRAME = {}

function FRAME:Init()
    self:DockPadding( 0, 0, 0, 0 )
    self:StretchToParent( 0, 0, 0, 0 )
    self:MakePopup()

    self:setUp()

	self:SetFocusTopLevel( true )
    self:SetKeyBoardInputEnabled( true )
end

function FRAME:canFade()
    if self.fadingIn or self.fadingOut then return false end

    return true
end

function FRAME:fadeIn()
    if not self:canFade() then return end

    self.fadingIn = true

    self:SetAlpha( 0 )
    self:AlphaTo( 255, goUI.getClientData( "fade_time", 0.5 ), 0, function()
        self.fadingIn = false
    end )
end

function FRAME:fadeOut()
    if not self:canFade() then return end

    self.fadingOut = true

    local isAtZero = select( 1, self.background:GetPos() ) == 0 and true or false
    self.background:MoveTo( 0.1, 0, isAtZero and 0 or goUI.getClientData( "element_pressed_fade_time", 0.5 ), 0, -1, function()
        self:AlphaTo( 0, goUI.getClientData( "fade_time", 0.5 ), 0, function()
            self.fadingOut = false
            self:Remove()
        end )
    end )
end

function FRAME:Think()
    if input.IsKeyDown( goUI.getClientData( "menu_key", KEY_F6 ) ) then 
        self:fadeOut()
    end
end

function FRAME:showAvatar()
    if goUI.getClientData( "show_avatar", true ) then
        -- Avatar, party place
        self.headerContainer = self:Add( "Panel" )
        self.headerContainer:SetSize( 512, 32 )
        self.headerContainer:SetPos( 52, 32 )

        self.leftAvatarBound = self.headerContainer:Add( "DPanel" )
        self.leftAvatarBound:Dock( LEFT )
        self.leftAvatarBound:SetWide( 1 )

        self.leftAvatarBound.Paint = function( this, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 100 ) ) 
        end

        self.avatarImage = self.headerContainer:Add( "AvatarImage" )
        self.avatarImage:Dock( LEFT )
        self.avatarImage:SetWide( 32 )
        self.avatarImage:SetPlayer( LocalPlayer(), 64 )

        self.rightAvatarBound = self.headerContainer:Add( "DPanel" )
        self.rightAvatarBound:Dock( LEFT )
        self.rightAvatarBound:SetWide( 1 )

        self.rightAvatarBound.Paint = self.leftAvatarBound.Paint

        self.extraPlayers = self.headerContainer:Add( "DButton" )
        self.extraPlayers:SetText( "" )
        self.extraPlayers:Dock( LEFT )
        self.extraPlayers:DockMargin( 16, 0, 0, 0 )

        self.extraPlayers:SetWide( 40 )
        self.extraPlayers:SetFont( "goUIMedium" )
        self.extraPlayers:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )

        local buttonText = "+" .. player.GetCount()
        self.extraPlayers.alpha = 0
        self.extraPlayers.Paint = function( pnl, w, h )
            local color = pnl.isActive and Color( 230, 230, 230 ) or pnl:IsDown() and Color( 255, 160, 0 ) or pnl:IsHovered() and Color( 255, 200, 0 ) or Color( 175, 175, 175 )
            local colorAlpha = 255

            color = Color( color.r, color.g, color.b, colorAlpha )

            surface.SetDrawColor( color )
            surface.DrawRect( 0, 0, 1, h )
            surface.DrawRect( w - 1, 0, 1, h )

            draw.SimpleText( buttonText, "goUIMedium-Secondary", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( buttonText, "goUIMedium-Secondary-Blurred", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
end

function FRAME:setUp()
    self.background = self:Add( "DPanel" )
    self.background:SetSize( self:GetWide() * 3, self:GetTall() )

    self.background.Paint = function( pnl, w, h )
        local scrW, scrH = ScrW(), ScrH()
        local gradientCol = goUI.getClientData( "gradient_color", color_black )

        draw.RoundedBox( 0, 0, 0, w, h, goUI.getClientData( "main_color", color_black ) )
        draw.RoundedBox( 0, scrW, 0, w - scrW, h, gradientCol )

        if not goUI.getUnEditableData( "background_material_disabled", false ) then
            surface.SetDrawColor( Color( 255, 255, 255, self:GetAlpha() ) )
            surface.SetMaterial( goUI.getUnEditableData( "background_material", Material( "goui/goui_background.png" ) ) )
            surface.DrawTexturedRect( 0, 0, scrW, scrH )
        end

        surface.SetDrawColor( gradientCol )
        surface.SetMaterial( gradientr )
        surface.DrawTexturedRect( scrW * 0.75, 0, scrW * 0.25, h )
    end

    self.buttonLayoutContainer = self:Add( "Panel" )
    self.buttonLayoutContainer:Dock( TOP )
    self.buttonLayoutContainer:DockMargin( 0, 0, 0, 0 )
    self.buttonLayoutContainer:DockPadding( 0, 0, 0, 0 )
    self.buttonLayoutContainer:SetTall( 48 )
    
    self.buttonLayoutContainer.Paint = function( this, w, h )
        BSHADOWS.BeginShadow()
            draw.RoundedBox( 0, 0, 0, w, 48, Color( 0, 0, 20, 150 ) )
        BSHADOWS.EndShadow(1, 2, 2)
        
        BSHADOWS.BeginShadow()
            draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 0, 0, 0, 10 ) )
        BSHADOWS.EndShadow(4, 2, 2)
    end

    local desiredW = ScrW() * 0.55

    self.buttonLayout = self.buttonLayoutContainer:Add( "DIconLayout" )
    self.buttonLayout:SetSize( desiredW, 48 )
    self.buttonLayout:SetPos( ( ScrW() / 2 ) - ( desiredW / 2 ), 0 )

    self.panel = self:Add( "Panel" )
    self.panel:Dock( FILL )
    self.panel:DockMargin( 0, 64, 0, 0 )
    self.panel.Paint = function( pnl, w, h ) end
    self.panel:InvalidateParent( true )
    self:InvalidateParent( true )

    self.panelInner = self:Add( "DPanel" )
    self.panelInner:SetSize( self:GetWide() * 0.65, self:GetTall() - 200 )
    self.panelInner:SetPos( ( ScrW() / 2 ) - ( self.panel:GetWide() / 3 ), self.panel.y )
    self.panelInner.Paint = function( this )
        this:SetAlpha( self.panel:GetAlpha() )
    end

    local widthPerOne = desiredW / ( #goUI.config.ELEMENTS - 1 )
    local firstData = goUI.config.ELEMENTS[ 1 ]

    self.homeButton = self.buttonLayoutContainer:Add( "DButton" )
    self.homeButton:SetPos( self.buttonLayout.x - 48 )
    self.homeButton:SetSize( 48, 48 )
    self.homeButton:SetText( "" )
    self.homeButton.Paint = function( this, w, h )
        surface.SetDrawColor( Color( 255, 255, 255, this:IsHovered() and 255 or this.isActive and 235 or 125 ) )
        surface.SetMaterial( Material( "goui/home.png", "smooth" ) )
        surface.DrawTexturedRect( w / 2 - 12, h / 2 - 12, 24, 24 )
    end
    self.homeButton.isActive = true

    self.homeButton.DoClick = function( this )
        local fadeTime = goUI.getClientData( "element_pressed_fade_time", 0.5 )
        self.panel:AlphaTo( 0, fadeTime, 0, function()
            self.panel:Clear()
            self.panelInner:Clear()
            self.panel:MoveToFront()
            self.panel:AlphaTo( 255, fadeTime, 0 )

            goUI.getCallback( firstData, self )
        end )

        for _, _button in pairs( self.elements ) do
            _button.isActive = false
        end
    
        this.isActive = true
    end

    self.powerButton = self.buttonLayoutContainer:Add( "DButton" )
    self.powerButton:SetPos( self.buttonLayout.x + self.buttonLayout:GetWide() - 8 )
    self.powerButton:SetSize( 48, 48 )
    self.powerButton:SetText( "" )
    self.powerButton.Paint = function( this, w, h )
        surface.SetDrawColor( Color( 255, 255, 255, this:IsDown() and 200 or this:IsHovered() and 255 or 50 ) )
        surface.SetMaterial( Material( "goui/power_button.png", "smooth" ) )
        surface.DrawTexturedRect( w / 2 - 12, h / 2 - 12, 24, 24 )
    end

    self.powerButton.DoClick = function( this )
        if goUI.getClientData( "ask_on_close", false ) then
            goUI.createDialogue(
                "QUIT",
                "Do you want to quit this menu?" ,
                "Yes",
                function( dialogue )
                    self:fadeOut()
                    dialogue:Close()
                end,
                "No",
                function( dialogue )
                    dialogue:Close()
                end )
        else
            self:fadeOut()
        end
    end


    self.elements = {}
    for Id, data in pairs( goUI.config.ELEMENTS ) do
        if data.name == "HOME" then continue end

        self.elements[ Id ] = self.buttonLayout:Add( "DButton" )
        local button = self.elements[ Id ]

        button:SetText( "" )
        button:SetWide( widthPerOne )
        button:Dock( LEFT )

        local buttonText = goUI.getUnEditableData( "element_title_force_uppercase", false ) and string.upper( data.name ) or data.name

        if Id > 2 then
            button:DockMargin( -2, 0, 0, 0 )
        end

        button:SetFont( "goUIMedium" )
        button:SetExpensiveShadow( 1, Color( 0, 0, 0, 185 ) )

        button.alpha = 0
        button.Paint = function( self, w, h )
            local pCol = goUI.getClientData( "main_color", color_white )
            local sCol = goUI.getClientData( "secondary_color", Color( 255, 200, 0 ) )
            local color = self.isActive and Color( pCol.r, pCol.g, pCol.b ) 
                or self:IsDown() and Color( math.clampColor( sCol.r - 35 ), math.clampColor( sCol.g - 35 ), math.clampColor( sCol.b - 35 ) ) 
                    or self:IsHovered() and sCol or Color( math.clampColor( pCol.r - 55 ), math.clampColor( pCol.g - 55 ), math.clampColor( pCol.b - 55 ) )
            local colorAlpha = 255

            if not self.isActive and self:IsHovered() and (self.NextMove or 0) < CurTime() then
                self:MoveToFront()
                self.NextMove = CurTime() + 1
            end

            color = Color( color.r, color.g, color.b, colorAlpha )

            surface.SetDrawColor( Color( 0, 0, 0, 120 ) )
            surface.DrawRect( 0, 0, 3, h )
            surface.DrawRect( w - 3, 0, 3, h )

            if self.isActive then
                -- Background
                surface.SetDrawColor( Color( 150, 150, 150, 50 ) )
                surface.DrawRect( 2, 0, w - 3, h )
            end

            draw.SimpleText( buttonText, "goUIMedium-Secondary", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( buttonText, "goUIMedium-Secondary-Blurred", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        local customCheck = data.customCheck and data.customCheck( LocalPlayer(), button )
        button:SetDisabled( customCheck == false )

        button.UpdateColours = function( pnl, skin )
            if pnl:GetDisabled() then return pnl:SetTextStyleColor( buttonDisabledColor ) end
            if pnl.Depressed or pnl.m_bSelected then return pnl:SetTextStyleColor( buttonDownColor ) end
            if pnl:IsHovered() then return pnl:SetTextStyleColor( buttonHoverColor ) end

            return pnl:SetTextStyleColor( buttonColor )
        end

        local increaseAmount = ScrW() / 6
        button.DoClick = function( pnl )
            local fadeTime = goUI.getClientData( "element_pressed_fade_time", 0.5 )
            self.panel:AlphaTo( 0, fadeTime, 0, function()
                self.panel:Clear()
                self.panelInner:Clear()

                if data.innerTakesFocus then
                    self.panelInner:MoveToFront()
                else
                    self.panel:MoveToFront()
                end

                self.panel:AlphaTo( 255, fadeTime, 0 )

                goUI.getCallback( data, self )
            end )

            for _, _button in pairs( self.elements ) do
                _button.isActive = false
            end

            pnl.isActive = true
            pnl:MoveToFront()

            self.homeButton.isActive = false
        end

        if Id == 1 then
            button.isActive = true
        end
    end

    if firstData then 
        goUI.getCallback( firstData, self )
    end
end

derma.DefineControl( "goUIFrame", nil, FRAME, "DFrame" )

local BUTTON = {}

function BUTTON:Init()
    self:SetFont( "goUIMedium" )
end

function BUTTON:Paint( w, h )
    local buttonColor = color_white

    local isHovered = self:IsHovered()
    local xOverride, yOverride, wOverride, hOverride = self.xOverride or 0, self.yOverride or 0, self.wOverride or w, self.hOverride or h
    draw.RoundedBox( 0, xOverride, yOverride, wOverride, hOverride, Color( buttonColor.r, buttonColor.g, buttonColor.b, isHovered and 255 or 0 ) )

    surface.SetDrawColor( Color( buttonColor.r, buttonColor.g, buttonColor.b, 255 ) )
    surface.DrawOutlinedRect( xOverride, yOverride, wOverride, hOverride )

    self:SetTextColor( isHovered and color_black or color_white )
end

function BUTTON:PaintOver()
    local pressed = self.Depressed or self.m_bSelected

    self.xOverride, self.yOverride = pressed and 1 or nil, pressed and 1 or nil
    self.wOverride, self.hOverride = pressed and ( self:GetWide() - 2 ) or nil, pressed and ( self:GetTall() - 2 ) or nil
end

derma.DefineControl( "goUIDialogueButton", nil, BUTTON, "DButton" )

FRAME = {}

function FRAME:Init()
    self:StretchToParent( 0, 0, 0, 0 )
    self:SetDraggable( false )
    self:ShowCloseButton( false )
    self:MakePopup()
end

function FRAME:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

    surface.SetMaterial( blur )
    surface.SetDrawColor( color_white )

    local x, y = self:LocalToScreen( 0, 0 )

    local scrW, scrH = ScrW(), ScrH()
    for i = 0.2, 1, 0.2 do
        blur:SetFloat( "$blur", i * 4 )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * - 1, y * - 1, scrW, scrH )
    end
end

function FRAME:setUp()
    self.container = self:Add( "EditablePanel" )
    self.container:SetSize( ScrH() * 0.3, ScrH() * 0.3 )
    self.container:Center()

    self.title = self.container:Add( "DLabel" )
    self.title:Dock( TOP )
    self.title:SetText( self.titleText or "THIS IS A TITLE" )
    self.title:SetFont( "goUILarge" )
    self.title:SetTextColor( color_white )
    self.title:SetContentAlignment( 5 )
    self.title:SetHeight( 20 )

    self.text = self.container:Add( "DLabel" )
    self.text:Dock( TOP )
    self.text:SetText( self.textText or "This is some text" )
    self.text:SetFont( "goUIMedium" )
    self.text:SetTextColor( color_white )
    self.text:SetContentAlignment( 5 )
    self.text:SetHeight( 40 )

    self.option1 = self.container:Add( "goUIDialogueButton" )
    self.option1:Dock( TOP )
    self.option1:SetText( self.option1Text or "YES" )
    self.option1:SetHeight( 40 )
    self.option1.DoClick = function( pnl )
        if self.callback1 then return self.callback1( self ) end
    end

    self.option2 = self.container:Add( "goUIDialogueButton" )
    self.option2:Dock( TOP )
    self.option2:DockMargin( 0, 4, 0, 0 )
    self.option2:SetText( self.option2Text or "NO" )
    self.option2:SetHeight( 40 )
    self.option2.DoClick = function( pnl )
        if self.callback2 then return self.callback2( self ) end
    end
end

derma.DefineControl( "goUIDialogueFrame", nil, FRAME, "DFrame" )

goUI.createDialogue = function( title, text, option1, callback1, option2, callback2 )
    goUI.dialogueFrame = vgui.Create( "goUIDialogueFrame" )

    goUI.dialogueFrame.titleText = title
    goUI.dialogueFrame.textText = text

    goUI.dialogueFrame.option1Text = option1
    goUI.dialogueFrame.callback1 = callback1

    goUI.dialogueFrame.option2Text = option2
    goUI.dialogueFrame.callback2 = callback2

    goUI.dialogueFrame:setUp()

    goUI.dialogueFrame:SetAlpha( 0 )
    goUI.dialogueFrame:AlphaTo( 255, goUI.getClientData( "fade_time", 0.5 ), 0 )
end

BUTTON = {}

function BUTTON:Init()
    self:SetText( "" )
end

function BUTTON:setText( text )
    self.textText = text
end

function BUTTON:getText()
    return self.textText
end

function BUTTON:setDesc( desc )
    self.descText = desc
end

function BUTTON:getDesc()
    return self.descText
end

function BUTTON:setJoinText( text )
    self.joinText = text
end

function BUTTON:getJoinText()
    return self.joinText
end

function BUTTON:setServerIcon( mat )
    self.serverIcon = mat
end

function BUTTON:getServerIcon()
    return self.serverIcon
end

function BUTTON:setIP( ip )
    self.ip = ip
end

function BUTTON:getIP()
    return self.ip
end

function BUTTON:setUp()
    self.topPanel = self:Add( "DPanel" )
    self.topPanel:SetSize( self:GetWide(), self:GetTall() / 2 )

    self.bottomPanel = self:Add( "DButton" )
    self.bottomPanel:SetText( "" )
    self.bottomPanel:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.bottomPanel:SetPos( 0, self:GetTall() / 2 )

    self.bottomPanel.boxY = self.bottomPanel:GetTall()
    self.bottomPanel.textCol = 255

    self.bottomPanel.Paint = function( pnl, w, h )
        local hovered = pnl:IsHovered()

        pnl.boxY = math.Clamp( hovered and ( pnl.boxY - 4 ) or ( pnl.boxY + 3 ), 0, self.bottomPanel:GetTall() )
        pnl.textCol = math.Clamp( hovered and ( pnl.textCol - 10 ) or ( pnl.textCol + 10 ), 0, 255 )

        draw.RoundedBox( 0, 0, pnl.boxY, w, h,  color_white )
        draw.RoundedBox( 0, 0, h - 32, w, 1, Color( 150, 150, 150, 255 ) )

        draw.SimpleText( self.joinText or "JOIN", "goUIMedium-Secondary", w / 2, h - 4, Color( pnl.textCol, pnl.textCol, pnl.textCol, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
        draw.SimpleText( self.textText or "SERVER NAME", "goUIMedium-Secondary", 12, 10, Color( pnl.textCol, pnl.textCol, pnl.textCol, 255 ) )

        draw.SimpleText( self.descText or "A garry's mod server.", "goUIMedium-Secondary", 12, 36, Color( pnl.textCol, pnl.textCol, pnl.textCol, 255 ) )
    end

    local icon = self:getServerIcon()

    self.topPanel.iconW, self.topPanel.iconH = self.topPanel:GetSize()
    self.topPanel.PaintOver = function( pnl, w, h )
        local hovered = self.bottomPanel:IsHovered()
        pnl.iconW = math.Clamp( hovered and ( pnl.iconW + 0.25 ) or ( pnl.iconW - 0.25 ), self.topPanel:GetWide(), self.topPanel:GetWide() * 1.02 )
        pnl.iconH = math.Clamp( hovered and ( pnl.iconH + 0.25 ) or ( pnl.iconH - 0.25 ), self.topPanel:GetTall(), self.topPanel:GetTall() * ( 1 + ( 0.02 * ( self.topPanel:GetWide() / self.topPanel:GetTall() ) ) ) )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( icon )
        surface.DrawTexturedRect( 0, 0, pnl.iconW, pnl.iconH )
    end

    self.bottomPanel.DoClick = function( pnl )
        goUI.createDialogue(
            "JOIN SERVER",
            "Do you want join " .. self.textText .. "?" ,
            "Yes",
            function( dialogue )
                dialogue:Close()
                LocalPlayer():ConCommand( "connect " .. self:getIP() )
            end,
            "No",
            function( dialogue )
                dialogue:Close()
            end )
    end
end

function BUTTON:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 75 ) )
    surface.SetMaterial( blur )
    surface.SetDrawColor( color_white )

    local x, y = self:LocalToScreen( 0, 0 )

    local scrW, scrH = ScrW(), ScrH()
    for i = 2, 1, 0.2 do
        blur:SetFloat( "$blur", i * 5 )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * - 1, y * - 1, scrW, scrH )
    end
end

function BUTTON:PaintOver( width, height )
    local pressed = self.Depressed or self.m_bSelected

    self.xOverride, self.yOverride = pressed and 1 or nil, pressed and 1 or nil
    self.wOverride, self.hOverride = pressed and ( width - 2 ) or nil, pressed and ( height - 2 ) or nil
end

derma.DefineControl( "goUIServerButton", nil, BUTTON, "DButton" )
