--[[
    Registry Module
    ( Registry for storing themes, icons, and other configurations. )
    [ registry.lua ]

    Project: Steak UI Library
    Author: 0xSteak
    Github: https://github.com/0xSteak/steak-ui
]]

local Registry = {}

local HttpService = game:GetService("HttpService")

local AUTHOR = "0xSteak"
local REPO = "steak-ui"
local BRANCH = "main"
local THEMES_PATH = "registry/themes.json"
local ICONS_PATH = "registry/icons.json"

Registry.DefaultSettings = {
    Font = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
}

Registry.DefaultUserSettings = {
    Theme = "Dark" -- Must be a name of existing Theme
}

function Registry.GetThemes()
    local themesJSON = game:HttpGetAsync(`https://raw.githubusercontent.com/{AUTHOR}/{REPO}/refs/heads/{BRANCH}/{THEMES_PATH}`)
    return HttpService:JSONDecode(themesJSON) -- Theme Object
end

function Registry.GetIcon(name)
    local iconsJSON = game:HttpGetAsync(`https://raw.githubusercontent.com/{AUTHOR}/{REPO}/refs/heads/{BRANCH}/{ICONS_PATH}`)
    local icons = HttpService:JSONDecode(iconsJSON)

    -- Icon data (sheet id, position, size)
    local data = icons[name]

    -- Sheet is a Sprite Sheet of Icons
    local sheetIndex = data.i
    local sheetId = icons.sheets[sheetIndex]

    -- Icon position on the Sheet
    local positionX = data.p[1]
    local positionY = data.p[2]

    -- Icon size on the Sheet
    local sizeX = if data.s then data.s[1] else 64
    local sizeY = if data.s then data.s[2] else 64

    -- Icon Object
    return {
        Image = "rbxassetid://" .. sheetId,
        RectOffset = Vector2.new(positionX, positionY),
        RectSize = Vector2.new(sizeX, sizeY)
    }
end

return Registry