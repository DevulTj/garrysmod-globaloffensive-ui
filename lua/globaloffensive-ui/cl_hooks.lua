--[[
    Global Offensive UI
    Created by http://steamcommunity.com/id/Devul/
    Do not redistribute this software without permission from authors

  
]]--

hook.Add( "PlayerButtonUp", "goUI_keybinds", function( player, buttonId )
	if not IsFirstTimePredicted() then return end
	if player ~= LocalPlayer() then return end
	if gui.IsGameUIVisible() then return end
	if player:IsTyping() then return end

    local chosenKey = goUI.getUnEditableData( "menu_key", KEY_F6 )
    if buttonId ~= chosenKey then return end

    goUI.toggleMenu()
end )

concommand.Add( "goUI_toggle", goUI.toggleMenu )

if goUI.getClientData( "auto_open_on_join", true ) then
    hook.Add( "InitPostEntity", "goUI", goUI.toggleMenu )
end
