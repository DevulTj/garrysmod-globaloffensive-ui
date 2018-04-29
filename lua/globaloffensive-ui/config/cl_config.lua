--[[
	Global Offensive UI
	Created by http://steamcommunity.com/id/Devul/
	Do not redistribute this software without permission from authors

	Developer information: 76561197973858781 : 4601 : 16520

	> If you bind the menu_key to F1, make sure you've disabled the default DarkRP f1 help menu:
		1. open `darkrpmodification/lua/darkrp_config/disabled_defaults.lua`
		2. find the `DarkRP.disabledDefaults["modules"]` table
		3. disable the f1menu module by setting the config to `true`
]]

-- Category registration, for the OPTIONS menu. You can change the icons if you wish, or the names for your own language. Do not edit the id.
goUI.registerCategory( 
	{
		id = "general configuration",
		name = "GENERAL",
		image = Material( "goui/cogwheel.png", "mips smooth" )
	}
)

goUI.registerCategory( 
	{ 
		id = "appearance", 
		name = "APPEARANCE",
		image = Material( "goui/avatar.png", "mips smooth" )
	}
)

-- Defines the key to use to open Global Offensive UI
goUI.registerUneditableConfig(
	{
		id = "menu_key",
		value = KEY_F6  --  Use a key from the KEY enumeration (https://wiki.garrysmod.com/page/Enums/KEY)
	}
)

 -- Disables material background image and uses main_color client configuration
goUI.registerUneditableConfig( 
	{
		id = "background_material_disabled",
		value = false
	}
)

-- Material background path, make sure you FastDL/Workshop it. The default one doesn't require it as I provided content already. :)
goUI.registerUneditableConfig( 
	{
		id = "background_material", 
		value = Material( "goui/goui_background.png" )
	} 
)

-- Forces element button titles to be in UPPERCASE or not
goUI.registerUneditableConfig( 
	{
		id = "element_title_force_uppercase",
		value = true
	}
)

-- Enforces the ability to set clientside customization
goUI.registerUneditableConfig( 
	{
		id = "can_edit_clientside_settings",
		value = true
	}
)

-- Clientside configurations. These are the things that the Client can modify in the OPTIONS menu.

-- Whether the avatar image is displayed at the top left.
goUI.registerClientConfig(
	{
		id = "show_avatar", 
		value = true, 
		description = "Whether avatar should be displayed",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Display avatars" 
		} 
	}
)

-- The theme's primary colour, that will dictate the button colours also.
goUI.registerClientConfig(
	{
		id = "main_color", 
		value = Color( 230, 230, 230 ), 
		description = "The theme's primary colour",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Theme primary color" 
		} 
	}
)

-- The theme's secondary color, for example when you hover over a button.
goUI.registerClientConfig(
	{
		id = "secondary_color", 
		value = Color( 255, 200, 0 ), 
		description = "The theme's secondary colour",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Theme secondary color" 
		} 
	}
)

-- The theme's background gradient colour. It's displayed when the image is out of your view, or you have the background disabled.
goUI.registerClientConfig(
	{
		id = "gradient_color", 
		value = Color( 25, 25, 25 ), 
		description = "The theme's gradient colour",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Theme gradient color" 
		} 
	}
)

-- The fade time with animations.
goUI.registerClientConfig(
	{
		id = "fade_time", 
		value = 0.5, 
		description = "Fade time for animations within the menu",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Fade time (general)" 
		} 
	}
)

-- The fade time with animations, but only when you press a section/element.
goUI.registerClientConfig(
	{
		id = "element_pressed_fade_time", 
		value = 0.5, 
		description = "Fade time for when you press an element button",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Fade time (section click)" 
		} 
	}
)

-- The primary font used within the module.
goUI.registerClientConfig(
	{
		id = "font", 
		value = "Stratum2-Medium", 
		description = "The primary font",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Primary font" 
		},

		-- Do not edit this
		callback = function()
			hook.Call( "loadFonts" )
		end
	}
)

-- The secondary font used within the module.
goUI.registerClientConfig(
	{
		id = "font_secondary", 
		value = "Stratum2-Medium", 
		description = "The secondary font",

		-- Extra information
		data = { 
			category = "appearance", 
			niceName = "Secondary font" 
		},

		-- Do not edit this
		callback = function()
			hook.Call( "loadFonts" )
		end
	}
)

--[[ 
	As the description states, Whether to ask to close the frame when you press the close button. Using true will mean yes, and false will make it so it disappears
	without a prompt. Please note that when you use the hotkey, there will never be a prompt.
]]
goUI.registerClientConfig(
	{
		id = "ask_on_close", 
		value = true, 
		description = "Whether to ask to close the frame when you press the close button",

		-- Extra information
		data = { 
			category = "general configuration", 
			niceName = "Show prompt on quit" 
		} 
	}
)

-- This decides whether Global Offensive UI will open when a player joins the server, for example like a Message of the Day.
goUI.registerClientConfig(
	{
		id = "auto_open_on_join", 
		value = true, 
		description = "Whether Global Offensive UI should auto-open on join",

		-- Extra information
		data = { 
			category = "general configuration", 
			niceName = "Open on initial join" 
		} 
	}
)

goUI.registerElement( "HOME", {
	innerTakesFocus = true,

	avatarWidget = {

	},
	greeting = "Welcome to BackyardServers.com - please read the rules and enjoy your stay!",

	showURLInner = "https://google.co.uk"
})

goUI.registerElement( "FORUMS", {
	showURL = "https://facepunch.com/"
})

goUI.registerElement( "STAFF", {
	--customCheck = function( client, panel ) return client:IsAdmin() or client:IsSuperAdmin() end,

	headerMessage = "This list shows the current online Staff members, contact them if you have any issues.",
	staff = {
		[ "admin" ] = {
			name = "Administrator",
			color = Color( 255, 255, 255 ),
		},
		[ "superadmin" ] = {
			name = "Senior Administrator",
			color = Color( 255, 255, 0 ),
		},
		[ "founder" ] = {
			name = "Founder",
			color = Color( 235, 51, 51 ),
		},
		--[[
		[ "vip" ] = {
			name = "VIP",
			color = Color( 255, 200, 0 ),
		},
		]]
	},

	innerTakesFocus = true
})

--[[
	Servers element:
	You can register new servers by adding a new entry to the servers table, the design is like so:

	[ "Server Name" ] = {
		icon = Material( "my/path/to/icon.png" ),
		ip = "x.x.x.x", -- Server IP is important, it's used to connect to the server.
		desc = "Description of the server.",
		joinText = "JOIN THE SERVER", -- Replacement text for the join button.
	}
]]
goUI.registerElement( "SERVERS", {
	servers = {
		[ "DARKRP" ] = {
			icon = Material( "goui/server_icon.png" ),
			ip = "89.34.97.159",
			desc = "One of our servers.",

			joinText = "JOIN"
		},
		[ "TTT" ] = {
			icon = Material( "goui/server_icon_2.png" ),
			ip = "89.34.97.159",
			desc = "Another one of our servers.",

			joinText = "JOIN"
		}
	},

	innerTakesFocus = true
})

goUI.registerElement( "RULES", {
	-- This dictates whether a website should load here.
	showURL = "https://google.co.uk"
})

--[[ 
	-- This shows a donation page URL which you can uncomment and set your own URL for.

	goUI.registerElement( "DONATE", {
		-- This dictates whether a website should load here.
		showURL = "https://google.co.uk"
	})
]]

goUI.registerElement( "OPTIONS", {
	-- This dictates whether the options menu should show here.
	options = true
} )
