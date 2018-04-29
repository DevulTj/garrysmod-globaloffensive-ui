local PANEL = {}

function PANEL:Init()

    self.title = self:Add( "DLabel" )
    self.title:SetText( "GAME OPTIONS" )
    self.title:Dock( TOP )
    self.title:SetFont( "goUILarge" )
    self.title:SetTall( 32 )
    self.title:SetTextInset( ScrW() * 0.25, 0 )
    self.title:SetExpensiveShadow( 1, Color( 0, 0, 0, 150 ) )
    self.title:SetTextColor( color_white )

    self.footerContent = self:Add( "Panel" )
    self.footerContent:Dock( BOTTOM )
    self.footerContent:SetTall( 128 )
    self.footerContent.Paint = function( this, w, h )
        draw.RoundedBox( 0, 0, 0, w, 3, Color( 255, 255, 255, 5 ) )
    end

    self.footer = self.footerContent:Add( "Panel" )
    self.footer:Dock( TOP )
    self.footer:DockMargin( 128, 0, 0, 0 )
    self.footer:SetTall( 40 )

    self:Dock( FILL )
    self:InvalidateParent( true )
end

function PANEL:Paint( w, h ) 
    draw.RoundedBox( 0, 0, 32, w, h - 32, Color( 0, 0, 0, 150 ) )
    draw.RoundedBox( 0, 0, 32, w, 3, Color( 255, 255, 255, 5 ) )
end

local topRight = Material( "goui/button/button_topright.png" )
local topRightW, topRightH = 16, 16

