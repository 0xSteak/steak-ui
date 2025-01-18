--[[
    Library Main
    [ library.lua ]

    Project: Steak UI Library
    Author: 0xSteak
    Github: https://github.com/0xSteak/steak-ui
]]

local Library = {
    Icons = {}
}

-- Import Module from Github repository
local function import(file)
    local AUTHOR = "0xSteak"
    local REPO = "steak-ui"
    local BRANCH = "main"
    local SOURCE_PATH = "src/"

    return loadstring(game:HttpGetAsync(`https://raw.githubusercontent.com/{AUTHOR}/{REPO}/refs/heads/{BRANCH}/{SOURCE_PATH}{file}.luau`))()
end

-- ( Importing Modules )
local Utils = import("utils")
local Registry = import("registry")
Library.Utils = Utils
Library.Registry = Registry
Library.Elements = {
    Window = import("elements/window")
}

-- ( Importing Themes )
Library.Themes = Registry.GetThemes()

-- ( Creating ScreenGui )
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Utils.GetGuiStorage()
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Library.ScreenGui = ScreenGui

-- Sets up the Library before using it
function Library:Setup(librarySettings, userSettings)
    local Library = self

    -- Initializing tables
    Library.Settings = {}
    Library.UserSettings = {}

    -- Technical settings of the library
    for setting, value in Registry.DefaultSettings do
        -- If setting exists in "options" argument
        if librarySettings[setting] then
            -- If type is the same
            if typeof(librarySettings[setting]) == typeof(value) then
                Library.Settings[setting] = librarySettings[setting]
            else
                error(`Invalid type for option "{setting}": expected "{typeof(value)}", got "{typeof(librarySettings[setting])}"`)
            end
        else
            -- Set setting value as default
            Library.Settings[setting] = value
        end
    end

    -- Settings that can be changed by the user
    for setting, value in Registry.DefaultUserSettings do
        -- If setting exists in "options" argument
        if userSettings[setting] then
            -- If type is the same
            if typeof(userSettings[setting]) == typeof(value) then
                Library.Settings[setting] = userSettings[setting]
            else
                error(`Invalid type for option "{setting}": expected "{typeof(value)}", got "{typeof(userSettings[setting])}"`)
            end
        else
            -- Set setting value as default
            Library.UserSettings[setting] = value
        end
    end
end

Library.CreateWindow = Library.Elements.Window.new

return Library