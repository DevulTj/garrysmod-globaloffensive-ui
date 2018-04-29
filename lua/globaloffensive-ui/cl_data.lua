--[[
  Global Offensive UI
  Created by http://steamcommunity.com/id/Devul/
  Do not redistribute this software without permission from authors


]]--

goUI.data = goUI.data or {}

goUI.data.playerData = goUI.data.playerData or {}
goUI.data.stored = goUI.data.stored or {}
goUI.data.categories = goUI.data.categories or {}

goUI.data.unEditableConfig = goUI.data.unEditableConfig or {}

goUI.data.folderName = "goUI"
goUI.data.fileName = "configuration.txt"

local function saveData()
    file.Write( goUI.data.folderName .. "/" .. goUI.data.fileName, util.TableToJSON( goUI.data.playerData ) )
end

local function getAllData()
    return util.JSONToTable( file.Read( goUI.data.folderName .. "/" .. goUI.data.fileName, "DATA" ) or "[]" ) or {}
end

function goUI.registerClientConfig( tbl )
    local var = tbl.id or tbl.val
    local val = tbl.value or tbl.val
    local description = tbl.desc or tbl.description
    local callback = tbl.callback or tbl.func
    local data = tbl.data or tbl.extraData

    local oldCfg = goUI.data.stored[ var ]

    goUI.data.stored[ var ] = {
        data = data,
        value = oldCfg and oldCfg.value or val,
        default = val,
        description = description,
        callback = callback
    }
end

function goUI.registerCategory( tbl )
    local id = tbl.id
    local name = tbl.name
    local image = tbl.image or tbl.material 

    print( id, name, image )

    goUI.data.categories[ id ] = { id = id, name = name, image = image }
end

function goUI.registerUneditableConfig( tbl )
    local var = tbl.id or tbl.val
    local val = tbl.value or tbl.val
    if not var or not val then return end

    goUI.data.unEditableConfig[ var ] = val
end

function goUI.getUnEditableData( var, fallbackVal )
    return goUI.data.unEditableConfig[ var ] or fallbackVal
end

function goUI.getClientData( var, fallbackVal )
    local curVal = goUI.data.playerData[ var ]
    if isbool( curVal ) then
        return curVal
    else
        return curVal or fallbackVal
    end
end

function goUI.setClientData( var, val )
    local oldVal = goUI.data.playerData[ var ]
    goUI.data.playerData[ var ] = val

    saveData()

    if goUI.data.stored[ var ] and goUI.data.stored[ var ].callback then
        goUI.data.stored[ var ].callback( oldVal, val )
    end
end

goUI.data.playerData = getAllData()

--[[----------------------------------------
    ELEMENTS SETUP
------------------------------------------]]

goUI.config = goUI.config or {}
goUI.config.ELEMENTS = {}
goUI.config.ELEMENTS_TO_ID = {}

goUI.registerElement = function( name, data )
    data = data or {}
    data.name = name

    if goUI.config.ELEMENTS_TO_ID[ name ] then
        local id = goUI.config.ELEMENTS_TO_ID[ name ]

        goUI.config.ELEMENTS[ id ] = data
    else
        local id = table.insert( goUI.config.ELEMENTS, data )

        goUI.config.ELEMENTS_TO_ID[ name ] = id
    end
end

goUI.getElement = function( nameOrId )
    return isnumber( nameOrId ) and goUI.config.ELEMENTS[ nameOrId ] or goUI.config.ELEMENTS_TO_ID[ nameOrId ] and goUI.config.ELEMENTS[ goUI.config.ELEMENTS_TO_ID[ nameOrId ] ]
end