function PANEL:createCategoryButton( parent, categoryId, categoryInfo )
    local button = parent:Add( "DButton" )
    button:Dock( TOP )
    button:SetTall( 48 )
    button:SetText("")

    button.Paint = function( self, w, h )   
        local pCol = goUI.getClientData( "main_color", color_white )
        local sCol = goUI.getClientData( "secondary_color", Color( 255, 200, 0 ) )
        local color = self.isActive and Color( pCol.r, pCol.g, pCol.b ) 
            or self:IsDown() and Color( math.clampColor( sCol.r - 35 ), math.clampColor( sCol.g - 35 ), math.clampColor( sCol.b - 35 ) ) 
                or self:IsHovered() and sCol or Color( math.clampColor( pCol.r - 55 ), math.clampColor( pCol.g - 55 ), math.clampColor( pCol.b - 55 ) )
                
        local colorAlpha = 255

        color = Color( color.r, color.g, color.b, colorAlpha )

        draw.SimpleText( categoryInfo.name, "goUILarge-Secondary", 28 + 1, h/2 + 1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( categoryInfo.name, "goUILarge-Secondary", 28, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    button.DoClick = function( this )
        self:viewOptions( categoryId, categoryInfo )
    end

    return button
end

function PANEL:addTextEntry( parent, value )
    local textEntry = parent:Add( "DTextEntry" )
    textEntry:Dock( RIGHT )
    textEntry:SetWide( 256 )
    textEntry:SetValue( value )
    textEntry:SetFont( "goUIMedium" )

    local color = Color( 0, 0, 0, 125 ) 
    textEntry.Paint = function( this, w, h )
        local isHovered = this:IsHovered()

        if isHovered then
            draw.RoundedBox( 0, 0, 4, w, h - 8, Color( color.r, color.g, color.b, 100 ) )
        end

        local xPos = isHovered and 3 or 0
        local yPos = isHovered and 6 or 4
        local bWidth, bHeight = isHovered and w - 6 or w, isHovered and h - 12 or h - 8
        draw.RoundedBox( 0, xPos, yPos, bWidth, bHeight, Color( color.r, color.g, color.b, 125 ) )

    	this:DrawTextEntryText( color_white, Color( 125, 0, 0, 125 ), Color( 200, 200, 200, 200 ) )
    end

    textEntry.OnChange = function( this )
        goUI.setClientData( parent.varName, this:GetValue() )
    end
end

function PANEL:addBoolean( parent, value )
    local button = parent:Add( "DButton" )
    button:SetText( "" )
    button:Dock( RIGHT )
    button:SetWide( 256 )

    button.Paint = function( this, w, h )
        local activeColor = goUI.getClientData( "main_color", color_white )
        local notActiveColor = Color( 0, 0, 0, 255 )

        local desiredBoxColor = value and Color( activeColor.r, activeColor.g, activeColor.b, 200 ) or Color( notActiveColor.r, notActiveColor.g, notActiveColor.b, 100 )
        local desiredBoxColorInverted = not value and Color( activeColor.r, activeColor.g, activeColor.b, 200 ) or Color( notActiveColor.r, notActiveColor.g, notActiveColor.b, 100 )

        -- Yes
        draw.RoundedBox( 0, 0, 4, w / 2, h - 8, desiredBoxColor )
        draw.SimpleText( "YES", "goUIMedium-Secondary", ( w / 2 ) / 2, h / 2, not value and activeColor or notActiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        
        -- No
        draw.RoundedBox( 0, w / 2, 4, w / 2, h - 8, desiredBoxColorInverted )
        draw.SimpleText( "NO", "goUIMedium-Secondary", w - ( ( w / 2 ) / 2 ), h / 2, value and activeColor or notActiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    button.DoClick = function( this )
        local newValue = not value
        goUI.setClientData( parent.varName, newValue )

        if parent.varInfo.callback then v.callback( value, newValue ) end
        value = newValue
    end
end

local mixerMat = Material( "goui/paint-board-and-brush.png" )
function PANEL:addColor( parent, value )
    local color = parent:Add( "DButton" )
    color:SetText( "" )
    color:Dock( RIGHT )
    color:SetWide( 256 )
    
    local value = IsColor( value ) and value or istable( value ) and Color( value.r, value.g, value.b, value.a ) or color_white
    color.Paint = function( this, w, h )
        local isHovered = this:IsHovered()

        draw.RoundedBox( 0, 1, 1, w - 2, h - 2, Color( 0, 0, 0, 150 ) )

        if isHovered then
            draw.RoundedBox( 0, 6, 6, w - 12, h - 12, Color( value.r - 50, value.g - 50, value.b - 50, 125 ) )
        end

        local xPos = isHovered and 5 or 4
        local yPos = isHovered and 5 or 4
        local bWidth, bHeight = isHovered and w - 10 or w - 8, isHovered and h - 10 or h - 8

        draw.RoundedBox( 0, xPos, yPos, bWidth, bHeight, Color( value.r, value.g, value.b, 125 ) )

        surface.SetMaterial( mixerMat )
        surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
        surface.DrawTexturedRect( 8 + 2, 4 + 2, 32, 32 )

        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 8, 4, 32, 32 )
    end

    color.DoClick = function( this )
        self:showEdit( parent.varName, parent.varInfo )
        self:editColor( parent.varName, parent.varInfo, value )

        self.optionPanel:SetAlpha( 0 )
        self.optionPanel:AlphaTo( 255, goUI.getClientData( "fade_time", 0.5 ), 0 )
    end
end

function PANEL:addTable( parent, value )
    local combo = self.optionPanel:Add( "DComboBox" )
    combo:Dock( RIGHT )
    combo:SetWide( 256 )
    combo:SetText( "" )
end


function PANEL:returnToOptionCategory()
    self.optionPanel:AlphaTo( 0, goUI.getClientData( "fade_time", 0.5 ), 0, function() 
        self.optionPanel:Clear()

        self:fillOptions( self.categoryId )
    end )
end

function PANEL:editColor( varName, varInfo, value )
    local footer = self.optionPanel:Add( "Panel" )
    footer:Dock( BOTTOM )
    footer:SetTall( 40 )

    local resetToDefault = footer:Add( "goUIButton" )
    resetToDefault:Dock( LEFT )
    resetToDefault:SetText( "RESET TO DEFAULT" )
    resetToDefault:SetWide( 256 )

    resetToDefault.DoClick = function( this )
        goUI.setClientData( varName, varInfo.default )

        self:returnToOptionCategory()
    end

    local submit = footer:Add( "goUIButton" )
    submit:Dock( LEFT )
    submit:DockMargin( 8, 0, 0, 0 )
    submit:SetText( "SUBMIT" )
    submit:SetWide( 128 )

    local mixer = self.optionPanel:Add( "DColorMixer" )
    mixer:Dock( FILL )
    mixer:DockMargin( 0, 0, 128, 16 )
    mixer:SetPalette( false )

    mixer:SetColor( value )

    submit.DoClick = function( this )
        goUI.setClientData( varName, mixer:GetColor() )
        self:returnToOptionCategory()
    end
end

function PANEL:showEdit( varName, varInfo )
    self.optionPanel:Clear()

    local title = self.optionPanel:Add( "DLabel" )
    title:Dock( TOP )
    title:SetText( varInfo and varInfo.data and varInfo.data.niceName and varInfo.data.niceName or varName )
    title:SetFont( "goUIHuge-Secondary" )
    title:SetTextColor( color_white )
    title:SetExpensiveShadow( 1, Color( 0, 0, 0, 150 ) )
    title:SizeToContents()
end

function PANEL:fillOptions( categoryId )
    self.elements = {}

    if IsValid( self.optionList ) then
        self.optionList:Remove()
    end

    if IsValid( self.optionPanel ) then
        self.optionPanel:Remove()
    end

    self.optionList = self.panel:Add( "DIconLayout" )
    self.optionList:Dock( LEFT )
    self.optionList:SetWide( self:GetWide() / 2 )

    self.optionPanel = self.outerPanel:Add( "Panel" )
    self.optionPanel:Dock( RIGHT )
    self.optionPanel:SetWide( self:GetWide() - self.panel:GetWide() - 64 )

    for varName, varInfo in pairs( goUI.data.stored ) do
        if varInfo.data and varInfo.data.category ~= categoryId then continue end

        local button = self.optionList:Add( "EditablePanel" )
        button:Dock( TOP )
        button:SetTall( 40 )

        button.Paint = function( this, w, h )
            local color = this:IsHovered() and goUI.getClientData( "secondary_color", Color( 255, 200, 0 ) ) or goUI.getClientData( "main_color", color_white )
            local colorAlpha = 255

            color = Color( color.r, color.g, color.b, colorAlpha )

            local name = varInfo and varInfo.data and varInfo.data.niceName and varInfo.data.niceName or varName
            --draw.SimpleText( name, "goUIMediumLarge-Secondary-Blurred", 28, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText( name, "goUIMediumLarge-Secondary", 28 + 1, h / 2 + 1, Color( 0, 0, 0, 100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) 
            draw.SimpleText( name, "goUIMediumLarge-Secondary", 28, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) 
        end

        button.varName = varName
        button.varInfo = varInfo

        local value = goUI.getClientData( varName, varInfo.default )
        local _type = type( value )

        if _type == "number" or _type == "string" then
            self:addTextEntry( button, value )
        elseif _type == "boolean" then
            self:addBoolean( button, value )
        elseif _type == "table" and value.r and value.g and value.b then
            self:addColor( button, value )
        end
        
        self.elements[ varName ] = button
    end
end

function PANEL:viewOptions( categoryId, categoryInfo )
    self.categoryId = categoryId
    self.categoryInfo = categoryInfo

    local fadeTime = goUI.getClientData( "fade_time", 0.5 )
    self.panel:AlphaTo( 0, fadeTime, 0, function()
        self.panel:Clear()

        self.title:SetText( categoryInfo.name )

        self.footer:Clear()

        self.goBack = self.footer:Add( "goUIButton" )
        self.goBack:Dock( LEFT )
        self.goBack:DockMargin( 8, 0, 0, 0 )
        self.goBack:SetText( "BACK" )
        self.goBack:SetWide( 128 )
        self.goBack.DoClick = function( pnl )
            local fadeTime = goUI.getClientData( "fade_time", 0.5 )
            self.panel:AlphaTo( 0, fadeTime, 0, function()
                self:setUp()

                self.panel:SetAlpha( 0 )
                self.panel:AlphaTo( 255, fadeTime, 0 )
            end )
        end

        self.resetBtn = self.footer:Add( "goUIButton" )
        self.resetBtn:Dock( LEFT )
        self.resetBtn:SetText( "RESET TO DEFAULTS" )
        self.resetBtn:SetWide( 256 )
        self.resetBtn.DoClick = function( pnl )
            goUI.createDialogue( "RESET", "Reset to defaults settings?", "YES", function( dialogue )
                for a, b in pairs( goUI.data.stored ) do
                    goUI.setClientData( a, b.default )
                end

                dialogue:Close()
            end, "NO", function( dialogue ) dialogue:Close() end )
        end

        self:fillOptions( categoryId )

        self.panel:AlphaTo( 255, fadeTime, 0 )
    end )
end

function PANEL:setUp()
    self.outerPanel = self:Add( "Panel" )
    self.outerPanel:Dock( FILL )

    self.title:SetText( "GAME OPTIONS" )

    self.panel = self.outerPanel:Add( "Panel" )
    self.panel:SetSize( self:GetWide() * 0.65, self:GetTall() - 64 )
    self.panel:SetPos( ( ScrW() / 2 ) - ( self.panel:GetWide() / 2 ), 32 )

    self.footer:Clear()

    self.resetBtn = self.footer:Add( "goUIButton" )
    self.resetBtn:Dock( LEFT )
    self.resetBtn:SetText( "RESET TO DEFAULTS" )
    self.resetBtn:SetWide( 256 )
    self.resetBtn.DoClick = function( pnl )
        goUI.createDialogue( "RESET", "Reset to defaults settings?", "YES", function( dialogue )
            for a, b in pairs( goUI.data.stored ) do
                goUI.setClientData( a, b.default )
            end

            dialogue:Close()
        end, "NO", function( dialogue ) dialogue:Close() end )
    end

    self.container = self.panel:Add( "DIconLayout" )
    self.container:Dock( FILL )
    self.container:DockMargin( 0, 0, 0, 16 )
    self.container:SetSpaceX( 8 )

    local varsSaved = {}

    self.categories = {}
    for categoryId, categoryInfo in pairs( goUI.data.categories ) do
       self.categories[ categoryId ] = self:createCategoryButton( self.container, categoryId, categoryInfo )
    end
end

derma.DefineControl( "goUISettingsPanel", nil, PANEL, "EditablePanel" )