--[[
    Utilities Module
    [ utils.lua ]

    Project: Steak UI Library
    Author: 0xSteak
    Github: https://github.com/0xSteak/steak-ui
]]

local Utils = {}

-- ( Services )
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Returns Instance for ScreenGui
function Utils.GetGuiStorage()
    local getStorage = gethui or get_hidden_gui or get_hidden_ui or function()
        local success, storage = pcall(function()
            local CoreGui = game:GetService("CoreGui")
            return CoreGui.Name and CoreGui
        end)

        if not success then
            storage = Players.LocalPlayer:WaitForChild("PlayerGui", 30)
        end

        if not storage then
            error("Steak UI library: Cannot find storage for GUI")
        end

        return storage
    end

    return getStorage()
end

-- Validates theme format
-- Theme Object must be a table containing colors for every property, variable "properties" contains all required properties
-- Theme Property must be a Color3 or Hex Color string
-- Theme Object can be passed as a JSON string
-- Returns success boolean and error message or Theme Object with Color3 properties
function Utils.ValidateThemeFormat(theme)
    local properties = {"PrimaryTextColor", "SwitchThumbColor", "TextFieldPlaceholderTextColor", "SwitchTrackColor", "DividersColor", "WindowBackgroundColor", "DropdownToggleColor", "SecondaryTextColor", "HighlightColor", "DropdownListColor", "TextFieldBackgroundColor", "ScrollBarColor"}
    
    local themeObject

    if typeof(theme) == "string" then
        local success, jsonDecoded = pcall(HttpService.JSONDecode, HttpService, theme)
        if success and jsonDecoded then
            themeObject = jsonDecoded
        else
            return false, "InvalidThemeObject: Failed to parse JSON"
        end
    elseif typeof(theme) == "table" then
        themeObject = theme
    else
        return false, "InvalidThemeObject: Theme Object must be of type string or table"
    end

    if typeof(themeObject.Name) ~= "string" then
        return false, "InvalidThemeObject: Name is missing or invalid"
    end

    for property, color in themeObject do
        local propertyIndex = table.find(properties, property)
        if not propertyIndex then continue end

        if typeof(color) == "string" then
            local success, result = pcall(Color3.fromHex, color)
            if success then
                themeObject[property] = result
            else
                return false, `InvalidThemeObject: Invalid hex color on property "{property}"`
            end
        elseif typeof(color) ~= "Color3" then
            return false, `InvalidThemeObject: Invalid color type on property "{property}"`
        end

        table.remove(properties, propertyIndex)
    end

    if #properties > 0 then
        return false, `InvalidThemeObject: Missing {#properties} properties ({table.concat(properties, ", ")})`
    end

    return true, themeObject
end

-- Validates Icon Format
-- Icon Object must be a table
-- "Image" is required property that represents Image ID
-- "RectOffset" and "RectSize" are optional properties that are needed if Image is a sprite sheet
function Utils.ValidateIconFormat(name, icon)
    if typeof(name) ~= "string" then
        return false, "InvalidIconObject: Icon Name must be a string"
    end
    
    if typeof(icon) ~= "table" then
        return false, "InvalidIconObject: Icon Object must be a table"
    end

    -- Required
    if typeof(icon.Image) ~= "string" then
        return false, "InvalidIconObject: Image missing or invalid"
    end

    -- Optional
    if icon.RectOffset and typeof(icon.RectOffset) ~= "Vector2" then
        return false, "InvalidIconObject: RectOffset must be a Vector2"
    end

    -- Optional
    if icon.RectOffset and typeof(icon.RectOffset) ~= "Vector2" then
        return false, "InvalidIconObject: RectOffset must be a Vector2"
    end

    return true
end

-- Validates User Setting
function Utils.ValidateUserSetting(Library, setting, value)
    if setting == "Theme" then
        if not Library.Themes[value] then
            error(`Theme "{value}" not found.`)
        end
    end
    return true
end

return Utils