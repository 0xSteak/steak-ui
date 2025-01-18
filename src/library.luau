--[[
    Library Main
    [ library.lua ]

    Project: Steak UI Library
    Author: 0xSteak
    Github: https://github.com/0xSteak/steak-ui
]]

local Library = {
    Icons = {},
    Themes = {}
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
local Themes = Registry.GetThemes()
-- Validating Themes
for _, theme in Themes do
    local success, result = Utils.ValidateThemeFormat(theme)

    if not success then
        error(result)
    else
        Library.Themes[theme.Name] = result
    end
end

-- ( Creating ScreenGui )
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Utils.GetGuiStorage()
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Library.ScreenGui = ScreenGui

-- ( Library Methods )

-- Sets up the Library before using it
function Library:Setup(librarySettings, userSettings)
    local Library = self

    -- Check arguments type
    if librarySettings and typeof(librarySettings) ~= "table" then
        error(`Invalid argument #1 (expected "table", got "{typeof(librarySettings)}")`)
    end
    if userSettings and typeof(userSettings) ~= "table" then
        error(`Invalid argument #2 (expected "table", got "{typeof(userSettings)}")`)
    end

    -- In case of nil arguments
    librarySettings = librarySettings or {}
    userSettings = userSettings or {}

    -- Initializing tables
    Library.Settings = {}
    Library.UserSettings = {}

    -- Technical settings of the library
    for setting, value in Registry.DefaultSettings do
        -- Check if setting exists in "options" argument
        if librarySettings[setting] then
            -- Check if type is the same
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
        -- Check if setting exists in "options" argument
        if userSettings[setting] then
            -- Check if type is the same
            if typeof(userSettings[setting]) == typeof(value) then
                -- Check if setting is theme and this theme exists
                if setting == "Theme" and not Library.Themes[userSettings[setting]] then
                    error(`Theme "{userSettings[setting]}" not found.`)
                end

                Library.UserSettings[setting] = userSettings[setting]
            else
                error(`Invalid type for option "{setting}": expected "{typeof(value)}", got "{typeof(userSettings[setting])}"`)
            end
        else
            -- Set setting value as default
            Library.UserSettings[setting] = value
        end
    end
end

-- Imports a new Theme
function Library:ImportTheme(theme)
    local success, result = Utils.ValidateThemeFormat(theme)

    if not success then
        error(result)
    end

    if Library.Themes[result.Name] then
        warn(`Theme "{result.Name}" already exists. It will be overridden`)
    end

    Library.Themes[result.Name] = result
end

-- Imports a new Icon
function Library:ImportRawIcon(name, icon)
    local success, message = Utils.ValidateIconFormat(name, icon)
    if success then
        Library.Icons[name] = icon
    else
        error(message)
    end
end

-- Imports Icon from Registry
function Library:ImportIcon(name)
    local icon = Registry.GetIcon(name)
    if icon then
        Library.Icons[name] = icon
    end
end

return Library