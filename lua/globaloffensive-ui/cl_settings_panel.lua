local PANEL = {}

function PANEL:Init()
    self:Dock( FILL )
end

function PANEL:Paint( w, h ) end

local topRight = Material( "goui/button/button_topright.png" )
local topRightW, topRightH = 16, 16

function PANEL:createCategoryButton( parent, categoryId, categoryInfo )
    local button = parent:Add( "DButton" )
    button:SetText( "" )
    button:SetSize( 350, 250 )

    button.Paint = function( self, w, h )   
        local pCol = goUI.getClientData( "main_color", color_white )
        local sCol = goUI.getClientData( "secondary_color", Color( 255, 200, 0 ) )
        local color = self.isActive and Color( pCol.r, pCol.g, pCol.b ) 
            or self:IsDown() and Color( math.clampColor( sCol.r - 35 ), math.clampColor( sCol.g - 35 ), math.clampColor( sCol.b - 35 ) ) 
                or self:IsHovered() and sCol or Color( math.clampColor( pCol.r - 55 ), math.clampColor( pCol.g - 55 ), math.clampColor( pCol.b - 55 ) )
                
        local colorAlpha = 255

        color = Color( color.r, color.g, color.b, colorAlpha )

        if categoryInfo.image then
            -- Icon image
            surface.SetMaterial( categoryInfo.image )
            surface.SetDrawColor( color )
            surface.DrawTexturedRect( w / 2 - ( 150 / 2 ), h / 1.75 - ( 150 / 2 ), 150, 150 )
        end

        surface.SetMaterial( topRight )
        surface.SetDrawColor( color )
        surface.DrawTexturedRect( w - topRightW, 0, topRightW, topRightH )

        -- Bottom bar
        surface.DrawRect( 0, h - 2, w, 2 )

        -- Top bar
        surface.DrawRect( 0, 0, w - topRightW, 2 )

        -- Left bar
        surface.DrawRect( 0, 0, 2, h )

        -- Right bar
        surface.DrawRect( w - 2, topRightH, 2, h - topRightH )


        //draw.RoundedBox( 8, 0, 0, w, h, color )
        //draw.RoundedBox( 8, 2, 2, w - 4, h - 4, Color( 10, 10, 10, 255 ) )

        draw.SimpleText( categoryInfo.name, "goUIMediumLarge-Secondary-Blurred", 28, 36, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( categoryInfo.name, "goUIMediumLarge-Secondary", 28, 36, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

    local color = Color( 50, 50, 50, 125 ) 
    textEntry.Paint = function( this, w, h )
        local isHovered = this:IsHovered()

        if isHovered then
            draw.RoundedBox( 16, 0, 4, w, h - 8, Color( color.r, color.g, color.b, 100 ) )
        end

        local xPos = isHovered and 3 or 0
        local yPos = isHovered and 6 or 4
        local bWidth, bHeight = isHovered and w - 6 or w, isHovered and h - 12 or h - 8
        draw.RoundedBox( 16, xPos, yPos, bWidth, bHeight, Color( color.r, color.g, color.b, 255 ) )

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
        draw.RoundedBox( 16, 4, 4, w / 2 - 8, h - 8, desiredBoxColor )
        draw.SimpleText( "YES", "goUIMedium-Secondary", ( w / 2 ) / 2, h / 2, not value and activeColor or notActiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        
        -- No
        draw.RoundedBox( 16, w / 2, 4, w / 2 - 8, h - 8, desiredBoxColorInverted )
        draw.SimpleText( "NO", "goUIMedium-Secondary", w - ( ( w / 2 ) / 2 ) - 8 , h / 2, value and activeColor or notActiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

        draw.RoundedBox( 16, 1, 1, w - 2, h - 2, Color( 0, 0, 0, 150 ) )

        if isHovered then
            draw.RoundedBox( 16, 6, 6, w - 12, h - 12, Color( value.r - 50, value.g - 50, value.b - 50, 255 ) )
        end

        local xPos = isHovered and 5 or 4
        local yPos = isHovered and 5 or 4
        local bWidth, bHeight = isHovered and w - 10 or w - 8, isHovered and h - 10 or h - 8

        draw.RoundedBox( 16, xPos, yPos, bWidth, bHeight, Color( value.r, value.g, value.b, 255 ) )

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
    title:SetText( varInfo and varInfo.data and varInfo.data.niceName and varInfo.data.niceName:upper() or varName:upper() )
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

    self.optionPanel = self.panel:Add( "Panel" )
    self.optionPanel:Dock( FILL )
    self.optionPanel:DockMargin( 32, 0, 0, 0 )

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
            draw.SimpleText( name, "goUIMediumLarge-Secondary-Blurred", 28, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

        self.header = self.panel:Add( "Panel" )
        self.header:Dock( TOP )
        self.header:DockMargin( 0, 0, 0, 8 )
        self.header:SetTall( 40 )

        self.header.Paint = function( this, w, h )
            local pCol = goUI.getClientData( "main_color", color_white )
            if categoryInfo.image then
                -- Icon image
                surface.SetMaterial( categoryInfo.image )
                surface.SetDrawColor( pCol )
                surface.DrawTexturedRect( 0, 0, 40, 40 )
            end

            draw.SimpleText( categoryInfo.name, "goUIMediumLarge-Secondary-Blurred", 48, h / 2, Color( pCol.r, pCol.g, pCol.b, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText( categoryInfo.name, "goUIMediumLarge-Secondary", 48, h / 2, pCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        self.footer = self.panel:Add( "Panel" )
        self.footer:Dock( BOTTOM )
        self.footer:SetTall( 40 )

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

        self:fillOptions( categoryId )

        self.panel:AlphaTo( 255, fadeTime, 0 )
    end )
end

function PANEL:setUp()
    self.panel = self:Add( "Panel" )
    self.panel:Dock( FILL )

    self.footer = self.panel:Add( "Panel" )
    self.footer:Dock( BOTTOM )
    self.footer:SetTall( 40 )

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