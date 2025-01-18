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
        return false, "InvalidThemeObject: Theme must be of type string or table"
    end

    for property, color in themeObject do
        local propertyIndex = table.find(properties, property)
        if not propertyIndex then continue end

        if typeof(color) == "string" then
            local success, result = pcall(Color3.fromHex, color)
            if success then
                themeObject[property] = result
            else
                return false, "InvalidThemeObject: Invalid hex color on property \""..property.."\""
            end
        elseif typeof(color) ~= "Color3" then
            return false, "InvalidThemeObject: Invalid color type on property \""..property.."\""
        end

        table.remove(properties, propertyIndex)
    end

    if #properties > 0 then
        return false, "InvalidThemeObject: Missing "..#properties.." properties ("..table.concat(properties, ", ")..")"
    end

    return true, themeObject
end

return Utils