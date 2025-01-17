--[[
    Library Main
    library.lua

    Project: Steak UI Library
    Author: 0xSteak
    Github: https://github.com/0xSteak/steak-ui
]]

local Library = {}

-- ( Services )
local HttpService = game:GetService("HttpService")

-- ( Constants )
-- Default UI Font
local FONT = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
-- Themes Database
local THEMES = "https://raw.githubusercontent.com/0xSteak/steak-ui/refs/heads/main/registry/themes.json"
-- Icons Database
local ICONS = "https://raw.githubusercontent.com/0xSteak/steak-ui/refs/heads/main/registry/icons.json"

-- Import Module from github repository
local function import(file)
    local AUTHOR = "0xSteak"
    local REPO = "steak-ui"
    local BRANCH = "main"

    return loadstring(game:HttpGetAsync(`https://raw.githubusercontent.com/{AUTHOR}/{REPO}/refs/heads/{BRANCH}/{file}.luau`))()
end

-- ( Importing Themes )
local ThemesJSON = game:HttpGetAsync(THEMES)
Library.Themes = HttpService:JSONDecode(ThemesJSON)

-- ( Importing Icons )
Library.Icons = {}
local IconsJSON = game:HttpGetAsync(ICONS)
local Icons = HttpService:JSONDecode(IconsJSON)
for name, data in Icons.icons do
    local sheetIndex = data.i
    local sheetId = Icons.sheets[sheetIndex]
    local positionX = data.p[1]
    local positionY = data.p[2]
    local sizeX = if data.s then data.s[1] else 64
    local sizeY = if data.s then data.s[2] else 64

    Library.Icons[name] = {
        Image = "rbxassetid://" .. sheetId,
        RectOffset = Vector2.new(positionX, positionY),
        RectSize = Vector2.new(sizeX, sizeY)
    }
end

-- ( Importing Modules )
local Utils = import("utils")
Library.Utils = Utils
Library.Elements = {
    Window = import("elements/window")
}

-- ( Creating ScreenGui )
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Utils.GetGuiStorage()
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Library.ScreenGui = ScreenGui

-- Sets up the Library before using it
function Library:Setup(options)
    local Library = self

    local DefaultSettings = {
        Font = FONT
    }
    local DefaultUserSettings = {
        Theme = Library
    }

    -- Technical settings of the library
    Library.Settings = {
        Font = options.Font or FONT
    }

    -- Settings that can be changed by the user
    Library.UserSettings = {
        Theme = options.Theme
    }
end

Library.CreateWindow = Library.Elements.Window.new

return Library