-- // Types
type Dictionary<Type> = {[string] : Type}

-- // Initialization
local Modules : Dictionary<any?> = {}

-- // Get Modules
local function getModules(parent : Instance)
    for _, child in ipairs(parent:GetChildren()) do
        if Modules[child.Name] then continue end
        if parent.Name == "Licenses" or parent.Name == "Util" then continue end
        if child.ClassName == "ModuleScript" then
            Modules[child.Name] = require(child)
        elseif child.ClassName == "Folder" then
            Modules[child.Name] = getModules(child)
        end
    end
end
getModules(script.Parent)

-- // Fusion Methods
local Fusion : any? = Modules.Fusion
local New = Fusion.New

-- // Plugin Toolbar
local SuiteToolbar : PluginToolbar = Modules.Toolbar {
    Name = "iZ's Plugin Suite"
}

local KnitHelper : PluginToolbarButton = Modules.ToolbarButton {
    Active = false,
    Toolbar = SuiteToolbar,
    ToolTip = "A helper for knit.",
    Image = "rbxassetid://12898782803",
    Name = "Knit Helper"
}

local KnitHelperWindow : DockWidgetPluginGui = Modules.Widget {
    Id = "iZeSW_KnitHelper_69420_Acuritz",
    Name = "Knit Helper - iZeSW",
    InitialDockTo = "Top",
    InitialEnabled = true,
    ForceInitialEnabled = true,
    FloatingSize = Vector2.new(300, 650),
    MinimumSize = Vector2.new(200, 440)
}

-- // Base UI (Title, Footer, etc.)
local Title : TextButton = Modules.IconButton {
    Enabled = true,
    Activated = function()
        print("Icon Pressed")
    end,
    Icon = "rbxassetid://12898782803",
}
