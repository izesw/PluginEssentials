-- // Types
type Dictionary<Type> = {[string] : Type}
type Array<Type> = {[number] : Type}

-- // Initialization
local Modules : Dictionary<any?> = {}
local Types: Dictionary<Array<string>> = {
    Server = {"Component", "Service"};
    Client = {"Component", "Controller"};
}
local EndTypes: Array<string> = {"Server", "Client"};

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
local Computed = Fusion.Computed
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local Observer = Fusion.Observer
local Children = Fusion.Children

-- // States
plugin:SetSetting("Helper_Opened", true) -- // testing purposes
if plugin:GetSetting("Helper_Opened") == nil then
    plugin:SetSetting("Helper_Opened", true)
end

local EndState = Value(EndTypes[1]);
local TypeState = Value(Types[EndState:get()][1]);
local NameState = Value("");
local OpenState = Value(plugin:GetSetting("Helper_Opened"));

local OpenObserver = Observer(OpenState)

local OpenObserverConnection = OpenObserver:onChange(function()
    print(OpenState)
    plugin:SetSetting("Helper_Opened", OpenState)
end)

-- // Plugin Toolbar
local SuiteToolbar : PluginToolbar = Modules.Toolbar {
    Name = "iZ's Plugin Suite"
}

local KnitHelper : PluginToolbarButton = Modules.ToolbarButton {
    Active = Computed(function()
        return OpenState:get()
    end),
    [OnEvent "Click"] = function()
        OpenState:set(not OpenState:get())
    end,
    Toolbar = SuiteToolbar,
    ToolTip = "A helper for knit.",
    Image = "rbxassetid://12898782803",
    Name = "Knit Helper"
}

-- // Base UI (Title, Footer, etc.)
local Title : TextButton = New "ImageLabel" {
    Name = "Icon",
	AnchorPoint = Vector2.new(.5, 0),
	Position = UDim2.new(0.5, 0, 0, 0),
	Size = UDim2.fromOffset(45, 45),
	BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    Image = "rbxassetid://12898782803",
}

local EndDropdown : Frame = Modules.Dropdown {
    Enabled = true;
    MaxVisibleItems = 2;
    AnchorPoint = Vector2.new(.5, 0),
	Position = UDim2.new(0.5, 0, .2, 0),
    Size = UDim2.fromScale(.9, .05),
    Value = EndState:get();
    Options = EndTypes;
    OnSelected = function(selected: any?)
        EndState:set(selected);
    end
}

local TypeDropdown : Frame = Modules.Dropdown {
    Enabled = true;
    MaxVisibleItems = 2;
    Value = TypeState;
    AnchorPoint = Vector2.new(.5, 0),
	Position = UDim2.new(0.5, 0, .4, 0),
    Size = UDim2.fromScale(.9, .05),
    Options = Computed(function()
        return Types[EndState:get()]
    end);
    OnSelected = function(selected: any?)
        TypeState:set(selected);
    end
}

local NameInput : TextLabel = Modules.Dropdown {
    Enabled = true;
    [OnEvent "FocusLost"] = function()
        
    end
}

local KnitHelperWindow : DockWidgetPluginGui = Modules.Widget {
    Id = "iZeSW_KnitHelper_69420_Acuritz",
    Name = "Knit Helper - iZeSW",
    Enabled = Computed(function()
        return OpenState:get()
    end),
    InitialDockTo = "Top",
    InitialEnabled = false,
    ForceInitialEnabled = false,
    FloatingSize = Vector2.new(300, 650),
    MinimumSize = Vector2.new(200, 440),
    [Children] = {Title, EndDropdown, TypeDropdown}
}