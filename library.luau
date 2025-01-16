local Library = {}

local function import(file)
    local AUTHOR = "0xSteak"
    local REPO = "steak-ui"
    local BRANCH = "main"

    return loadstring(game:HttpGetAsync(`https://raw.githubusercontent.com/{AUTHOR}/{REPO}/refs/heads/{BRANCH}/file`))
end