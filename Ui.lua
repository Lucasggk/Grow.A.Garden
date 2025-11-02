local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local httpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Mobile =
    not RunService:IsStudio() and
    table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform()) ~= nil
local RenderStepped = RunService.RenderStepped
local ProtectGui = protectgui or (syn and syn.protect_gui) or function()
    end
local Themes = {
    Names = {
        "Dark"
    },
    Dark = {
        Name = "Dark",
        Accent = Color3.fromRGB(96, 205, 255),
        AcrylicMain = Color3.fromRGB(60, 60, 60),
        AcrylicBorder = Color3.fromRGB(90, 90, 90),
        AcrylicGradient = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(40, 40, 40)),
        AcrylicNoise = 0.9,
        TitleBarLine = Color3.fromRGB(75, 75, 75),
        Tab = Color3.fromRGB(120, 120, 120),
        Element = Color3.fromRGB(120, 120, 120),
        ElementBorder = Color3.fromRGB(35, 35, 35),
        InElementBorder = Color3.fromRGB(90, 90, 90),
        ElementTransparency = 0.87,
        ToggleSlider = Color3.fromRGB(120, 120, 120),
        ToggleToggled = Color3.fromRGB(42, 42, 42),
        SliderRail = Color3.fromRGB(120, 120, 120),
        DropdownFrame = Color3.fromRGB(160, 160, 160),
        DropdownHolder = Color3.fromRGB(45, 45, 45),
        DropdownBorder = Color3.fromRGB(35, 35, 35),
        DropdownOption = Color3.fromRGB(120, 120, 120),
        Keybind = Color3.fromRGB(120, 120, 120),
        Input = Color3.fromRGB(160, 160, 160),
        InputFocused = Color3.fromRGB(10, 10, 10),
        InputIndicator = Color3.fromRGB(150, 150, 150),
        Dialog = Color3.fromRGB(45, 45, 45),
        DialogHolder = Color3.fromRGB(35, 35, 35),
        DialogHolderLine = Color3.fromRGB(30, 30, 30),
        DialogButton = Color3.fromRGB(45, 45, 45),
        DialogButtonBorder = Color3.fromRGB(80, 80, 80),
        DialogBorder = Color3.fromRGB(70, 70, 70),
        DialogInput = Color3.fromRGB(55, 55, 55),
        DialogInputLine = Color3.fromRGB(160, 160, 160),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(170, 170, 170),
        Hover = Color3.fromRGB(120, 120, 120),
        HoverChange = 0.07
    }
}
local Library = {
    Version = "1.2.2",
    OpenFrames = {},
    Options = {},
    Themes = Themes.Names,
    Windows = {},
    Window = nil,
    WindowFrame = nil,
    Unloaded = false,
    Creator = nil,
    DialogOpen = false,
    UseAcrylic = false,
    Acrylic = false,
    Transparency = true,
    MinimizeKeybind = nil,
    MinimizeKey = Enum.KeyCode.LeftControl
}
local function isMotor(value)
    local motorType = tostring(value):match("^Motor%((.+)%)$")
    if motorType then
        return true, motorType
    else
        return false
    end
end
local Connection = {}
Connection.__index = Connection
function Connection.new(signal, handler)
    return setmetatable(
        {
            signal = signal,
            connected = true,
            _handler = handler
        },
        Connection
    )
end
function Connection:disconnect()
    if self.connected then
        self.connected = false
        for index, connection in pairs(self.signal._connections) do
            if connection == self then
                table.remove(self.signal._connections, index)
                return
            end
        end
    end
end
local Signal = {}
Signal.__index = Signal
function Signal.new()
    return setmetatable(
        {
            _connections = {},
            _threads = {}
        },
        Signal
    )
end
function Signal:fire(...)
    for _, connection in pairs(self._connections) do
        connection._handler(...)
    end
    for _, thread in pairs(self._threads) do
        coroutine.resume(thread, ...)
    end
    self._threads = {}
end
function Signal:connect(handler)
    local connection = Connection.new(self, handler)
    table.insert(self._connections, connection)
    return connection
end
function Signal:wait()
    table.insert(self._threads, coroutine.running())
    return coroutine.yield()
end
local Linear = {}
Linear.__index = Linear
function Linear.new(targetValue, options)
    assert(targetValue, "Missing argument #1: targetValue")
    options = options or {}
    return setmetatable(
        {
            _targetValue = targetValue,
            _velocity = options.velocity or 1
        },
        Linear
    )
end
function Linear:step(state, dt)
    local position = state.value
    local velocity = self._velocity
    local goal = self._targetValue
    local dPos = dt * velocity
    local complete = dPos >= math.abs(goal - position)
    position = position + dPos * (goal > position and 1 or -1)
    if complete then
        position = self._targetValue
        velocity = 0
    end
    return {
        complete = complete,
        value = position,
        velocity = velocity
    }
end
local Instant = {}
Instant.__index = Instant
function Instant.new(targetValue)
    return setmetatable(
        {
            _targetValue = targetValue
        },
        Instant
    )
end
function Instant:step()
    return {
        complete = true,
        value = self._targetValue
    }
end
local VELOCITY_THRESHOLD = 0.001
local POSITION_THRESHOLD = 0.001
local EPS = 0.0001
local Spring = {}
Spring.__index = Spring
function Spring.new(targetValue, options)
    assert(targetValue, "Missing argument #1: targetValue")
    options = options or {}
    return setmetatable(
        {
            _targetValue = targetValue,
            _frequency = options.frequency or 4,
            _dampingRatio = options.dampingRatio or 1
        },
        Spring
    )
end
function Spring:step(state, dt)
    local d = self._dampingRatio
    local f = self._frequency * 2 * math.pi
    local g = self._targetValue
    local p0 = state.value
    local v0 = state.velocity or 0
    local offset = p0 - g
    local decay = math.exp(-d * f * dt)
    local p1, v1
    if d == 1 then
        p1 = (offset * (1 + f * dt) + v0 * dt) * decay + g
        v1 = (v0 * (1 - f * dt) - offset * (f * f * dt)) * decay
    elseif d < 1 then
        local c = math.sqrt(1 - d * d)
        local i = math.cos(f * c * dt)
        local j = math.sin(f * c * dt)
        local z
        if c > EPS then
            z = j / c
        else
            local a = dt * f
            z = a + ((a * a) * (c * c) * (c * c) / 20 - c * c) * (a * a * a) / 6
        end
        local y
        if f * c > EPS then
            y = j / (f * c)
        else
            local b = f * c
            y = dt + ((dt * dt) * (b * b) * (b * b) / 20 - b * b) * (dt * dt * dt) / 6
        end
        p1 = (offset * (i + d * z) + v0 * y) * decay + g
        v1 = (v0 * (i - z * d) - offset * (z * f)) * decay
    else
        local c = math.sqrt(d * d - 1)
        local r1 = -f * (d - c)
        local r2 = -f * (d + c)
        local co2 = (v0 - offset * r1) / (2 * f * c)
        local co1 = offset - co2
        local e1 = co1 * math.exp(r1 * dt)
        local e2 = co2 * math.exp(r2 * dt)
        p1 = e1 + e2 + g
        v1 = e1 * r1 + e2 * r2
    end
    local complete = math.abs(v1) < VELOCITY_THRESHOLD and math.abs(p1 - g) < POSITION_THRESHOLD
    return {
        complete = complete,
        value = complete and g or p1,
        velocity = v1
    }
end
local noop = function()
end
local BaseMotor = {}
BaseMotor.__index = BaseMotor
function BaseMotor.new()
    return setmetatable(
        {
            _onStep = Signal.new(),
            _onStart = Signal.new(),
            _onComplete = Signal.new()
        },
        BaseMotor
    )
end
function BaseMotor:onStep(handler)
    return self._onStep:connect(handler)
end
function BaseMotor:onStart(handler)
    return self._onStart:connect(handler)
end
function BaseMotor:onComplete(handler)
    return self._onComplete:connect(handler)
end
function BaseMotor:start()
    if not self._connection then
        self._connection =
            RunService.RenderStepped:Connect(
            function(deltaTime)
                self:step(deltaTime)
            end
        )
    end
end
function BaseMotor:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
end
BaseMotor.destroy = BaseMotor.stop
BaseMotor.step = noop
BaseMotor.getValue = noop
BaseMotor.setGoal = noop
function BaseMotor:__tostring()
    return "Motor"
end
local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor
function SingleMotor.new(initialValue, useImplicitConnections)
    assert(initialValue, "Missing argument #1: initialValue")
    assert(typeof(initialValue) == "number", "initialValue must be a number!")
    local self = setmetatable(BaseMotor.new(), SingleMotor)
    if useImplicitConnections ~= nil then
        self._useImplicitConnections = useImplicitConnections
    else
        self._useImplicitConnections = true
    end
    self._goal = nil
    self._state = {
        complete = true,
        value = initialValue
    }
    return self
end
function SingleMotor:step(deltaTime)
    if self._state.complete then
        return true
    end
    local newState = self._goal:step(self._state, deltaTime)
    self._state = newState
    self._onStep:fire(newState.value)
    if newState.complete then
        if self._useImplicitConnections then
            self:stop()
        end
        self._onComplete:fire()
    end
    return newState.complete
end
function SingleMotor:getValue()
    return self._state.value
end
function SingleMotor:setGoal(goal)
    self._state.complete = false
    self._goal = goal
    self._onStart:fire()
    if self._useImplicitConnections then
        self:start()
    end
end
function SingleMotor:__tostring()
    return "Motor(Single)"
end
local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor
local function toMotor(value)
    if isMotor(value) then
        return value
    end
    local valueType = typeof(value)
    if valueType == "number" then
        return SingleMotor.new(value, false)
    elseif valueType == "table" then
        return GroupMotor.new(value, false)
    end
    error(("Unable to convert %q to motor; type %s is unsupported"):format(value, valueType), 2)
end
function GroupMotor.new(initialValues, useImplicitConnections)
    assert(initialValues, "Missing argument #1: initialValues")
    assert(typeof(initialValues) == "table", "initialValues must be a table!")
    assert(
        not initialValues.step,
        'initialValues contains disallowed property "step". Did you mean to put a table of values here?'
    )
    local self = setmetatable(BaseMotor.new(), GroupMotor)
    if useImplicitConnections ~= nil then
        self._useImplicitConnections = useImplicitConnections
    else
        self._useImplicitConnections = true
    end
    self._complete = true
    self._motors = {}
    for key, value in pairs(initialValues) do
        self._motors[key] = toMotor(value)
    end
    return self
end
function GroupMotor:step(deltaTime)
    if self._complete then
        return true
    end
    local allMotorsComplete = true
    for _, motor in pairs(self._motors) do
        local complete = motor:step(deltaTime)
        if not complete then
            allMotorsComplete = false
        end
    end
    self._onStep:fire(self:getValue())
    if allMotorsComplete then
        if self._useImplicitConnections then
            self:stop()
        end
        self._complete = true
        self._onComplete:fire()
    end
    return allMotorsComplete
end
function GroupMotor:setGoal(goals)
    assert(not goals.step, 'goals contains disallowed property "step". Did you mean to put a table of goals here?')
    self._complete = false
    self._onStart:fire()
    for key, goal in pairs(goals) do
        local motor = assert(self._motors[key], ("Unknown motor for key %s"):format(key))
        motor:setGoal(goal)
    end
    if self._useImplicitConnections then
        self:start()
    end
end
function GroupMotor:getValue()
    local values = {}
    for key, motor in pairs(self._motors) do
        values[key] = motor:getValue()
    end
    return values
end
function GroupMotor:__tostring()
    return "Motor(Group)"
end
local Flipper = {
    SingleMotor = SingleMotor,
    GroupMotor = GroupMotor,
    Instant = Instant,
    Linear = Linear,
    Spring = Spring,
    isMotor = isMotor
}
local Creator = {
    Registry = {},
    Signals = {},
    TransparencyMotors = {},
    DefaultProperties = {
        ScreenGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        },
        Frame = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0
        },
        ScrollingFrame = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            ScrollBarImageColor3 = Color3.new(0, 0, 0)
        },
        TextLabel = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            TextSize = 14
        },
        TextButton = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            AutoButtonColor = false,
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0),
            TextSize = 14
        },
        TextBox = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            ClearTextOnFocus = false,
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0),
            TextSize = 14
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0
        },
        ImageButton = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            AutoButtonColor = false
        },
        CanvasGroup = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0
        }
    }
}
local function ApplyCustomProps(Object, Props)
    if Props.ThemeTag then
        Creator.AddThemeObject(Object, Props.ThemeTag)
    end
end
function Creator.AddSignal(Signal, Function)
    local Connected = Signal:Connect(Function)
    table.insert(Creator.Signals, Connected)
    return Connected
end
function Creator.Disconnect()
    for Idx = #Creator.Signals, 1, -1 do
        local Connection = table.remove(Creator.Signals, Idx)
        if Connection.Disconnect then
            Connection:Disconnect()
        end
    end
end
Creator.Themes = Themes
Creator.Theme = Creator.Theme or "Dark"
function Creator.GetThemeProperty(Property)
    local Theme = Creator.Themes[Creator.Theme]
    if Theme then
        return Theme[Property]
    end
    return Creator.Themes.Dark[Property]
end
function Creator.UpdateTheme()
    if not Creator.Themes[Creator.Theme] then
        Creator.Theme = "Dark"
    end
    for Instance, Object in next, Creator.Registry do
        for Property, ColorIdx in next, Object.Properties do
            local themeValue = Creator.GetThemeProperty(ColorIdx)
            if themeValue then
                Instance[Property] = themeValue
            end
        end
    end
    local transparency = Creator.GetThemeProperty("ElementTransparency")
    if transparency then
        for _, Motor in next, Creator.TransparencyMotors do
            Motor:setGoal(Flipper.Instant.new(transparency))
        end
    end
end
function Creator.AddThemeObject(Object, Properties)
    local Idx = #Creator.Registry + 1
    local Data = {
        Object = Object,
        Properties = Properties,
        Idx = Idx
    }
    Creator.Registry[Object] = Data
    Creator.UpdateTheme()
    return Object
end
function Creator.OverrideTag(Object, Properties)
    Creator.Registry[Object].Properties = Properties
    Creator.UpdateTheme()
end
function Creator.GetThemeProperty(Property)
    local themeName = Creator.Theme or "Dark"
    local themeTable = Creator.Themes[themeName]
    if themeTable and themeTable[Property] ~= nil then
        return themeTable[Property]
    end
    if Creator.Themes and Creator.Themes.Dark and Creator.Themes.Dark[Property] ~= nil then
        return Creator.Themes.Dark[Property]
    end
    if Themes and Themes.Dark and Themes.Dark[Property] ~= nil then
        return Themes.Dark[Property]
    end
    return nil
end
function Creator.New(Name, Properties, Children)
    local Object = Instance.new(Name)
    for Name, Value in next, Creator.DefaultProperties[Name] or {} do
        Object[Name] = Value
    end
    for Name, Value in next, Properties or {} do
        if Name ~= "ThemeTag" then
            Object[Name] = Value
        end
    end
    for _, Child in next, Children or {} do
        Child.Parent = Object
    end
    ApplyCustomProps(Object, Properties)
    return Object
end
function Creator.SpringMotor(Initial, Instance, Prop, IgnoreDialogCheck, ResetOnThemeChange)
    IgnoreDialogCheck = IgnoreDialogCheck or false
    ResetOnThemeChange = ResetOnThemeChange or false
    local Motor = Flipper.SingleMotor.new(Initial)
    Motor:onStep(
        function(value)
            Instance[Prop] = value
        end
    )
    if ResetOnThemeChange then
        table.insert(Creator.TransparencyMotors, Motor)
    end
    local function SetValue(Value, Ignore)
        Ignore = Ignore or false
        if not IgnoreDialogCheck then
            if not Ignore then
                if Prop == "BackgroundTransparency" and Library.DialogOpen then
                    return
                end
            end
        end
        Motor:setGoal(Flipper.Spring.new(Value, {frequency = 8}))
    end
    return Motor, SetValue
end
Library.Creator = Creator
local New = Creator.New
local GUI =
    New(
    "ScreenGui",
    {
        Parent = (gethui and gethui() or LocalPlayer:WaitForChild("PlayerGui"))
    }
)
Library.GUI = GUI
ProtectGui(GUI)
function Library:SafeCallback(Function, ...)
    if not Function then
        return
    end
    local Success, Event = pcall(Function, ...)
    if not Success then
        local _, i = Event:find(":%d+: ")
        if not i then
            return Library:Notify(
                {
                    Title = "Interface",
                    Content = "Callback error",
                    SubContent = Event,
                    Duration = 5
                }
            )
        end
        return Library:Notify(
            {
                Title = "Interface",
                Content = "Callback error",
                SubContent = Event:sub(i + 1),
                Duration = 5
            }
        )
    end
end
function Library:Round(Number, Factor)
    if Factor == 0 then
        return math.floor(Number)
    end
    Number = tostring(Number)
    return Number:find("%.") and tonumber(Number:sub(1, Number:find("%.") + Factor)) or Number
end
local function map(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end
local function viewportPointToWorld(location, distance)
    local unitRay = game:GetService("Workspace").CurrentCamera:ScreenPointToRay(location.X, location.Y)
    return unitRay.Origin + unitRay.Direction * distance
end
local function getOffset()
    local viewportSizeY = game:GetService("Workspace").CurrentCamera.ViewportSize.Y
    return map(viewportSizeY, 0, 2560, 8, 56)
end
local viewportPointToWorld, getOffset = unpack({viewportPointToWorld, getOffset})
local BlurFolder = Instance.new("Folder", game:GetService("Workspace").CurrentCamera)
local function createAcrylic()
    local Part =
        Creator.New(
        "Part",
        {
            Name = "Body",
            Color = Color3.new(0, 0, 0),
            Material = Enum.Material.Glass,
            Size = Vector3.new(1, 1, 0),
            Anchored = true,
            CanCollide = false,
            Locked = true,
            CastShadow = false,
            Transparency = 0.98
        },
        {
            Creator.New(
                "SpecialMesh",
                {
                    MeshType = Enum.MeshType.Brick,
                    Offset = Vector3.new(0, 0, -0.000001)
                }
            )
        }
    )
    return Part
end
function AcrylicBlur()
    local function createAcrylicBlur(distance)
        local cleanups = {}
        distance = distance or 0.001
        local positions = {
            topLeft = Vector2.new(),
            topRight = Vector2.new(),
            bottomRight = Vector2.new()
        }
        local model = createAcrylic()
        model.Parent = BlurFolder
        local function updatePositions(size, position)
            positions.topLeft = position
            positions.topRight = position + Vector2.new(size.X, 0)
            positions.bottomRight = position + size
        end
        local function render()
            local res = game:GetService("Workspace").CurrentCamera
            if res then
                res = res.CFrame
            end
            local cond = res
            if not cond then
                cond = CFrame.new()
            end
            local camera = cond
            local topLeft = positions.topLeft
            local topRight = positions.topRight
            local bottomRight = positions.bottomRight
            local topLeft3D = viewportPointToWorld(topLeft, distance)
            local topRight3D = viewportPointToWorld(topRight, distance)
            local bottomRight3D = viewportPointToWorld(bottomRight, distance)
            local width = (topRight3D - topLeft3D).Magnitude
            local height = (topRight3D - bottomRight3D).Magnitude
            model.CFrame =
                CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, camera.XVector, camera.YVector, camera.ZVector)
            model.Mesh.Scale = Vector3.new(width, height, 0)
        end
        local function onChange(rbx)
            local offset = getOffset()
            local size = rbx.AbsoluteSize - Vector2.new(offset, offset)
            local position = rbx.AbsolutePosition + Vector2.new(offset / 2, offset / 2)
            updatePositions(size, position)
            task.spawn(render)
        end
        local function renderOnChange()
            local camera = game:GetService("Workspace").CurrentCamera
            if not camera then
                return
            end
            table.insert(cleanups, camera:GetPropertyChangedSignal("CFrame"):Connect(render))
            table.insert(cleanups, camera:GetPropertyChangedSignal("ViewportSize"):Connect(render))
            table.insert(cleanups, camera:GetPropertyChangedSignal("FieldOfView"):Connect(render))
            task.spawn(render)
        end
        model.Destroying:Connect(
            function()
                for _, item in cleanups do
                    pcall(
                        function()
                            item:Disconnect()
                        end
                    )
                end
            end
        )
        renderOnChange()
        return onChange, model
    end
    return function(distance)
        local Blur = {}
        local onChange, model = createAcrylicBlur(distance)
        local comp =
            Creator.New(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }
        )
        Creator.AddSignal(
            comp:GetPropertyChangedSignal("AbsolutePosition"),
            function()
                onChange(comp)
            end
        )
        Creator.AddSignal(
            comp:GetPropertyChangedSignal("AbsoluteSize"),
            function()
                onChange(comp)
            end
        )
        Blur.AddParent = function(Parent)
            Creator.AddSignal(
                Parent:GetPropertyChangedSignal("Visible"),
                function()
                    Blur.SetVisibility(Parent.Visible)
                end
            )
        end
        Blur.SetVisibility = function(Value)
            model.Transparency = Value and 0.98 or 1
        end
        Blur.Frame = comp
        Blur.Model = model
        return Blur
    end
end
function AcrylicPaint()
    local New = Creator.New
    local AcrylicBlur = AcrylicBlur()
    return function(props)
        local AcrylicPaint = {}
        AcrylicPaint.Frame =
            New(
            "Frame",
            {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 0.9,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 8)
                    }
                ),
                New(
                    "Frame",
                    {
                        BackgroundTransparency = 0.45,
                        Size = UDim2.fromScale(1, 1),
                        Name = "Background",
                        ThemeTag = {
                            BackgroundColor3 = "AcrylicMain"
                        }
                    },
                    {
                        New(
                            "UICorner",
                            {
                                CornerRadius = UDim.new(0, 8)
                            }
                        )
                    }
                ),
                New(
                    "Frame",
                    {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.4,
                        Size = UDim2.fromScale(1, 1)
                    },
                    {
                        New(
                            "UICorner",
                            {
                                CornerRadius = UDim.new(0, 8)
                            }
                        ),
                        New(
                            "UIGradient",
                            {
                                Rotation = 90,
                                ThemeTag = {
                                    Color = "AcrylicGradient"
                                }
                            }
                        )
                    }
                ),
                New(
                    "Frame",
                    {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        ZIndex = 2
                    },
                    {
                        New(
                            "UICorner",
                            {
                                CornerRadius = UDim.new(0, 8)
                            }
                        ),
                        New(
                            "UIStroke",
                            {
                                Transparency = 0.5,
                                Thickness = 1,
                                ThemeTag = {
                                    Color = "AcrylicBorder"
                                }
                            }
                        )
                    }
                )
            }
        )
        local Blur
        if Library.UseAcrylic then
            Blur = AcrylicBlur()
            Blur.Frame.Parent = AcrylicPaint.Frame
            AcrylicPaint.Model = Blur.Model
            AcrylicPaint.AddParent = Blur.AddParent
            AcrylicPaint.SetVisibility = Blur.SetVisibility
        end
        return AcrylicPaint
    end
end
local Acrylic = {
    AcrylicBlur = AcrylicBlur(),
    CreateAcrylic = createAcrylic,
    AcrylicPaint = AcrylicPaint()
}
function Acrylic.init()
    local baseEffect = Instance.new("DepthOfFieldEffect")
    baseEffect.FarIntensity = 0
    baseEffect.InFocusRadius = 0.1
    baseEffect.NearIntensity = 1
    local depthOfFieldDefaults = {}
    function Acrylic.Enable()
        for _, effect in pairs(depthOfFieldDefaults) do
            effect.Enabled = false
        end
        baseEffect.Parent = game:GetService("Lighting")
    end
    function Acrylic.Disable()
        for _, effect in pairs(depthOfFieldDefaults) do
            effect.Enabled = effect.enabled
        end
        baseEffect.Parent = nil
    end
    local function registerDefaults()
        local function register(object)
            if object:IsA("DepthOfFieldEffect") then
                depthOfFieldDefaults[object] = {enabled = object.Enabled}
            end
        end
        for _, child in pairs(game:GetService("Lighting"):GetChildren()) do
            register(child)
        end
        if game:GetService("Workspace").CurrentCamera then
            for _, child in pairs(game:GetService("Workspace").CurrentCamera:GetChildren()) do
                register(child)
            end
        end
    end
    registerDefaults()
    Acrylic.Enable()
end
local Components = {
    Assets = {
        Close = "",
        Min = "",
        Max = "",
        Restore = ""
    }
}
Components.Element =
    (function()
    local New = Creator.New
    local Spring = Flipper.Spring.new
    return function(Title, Desc, Parent, Hover, Options)
        local Element = {}
        local Options = Options or {}
        Element.TitleLabel =
            New(
            "TextLabel",
            {
                FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontWeight.Medium,
                    Enum.FontStyle.Normal
                ),
                Text = Title,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, 0, 0, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        Element.Header =
            New(
            "Frame",
            {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14)
            },
            {
                New(
                    "UIListLayout",
                    {
                        Padding = UDim.new(0, 5),
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }
                )
            }
        )
        if Options and Options.Icon then
            local iconImage = Options.Icon
            pcall(
                function()
                    if Library and Library.GetIcon then
                        local resolved = Library:GetIcon(Options.Icon)
                        if resolved then
                            iconImage = resolved
                        end
                    end
                end
            )
            Element.IconImage =
                New(
                "ImageLabel",
                {
                    Image = iconImage,
                    Size = UDim2.fromOffset(16, 16),
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    ThemeTag = {
                        ImageColor3 = "Text"
                    }
                }
            )
            Element.IconImage.Parent = Element.Header
        end
        Element.TitleLabel.Parent = Element.Header
        Element.DescLabel =
            New(
            "TextLabel",
            {
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Text = Desc,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                ThemeTag = {
                    TextColor3 = "SubText"
                }
            }
        )
        Element.LabelHolder =
            New(
            "Frame",
            {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -28, 0, 0)
            },
            {
                New(
                    "UIListLayout",
                    {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }
                ),
                New(
                    "UIPadding",
                    {
                        PaddingBottom = UDim.new(0, 13),
                        PaddingTop = UDim.new(0, 13)
                    }
                ),
                Element.Header,
                Element.DescLabel
            }
        )
        Element.Border =
            New(
            "UIStroke",
            {
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(0, 0, 0),
                ThemeTag = {
                    Color = "ElementBorder"
                }
            }
        )
        Element.Frame =
            New(
            "TextButton",
            {
                Visible = Options.Visible and Options.Visible or true,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 0.89,
                BackgroundColor3 = Color3.fromRGB(130, 130, 130),
                Parent = Parent,
                AutomaticSize = Enum.AutomaticSize.Y,
                Text = "",
                LayoutOrder = 7,
                ThemeTag = {
                    BackgroundColor3 = "Element",
                    BackgroundTransparency = "ElementTransparency"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 4)
                    }
                ),
                Element.Border,
                Element.LabelHolder
            }
        )
        function Element:SetTitle(Set)
            Element.TitleLabel.Text = Set
            local hasTitle = (Set ~= nil and Set ~= "")
            Element.Header.Visible = hasTitle
            if not hasTitle then
                if Element.IconImage then
                    if not Element.DescRow then
                        Element.DescRow =
                            New(
                            "Frame",
                            {
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, 14),
                                LayoutOrder = 2
                            },
                            {
                                New(
                                    "UIListLayout",
                                    {
                                        Padding = UDim.new(0, 5),
                                        FillDirection = Enum.FillDirection.Horizontal,
                                        SortOrder = Enum.SortOrder.LayoutOrder,
                                        VerticalAlignment = Enum.VerticalAlignment.Center
                                    }
                                )
                            }
                        )
                        Element.DescRow.Parent = Element.LabelHolder
                    end
                    if not Element.DescIconImage then
                        Element.DescIconImage =
                            New(
                            "ImageLabel",
                            {
                                Image = Element.IconImage.Image,
                                Size = UDim2.fromOffset(16, 16),
                                BackgroundTransparency = 1,
                                LayoutOrder = 1,
                                ThemeTag = {
                                    ImageColor3 = "Text"
                                }
                            }
                        )
                        Element.DescIconImage.Parent = Element.DescRow
                    else
                        Element.DescIconImage.Image = Element.IconImage.Image
                        Element.DescIconImage.Parent = Element.DescRow
                    end
                    Element.DescLabel.Parent = Element.DescRow
                    Element.DescLabel.LayoutOrder = 2
                    Element.DescLabel.Size = UDim2.new(1, -24, 0, 14)
                else
                    if Element.DescRow then
                        Element.DescRow:Destroy()
                        Element.DescRow = nil
                        Element.DescIconImage = nil
                    end
                    Element.DescLabel.Parent = Element.LabelHolder
                    Element.DescLabel.LayoutOrder = 2
                    Element.DescLabel.Size = UDim2.new(1, 0, 0, 14)
                end
            else
                if Element.DescRow then
                    Element.DescRow:Destroy()
                    Element.DescRow = nil
                    Element.DescIconImage = nil
                end
                Element.DescLabel.Parent = Element.LabelHolder
                Element.DescLabel.LayoutOrder = 2
                Element.DescLabel.Size = UDim2.new(1, 0, 0, 14)
            end
            if Library.Windows and #Library.Windows > 0 then
                local currentWindow = Library.Windows[#Library.Windows]
                if currentWindow and currentWindow.AllElements and currentWindow.AllElements[Element.Frame] then
                    currentWindow.AllElements[Element.Frame].title = Set
                end
            end
        end
        function Element:Visible(Bool)
            Element.Frame.Visible = Bool
        end
        function Element:SetDesc(Set)
            if Set == nil then
                Set = ""
            end
            if Set == "" then
                Element.DescLabel.Visible = false
            else
                Element.DescLabel.Visible = true
            end
            Element.DescLabel.Text = Set
            if Library.Windows and #Library.Windows > 0 then
                local currentWindow = Library.Windows[#Library.Windows]
                if currentWindow and currentWindow.AllElements and currentWindow.AllElements[Element.Frame] then
                    currentWindow.AllElements[Element.Frame].description = Set
                end
            end
        end
        function Element:GetTitle()
            return Element.TitleLabel.Text
        end
        function Element:GetDesc()
            return Element.DescLabel.Text
        end
        function Element:Destroy()
            Element.Frame:Destroy()
        end
        Element.Header.Visible = not (Title == nil or Title == "")
        Element:SetTitle(Title or "")
        Element:SetDesc(Desc)
        if Library.Windows and #Library.Windows > 0 then
            local currentWindow = Library.Windows[#Library.Windows]
            if currentWindow and currentWindow.RegisterElement then
                currentWindow.RegisterElement(Element.Frame, Title, "Element", Desc)
            end
        end
        if Hover then
            local Themes = Library.Themes
            local Motor, SetTransparency =
                Creator.SpringMotor(
                Creator.GetThemeProperty("ElementTransparency"),
                Element.Frame,
                "BackgroundTransparency",
                false,
                true
            )
            Creator.AddSignal(
                Element.Frame.MouseEnter,
                function()
                    SetTransparency(
                        Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange")
                    )
                end
            )
            Creator.AddSignal(
                Element.Frame.MouseLeave,
                function()
                    SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
                end
            )
            Creator.AddSignal(
                Element.Frame.MouseButton1Down,
                function()
                    SetTransparency(
                        Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange")
                    )
                end
            )
            Creator.AddSignal(
                Element.Frame.MouseButton1Up,
                function()
                    SetTransparency(
                        Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange")
                    )
                end
            )
        end
        return Element
    end
end)()
Components.Section =
    (function()
    local New = Creator.New
    return function(Title, Parent, Icon)
        local Section = {}
        Section.Layout =
            New(
            "UIListLayout",
            {
                Padding = UDim.new(0, 5)
            }
        )
        Section.Container =
            New(
            "Frame",
            {
                Size = UDim2.new(1, 0, 0, 26),
                Position = UDim2.fromOffset(0, 24),
                BackgroundTransparency = 1
            },
            {
                Section.Layout
            }
        )
        local SectionHeader =
            New(
            "Frame",
            {
                Size = UDim2.new(1, -16, 0, 18),
                Position = UDim2.fromOffset(0, 2),
                BackgroundTransparency = 1
            },
            {
                New(
                    "UIListLayout",
                    {
                        Padding = UDim.new(0, 5),
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }
                ),
                Icon and
                    New(
                        "ImageLabel",
                        {
                            Image = Icon,
                            Size = UDim2.fromOffset(16, 16),
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            ThemeTag = {
                                ImageColor3 = "Text"
                            }
                        }
                    ) or
                    nil,
                New(
                    "TextLabel",
                    {
                        RichText = true,
                        Text = Title,
                        TextTransparency = 0,
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                        TextSize = 18,
                        TextXAlignment = "Left",
                        TextYAlignment = "Center",
                        Size = UDim2.fromScale(0, 1),
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        ThemeTag = {
                            TextColor3 = "Text"
                        }
                    }
                )
            }
        )
        Section.Root =
            New(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26),
                LayoutOrder = 7,
                Parent = Parent
            },
            {
                SectionHeader,
                Section.Container
            }
        )
        Creator.AddSignal(
            Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"),
            function()
                Section.Container.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y)
                Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 25)
            end
        )
        if Library.Windows and #Library.Windows > 0 then
            local currentWindow = Library.Windows[#Library.Windows]
            if currentWindow and currentWindow.RegisterElement then
                currentWindow.RegisterElement(Section.Root, Title, "Section")
            end
        end
        return Section
    end
end)()
Components.Tab =
    (function()
    local New = Creator.New
    local Spring = Flipper.Spring.new
    local Instant = Flipper.Instant.new
    local Components = Components
    local TabModule = {
        Window = nil,
        Tabs = {},
        Containers = {},
        SelectedTab = 0,
        TabCount = 0
    }
    function TabModule:Init(Window)
        TabModule.Window = Window
        return TabModule
    end
    function TabModule:GetCurrentTabPos()
        local TabHolderPos = TabModule.Window.TabHolder.AbsolutePosition.Y
        local TabPos = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y
        return TabPos - TabHolderPos
    end
    function TabModule:New(Title, Icon, Parent)
        local Window = TabModule.Window
        local Elements = Library.Elements
        TabModule.TabCount = TabModule.TabCount + 1
        local TabIndex = TabModule.TabCount
        local Tab = {
            Selected = false,
            Name = Title,
            Type = "Tab"
        }
        local icon = Icon
        pcall(
            function()
                if Library:GetIcon(icon) then
                    icon = Library:GetIcon(icon)
                end
                if icon == "" or icon == nil then
                    icon = nil
                end
            end
        )
        Tab.Frame =
            New(
            "TextButton",
            {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundTransparency = 1,
                Parent = Parent,
                ThemeTag = {
                    BackgroundColor3 = "Tab"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 6)
                    }
                ),
                New(
                    "TextLabel",
                    {
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = icon and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
                        Text = Title,
                        RichText = true,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextTransparency = 0,
                        FontFace = Font.new(
                            "rbxasset://fonts/families/GothamSSm.json",
                            Enum.FontWeight.Regular,
                            Enum.FontStyle.Normal
                        ),
                        TextSize = 12,
                        TextXAlignment = "Left",
                        TextYAlignment = "Center",
                        Size = UDim2.new(1, -12, 1, 0),
                        BackgroundTransparency = 1,
                        ThemeTag = {
                            TextColor3 = "Text"
                        }
                    }
                ),
                New(
                    "ImageLabel",
                    {
                        AnchorPoint = Vector2.new(0, 0.5),
                        Size = UDim2.fromOffset(16, 16),
                        Position = UDim2.new(0, 8, 0.5, 0),
                        BackgroundTransparency = 1,
                        Image = icon and icon or nil,
                        ThemeTag = {
                            ImageColor3 = "Text"
                        }
                    }
                )
            }
        )
        local ContainerLayout =
            New(
            "UIListLayout",
            {
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            }
        )
        Tab.ContainerFrame =
            New(
            "ScrollingFrame",
            {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Parent = Window.ContainerHolder,
                Visible = false,
                ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
                ScrollBarImageTransparency = 0.95,
                ScrollBarThickness = 3,
                BorderSizePixel = 0,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y
            },
            {
                ContainerLayout,
                New(
                    "UIPadding",
                    {
                        PaddingRight = UDim.new(0, 10),
                        PaddingLeft = UDim.new(0, 1),
                        PaddingTop = UDim.new(0, 1),
                        PaddingBottom = UDim.new(0, 1)
                    }
                )
            }
        )
        Creator.AddSignal(
            ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"),
            function()
                Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
            end
        )
        Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")
        Creator.AddSignal(
            Tab.Frame.MouseEnter,
            function()
                Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
            end
        )
        Creator.AddSignal(
            Tab.Frame.MouseLeave,
            function()
                Tab.SetTransparency(Tab.Selected and 0.89 or 1)
            end
        )
        Creator.AddSignal(
            Tab.Frame.MouseButton1Down,
            function()
                Tab.SetTransparency(0.92)
            end
        )
        Creator.AddSignal(
            Tab.Frame.MouseButton1Up,
            function()
                Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
            end
        )
        Creator.AddSignal(
            Tab.Frame.MouseButton1Click,
            function()
                TabModule:SelectTab(TabIndex)
            end
        )
        TabModule.Containers[TabIndex] = Tab.ContainerFrame
        TabModule.Tabs[TabIndex] = Tab
        Tab.Container = Tab.ContainerFrame
        Tab.ScrollFrame = Tab.Container
        function Tab:AddSection(SectionTitle, SectionIcon)
            local Section = {Type = "Section"}
            local Icon = SectionIcon
            pcall(
                function()
                    if Library:GetIcon(Icon) then
                        Icon = Library:GetIcon(Icon)
                    end
                    if Icon == "" or Icon == nil then
                        Icon = nil
                    end
                end
            )
            local SectionFrame = Components.Section(SectionTitle, Tab.Container, Icon)
            Section.Container = SectionFrame.Container
            Section.ScrollFrame = Tab.Container
            setmetatable(Section, Elements)
            return Section
        end
        setmetatable(Tab, Elements)
        return Tab
    end
    function TabModule:SelectTab(Tab)
        local Window = TabModule.Window
        TabModule.SelectedTab = Tab
        for _, TabObject in next, TabModule.Tabs do
            TabObject.SetTransparency(1)
            TabObject.Selected = false
        end
        TabModule.Tabs[Tab].SetTransparency(0.89)
        TabModule.Tabs[Tab].Selected = true
        Window.TabDisplay.Text = TabModule.Tabs[Tab].Name
        Window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), {frequency = 6}))
        task.spawn(
            function()
                Window.ContainerHolder.Parent = Window.ContainerAnim
                Window.ContainerPosMotor:setGoal(Spring(15, {frequency = 10}))
                Window.ContainerBackMotor:setGoal(Spring(1, {frequency = 10}))
                task.wait(0.12)
                for _, Container in next, TabModule.Containers do
                    Container.Visible = false
                end
                TabModule.Containers[Tab].Visible = true
                Window.ContainerPosMotor:setGoal(Spring(0, {frequency = 5}))
                Window.ContainerBackMotor:setGoal(Spring(0, {frequency = 8}))
                task.wait(0.12)
                Window.ContainerHolder.Parent = Window.ContainerCanvas
            end
        )
    end
    return TabModule
end)()
Components.Button =
    (function()
    local New = Creator.New
    local Spring = Flipper.Spring.new
    return function(Theme, Parent, DialogCheck)
        DialogCheck = DialogCheck or false
        local Button = {}
        Button.Title =
            New(
            "TextLabel",
            {
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        Button.HoverFrame =
            New(
            "Frame",
            {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                ThemeTag = {
                    BackgroundColor3 = "Hover"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 4)
                    }
                )
            }
        )
        Button.Frame =
            New(
            "TextButton",
            {
                Size = UDim2.new(0, 0, 0, 32),
                Parent = Parent,
                ThemeTag = {
                    BackgroundColor3 = "DialogButton"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 4)
                    }
                ),
                New(
                    "UIStroke",
                    {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Transparency = 0.65,
                        ThemeTag = {
                            Color = "DialogButtonBorder"
                        }
                    }
                ),
                Button.HoverFrame,
                Button.Title
            }
        )
        local Motor, SetTransparency = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", DialogCheck)
        Creator.AddSignal(
            Button.Frame.MouseEnter,
            function()
                SetTransparency(0.97)
            end
        )
        Creator.AddSignal(
            Button.Frame.MouseLeave,
            function()
                SetTransparency(1)
            end
        )
        Creator.AddSignal(
            Button.Frame.MouseButton1Down,
            function()
                SetTransparency(1)
            end
        )
        Creator.AddSignal(
            Button.Frame.MouseButton1Up,
            function()
                SetTransparency(0.97)
            end
        )
        return Button
    end
end)()
Components.Dialog =
    (function()
    local Spring = Flipper.Spring.new
    local Instant = Flipper.Instant.new
    local New = Creator.New
    local Dialog = {
        Window = nil
    }
    function Dialog:Init(Window)
        Dialog.Window = Window
        return Dialog
    end
    function Dialog:Create()
        local NewDialog = {
            Buttons = 0
        }
        NewDialog.TintFrame =
            New(
            "TextButton",
            {
                Text = "",
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Parent = Dialog.Window.Root
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 8)
                    }
                )
            }
        )
        local TintMotor, TintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)
        NewDialog.ButtonHolder =
            New(
            "Frame",
            {
                Size = UDim2.new(1, -40, 1, -40),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                BackgroundTransparency = 1
            },
            {
                New(
                    "UIListLayout",
                    {
                        Padding = UDim.new(0, 10),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )
            }
        )
        NewDialog.ButtonHolderFrame =
            New(
            "Frame",
            {
                Size = UDim2.new(1, 0, 0, 70),
                Position = UDim2.new(0, 0, 1, -70),
                ThemeTag = {
                    BackgroundColor3 = "DialogHolder"
                }
            },
            {
                New(
                    "Frame",
                    {
                        Size = UDim2.new(1, 0, 0, 1),
                        ThemeTag = {
                            BackgroundColor3 = "DialogHolderLine"
                        }
                    }
                ),
                NewDialog.ButtonHolder
            }
        )
        NewDialog.Title =
            New(
            "TextLabel",
            {
                FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontWeight.SemiBold,
                    Enum.FontStyle.Normal
                ),
                Text = "Dialog",
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = 22,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, 0, 0, 22),
                Position = UDim2.fromOffset(20, 25),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        NewDialog.Scale =
            New(
            "UIScale",
            {
                Scale = 1
            }
        )
        local ScaleMotor, Scale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")
        NewDialog.Root =
            New(
            "CanvasGroup",
            {
                Size = UDim2.fromOffset(300, 165),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                GroupTransparency = 1,
                Parent = NewDialog.TintFrame,
                ThemeTag = {
                    BackgroundColor3 = "Dialog"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 8)
                    }
                ),
                New(
                    "UIStroke",
                    {
                        Transparency = 0.5,
                        ThemeTag = {
                            Color = "DialogBorder"
                        }
                    }
                ),
                NewDialog.Scale,
                NewDialog.Title,
                NewDialog.ButtonHolderFrame
            }
        )
        local RootMotor, RootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")
        function NewDialog:Open()
            Library.DialogOpen = true
            NewDialog.Scale.Scale = 1.1
            TintTransparency(0.75)
            RootTransparency(0)
            Scale(1)
        end
        function NewDialog:Close()
            Library.DialogOpen = false
            TintTransparency(1)
            RootTransparency(1)
            Scale(1.1)
            NewDialog.Root.UIStroke:Destroy()
            task.wait(0.15)
            NewDialog.TintFrame:Destroy()
        end
        function NewDialog:Button(Title, Callback)
            NewDialog.Buttons = NewDialog.Buttons + 1
            Title = Title or "Button"
            Callback = Callback or function()
                end
            local Button = Components.Button("", NewDialog.ButtonHolder, true)
            Button.Title.Text = Title
            for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
                if Btn:IsA("TextButton") then
                    Btn.Size =
                        UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 10) / NewDialog.Buttons), 0, 32)
                end
            end
            Creator.AddSignal(
                Button.Frame.MouseButton1Click,
                function()
                    Library:SafeCallback(Callback)
                    pcall(
                        function()
                            NewDialog:Close()
                        end
                    )
                end
            )
            return Button
        end
        return NewDialog
    end
    return Dialog
end)()
Components.Notification =
    (function()
    local Spring = Flipper.Spring.new
    local Instant = Flipper.Instant.new
    local New = Creator.New
    local Notification = {}
    function Notification:Init(GUI)
        Library.ActiveNotifications = Library.ActiveNotifications or {}
        Notification.Holder =
            New(
            "Frame",
            {
                Position = UDim2.new(1, -30, 1, -30),
                Size = UDim2.new(0, 310, 1, -30),
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
                Parent = GUI
            },
            {
                New(
                    "UIListLayout",
                    {
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Bottom,
                        Padding = UDim.new(0, 20)
                    }
                )
            }
        )
    end
    function Notification:New(Config)
        Config.Title = Config.Title or "Title"
        Config.Content = Config.Content or "Content"
        Config.SubContent = Config.SubContent or ""
        Config.Duration = Config.Duration or nil
        local NewNotification = {
            Closed = false
        }
        NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()
        NewNotification.Title =
            New(
            "TextLabel",
            {
                Position = UDim2.new(0, 14, 0, 17),
                Text = Config.Title,
                RichText = true,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextTransparency = 0,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextSize = 13,
                TextXAlignment = "Left",
                TextYAlignment = "Center",
                Size = UDim2.new(1, -12, 0, 12),
                TextWrapped = true,
                BackgroundTransparency = 1,
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        NewNotification.ContentLabel =
            New(
            "TextLabel",
            {
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Text = Config.Content,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, 0, 0, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                TextWrapped = true,
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        NewNotification.SubContentLabel =
            New(
            "TextLabel",
            {
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Text = Config.SubContent,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, 0, 0, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                TextWrapped = true,
                ThemeTag = {
                    TextColor3 = "SubText"
                }
            }
        )
        NewNotification.LabelHolder =
            New(
            "Frame",
            {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 40),
                Size = UDim2.new(1, -28, 0, 0)
            },
            {
                New(
                    "UIListLayout",
                    {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 3)
                    }
                ),
                NewNotification.ContentLabel,
                NewNotification.SubContentLabel
            }
        )
        NewNotification.CloseButton =
            New(
            "TextButton",
            {
                Text = "",
                Position = UDim2.new(1, -14, 0, 13),
                Size = UDim2.fromOffset(20, 20),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1
            },
            {
                New(
                    "ImageLabel",
                    {
                        Image = Components.Close,
                        Size = UDim2.fromOffset(16, 16),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        ThemeTag = {
                            ImageColor3 = "Text"
                        }
                    }
                )
            }
        )
        NewNotification.Root =
            New(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.fromScale(1, 0)
            },
            {
                NewNotification.AcrylicPaint.Frame,
                NewNotification.Title,
                NewNotification.CloseButton,
                NewNotification.LabelHolder
            }
        )
        if Config.Content == "" then
            NewNotification.ContentLabel.Visible = false
        end
        if Config.SubContent == "" then
            NewNotification.SubContentLabel.Visible = false
        end
        NewNotification.Holder =
            New(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 200),
                Parent = Notification.Holder
            },
            {
                NewNotification.Root
            }
        )
        local RootMotor =
            Flipper.GroupMotor.new(
            {
                Scale = 1,
                Offset = 60
            }
        )
        RootMotor:onStep(
            function(Values)
                NewNotification.Root.Position = UDim2.new(Values.Scale, Values.Offset, 0, 0)
            end
        )
        Creator.AddSignal(
            NewNotification.CloseButton.MouseButton1Click,
            function()
                NewNotification:Close()
            end
        )
        function NewNotification:ApplyTransparency()
            if Library.Theme == "Glass" and Library.UseAcrylic then
                local Value = Library.NotificationTransparency or 1
                local notifTransparency = 0.85 + (Value * 0.08)
                if Value > 1 then
                    notifTransparency = 0.93 + ((Value - 1) * 0.04)
                end
                local notifBackgroundTransparency = 0.8 + (Value * 0.1)
                if Value > 1 then
                    notifBackgroundTransparency = 0.9 + ((Value - 1) * 0.05)
                end
                if NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Model then
                    NewNotification.AcrylicPaint.Model.Transparency = math.min(notifTransparency, 0.97)
                end
                if
                    NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Frame and
                        NewNotification.AcrylicPaint.Frame.Background
                 then
                    NewNotification.AcrylicPaint.Frame.Background.BackgroundTransparency =
                        math.min(notifBackgroundTransparency, 0.95)
                end
            end
        end
        function NewNotification:Open()
            local ContentSize = NewNotification.LabelHolder.AbsoluteSize.Y
            NewNotification.Holder.Size = UDim2.new(1, 0, 0, 58 + ContentSize)
            RootMotor:setGoal(
                {
                    Scale = Spring(0, {frequency = 5}),
                    Offset = Spring(0, {frequency = 5})
                }
            )
            task.defer(
                function()
                    task.wait(0.1)
                    NewNotification:ApplyTransparency()
                end
            )
        end
        function NewNotification:Close()
            if not NewNotification.Closed then
                NewNotification.Closed = true
                for i, notif in pairs(Library.ActiveNotifications or {}) do
                    if notif == NewNotification then
                        table.remove(Library.ActiveNotifications, i)
                        break
                    end
                end
                task.spawn(
                    function()
                        RootMotor:setGoal(
                            {
                                Scale = Spring(1, {frequency = 5}),
                                Offset = Spring(60, {frequency = 5})
                            }
                        )
                        task.wait(0.4)
                        if Library.UseAcrylic then
                            NewNotification.AcrylicPaint.Model:Destroy()
                        end
                        NewNotification.Holder:Destroy()
                    end
                )
            end
        end
        table.insert(Library.ActiveNotifications, NewNotification)
        NewNotification:Open()
        if Config.Duration then
            task.delay(
                Config.Duration,
                function()
                    NewNotification:Close()
                end
            )
        end
        return NewNotification
    end
    return Notification
end)()
Components.Textbox =
    (function()
    local New = Creator.New
    return function(Parent, Acrylic)
        Acrylic = Acrylic or false
        local Textbox = {}
        Textbox.Input =
            New(
            "TextBox",
            {
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromOffset(10, 0),
                ThemeTag = {
                    TextColor3 = "Text",
                    PlaceholderColor3 = "SubText"
                }
            }
        )
        Textbox.Container =
            New(
            "Frame",
            {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Position = UDim2.new(0, 6, 0, 0),
                Size = UDim2.new(1, -12, 1, 0)
            },
            {
                Textbox.Input
            }
        )
        Textbox.Indicator =
            New(
            "Frame",
            {
                Size = UDim2.new(1, -4, 0, 1),
                Position = UDim2.new(0, 2, 1, 0),
                AnchorPoint = Vector2.new(0, 1),
                BackgroundTransparency = Acrylic and 0.5 or 0,
                ThemeTag = {
                    BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine"
                }
            }
        )
        Textbox.Frame =
            New(
            "Frame",
            {
                Size = UDim2.fromOffset(0, 0, 0, 30),
                BackgroundTransparency = Acrylic and 0.9 or 0,
                Parent = Parent,
                ThemeTag = {
                    BackgroundColor3 = Acrylic and "Input" or "DialogInput"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 4)
                    }
                ),
                New(
                    "UIStroke",
                    {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Transparency = Acrylic and 0.5 or 0.65,
                        ThemeTag = {
                            Color = Acrylic and "InElementBorder" or "DialogButtonBorder"
                        }
                    }
                ),
                Textbox.Indicator,
                Textbox.Container
            }
        )
        local function Update()
            local PADDING = 2
            local Reveal = Textbox.Container.AbsoluteSize.X
            if not Textbox.Input:IsFocused() or Textbox.Input.TextBounds.X <= Reveal - 2 * PADDING then
                Textbox.Input.Position = UDim2.new(0, PADDING, 0, 0)
            else
                local Cursor = Textbox.Input.CursorPosition
                if Cursor ~= -1 then
                    local subtext = string.sub(Textbox.Input.Text, 1, Cursor - 1)
                    local width =
                        TextService:GetTextSize(
                        subtext,
                        Textbox.Input.TextSize,
                        Textbox.Input.Font,
                        Vector2.new(math.huge, math.huge)
                    ).X
                    local CurrentCursorPos = Textbox.Input.Position.X.Offset + width
                    if CurrentCursorPos < PADDING then
                        Textbox.Input.Position = UDim2.fromOffset(PADDING - width, 0)
                    elseif CurrentCursorPos > Reveal - PADDING - 1 then
                        Textbox.Input.Position = UDim2.fromOffset(Reveal - width - PADDING - 1, 0)
                    end
                end
            end
        end
        task.spawn(Update)
        Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update)
        Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update)
        Creator.AddSignal(
            Textbox.Input.Focused,
            function()
                Update()
                Textbox.Indicator.Size = UDim2.new(1, -2, 0, 2)
                Textbox.Indicator.Position = UDim2.new(0, 1, 1, 0)
                Textbox.Indicator.BackgroundTransparency = 0
                Creator.OverrideTag(Textbox.Frame, {BackgroundColor3 = Acrylic and "InputFocused" or "DialogHolder"})
                Creator.OverrideTag(Textbox.Indicator, {BackgroundColor3 = "InputIndicatorFocus"})
            end
        )
        Creator.AddSignal(
            Textbox.Input.FocusLost,
            function()
                Update()
                Textbox.Indicator.Size = UDim2.new(1, -4, 0, 1)
                Textbox.Indicator.Position = UDim2.new(0, 2, 1, 0)
                Textbox.Indicator.BackgroundTransparency = 0.5
                Creator.OverrideTag(Textbox.Frame, {BackgroundColor3 = Acrylic and "Input" or "DialogInput"})
                Creator.OverrideTag(
                    Textbox.Indicator,
                    {BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine"}
                )
            end
        )
        return Textbox
    end
end)()
Components.TitleBar =
    (function()
    local New = Creator.New
    local AddSignal = Creator.AddSignal
    local function parseColor(value)
        if typeof(value) == "Color3" then
            return value
        end
        if typeof(value) == "string" then
            local hex = value:gsub("#", "")
            if #hex == 6 then
                local r = tonumber(hex:sub(1, 2), 16) or 255
                local g = tonumber(hex:sub(3, 4), 16) or 255
                local b = tonumber(hex:sub(5, 6), 16) or 255
                return Color3.fromRGB(r, g, b)
            end
        end
        return Themes[Library.Theme].SubText or Color3.fromRGB(170, 170, 170)
    end
    return function(Config)
        local TitleBar = {}
        local function BarButton(Icon, Pos, Parent, Callback)
            local Button = {
                Callback = Callback or function()
                    end
            }
            Button.Frame =
                New(
                "TextButton",
                {
                    Size = UDim2.new(0, 34, 1, -8),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Parent = Parent,
                    Position = Pos,
                    Text = "",
                    ThemeTag = {
                        BackgroundColor3 = "Text"
                    }
                },
                {
                    New(
                        "UICorner",
                        {
                            CornerRadius = UDim.new(0, 7)
                        }
                    ),
                    New(
                        "ImageLabel",
                        {
                            Image = Icon,
                            Size = UDim2.fromOffset(16, 16),
                            Position = UDim2.fromScale(0.5, 0.5),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Name = "Icon",
                            ThemeTag = {
                                ImageColor3 = "Text"
                            }
                        }
                    )
                }
            )
            local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")
            AddSignal(
                Button.Frame.MouseEnter,
                function()
                    SetTransparency(0.94)
                end
            )
            AddSignal(
                Button.Frame.MouseLeave,
                function()
                    SetTransparency(1, true)
                end
            )
            AddSignal(
                Button.Frame.MouseButton1Down,
                function()
                    SetTransparency(0.96)
                end
            )
            AddSignal(
                Button.Frame.MouseButton1Up,
                function()
                    SetTransparency(0.94)
                end
            )
            AddSignal(Button.Frame.MouseButton1Click, Button.Callback)
            Button.SetCallback = function(Func)
                Button.Callback = Func
            end
            return Button
        end
        TitleBar.Frame =
            New(
            "Frame",
            {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
                Parent = Config.Parent
            },
            {
                New(
                    "Frame",
                    {
                        Size = UDim2.new(1, -16, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1
                    },
                    {
                        New(
                            "UIListLayout",
                            {
                                Padding = UDim.new(0, 5),
                                FillDirection = Enum.FillDirection.Horizontal,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }
                        ),
                        Config.Icon and
                            New(
                                "ImageLabel",
                                {
                                    Image = Config.Icon,
                                    Size = UDim2.fromOffset(20, 20),
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 1,
                                    ThemeTag = {
                                        ImageColor3 = "Text"
                                    }
                                }
                            ) or
                            nil,
                        New(
                            "TextLabel",
                            {
                                RichText = true,
                                Text = Config.Title,
                                FontFace = Font.new(
                                    "rbxasset://fonts/families/GothamSSm.json",
                                    Enum.FontWeight.Regular,
                                    Enum.FontStyle.Normal
                                ),
                                TextSize = 12,
                                TextXAlignment = "Left",
                                TextYAlignment = "Center",
                                Size = UDim2.fromScale(0, 1),
                                AutomaticSize = Enum.AutomaticSize.X,
                                BackgroundTransparency = 1,
                                LayoutOrder = Config.Icon and 2 or 1,
                                ThemeTag = {
                                    TextColor3 = "Text"
                                }
                            }
                        ),
                        Config.SubTitle and
                            New(
                                "TextLabel",
                                {
                                    RichText = true,
                                    Text = Config.SubTitle,
                                    TextTransparency = 0.4,
                                    FontFace = Font.new(
                                        "rbxasset://fonts/families/GothamSSm.json",
                                        Enum.FontWeight.Regular,
                                        Enum.FontStyle.Normal
                                    ),
                                    TextSize = 12,
                                    TextXAlignment = "Left",
                                    TextYAlignment = "Center",
                                    Size = UDim2.fromScale(0, 1),
                                    AutomaticSize = Enum.AutomaticSize.X,
                                    BackgroundTransparency = 1,
                                    LayoutOrder = Config.Icon and 3 or 2,
                                    ThemeTag = {
                                        TextColor3 = "Text"
                                    }
                                }
                            ) or
                            nil
                    }
                ),
                New(
                    "Frame",
                    {
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1, 0, 0, 1),
                        Position = UDim2.new(0, 0, 1, 0),
                        ThemeTag = {
                            BackgroundColor3 = "TitleBarLine"
                        }
                    }
                )
            }
        )
        TitleBar.CloseButton =
            BarButton(
            Components.Assets.Close,
            UDim2.new(1, -4, 0, 4),
            TitleBar.Frame,
            function()
                Library.Window:Dialog(
                    {
                        Title = "Close",
                        Content = "Are you sure you want to unload the interface?",
                        Buttons = {
                            {
                                Title = "Yes",
                                Callback = function()
                                    Library:Destroy()
                                end
                            },
                            {
                                Title = "No"
                            }
                        }
                    }
                )
            end
        )
        TitleBar.MaxButton =
            BarButton(
            Components.Assets.Max,
            UDim2.new(1, -40, 0, 4),
            TitleBar.Frame,
            function()
                Config.Window.Maximize(not Config.Window.Maximized)
            end
        )
        TitleBar.MinButton =
            BarButton(
            Components.Assets.Min,
            UDim2.new(1, -80, 0, 4),
            TitleBar.Frame,
            function()
                Library.Window:Minimize()
            end
        )
        return TitleBar
    end
end)()
Components.Window =
    (function()
    local Spring = Flipper.Spring.new
    local Instant = Flipper.Instant.new
    local New = Creator.New
    return function(Config)
        local Window = {
            Minimized = false,
            Maximized = false,
            Size = Config.Size,
            CurrentPos = 0,
            TabWidth = 0,
            Position = UDim2.fromOffset(0, 0)
        }
        local Dragging, DragInput, MousePos, StartPos = false
        local Resizing, ResizePos = false
        local MinimizeNotif = false
        Window.AcrylicPaint = Acrylic.AcrylicPaint()
        local function CenterWindow()
            local vp = Camera.ViewportSize
            local x = math.max(0, (vp.X - Window.Size.X.Offset) / 2)
            local y = math.max(0, (vp.Y - Window.Size.Y.Offset) / 2)
            Window.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
            if Window.Root then
                Window.Root.Position = Window.Position
            end
        end
        Window.TabWidth = Config.TabWidth
        local Selector =
            New(
            "Frame",
            {
                Size = UDim2.fromOffset(4, 0),
                BackgroundColor3 = Color3.fromRGB(76, 194, 255),
                Position = UDim2.fromOffset(0, (Window.TabHolderTop or 45) + 0),
                AnchorPoint = Vector2.new(0, 0.5),
                ThemeTag = {
                    BackgroundColor3 = "Accent"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 9)
                    }
                )
            }
        )
        local ResizeStartFrame =
            New(
            "Frame",
            {
                Size = UDim2.fromOffset(20, 20),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, -2)
            }
        )
        Window.TabHolder =
            New(
            "ScrollingFrame",
            {
                Size = UDim2.new(1, 0, 1, -45),
                Position = UDim2.new(0, 0, 0, 45),
                BackgroundTransparency = 1,
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                BorderSizePixel = 0,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y
            },
            {
                New(
                    "UIListLayout",
                    {
                        Padding = UDim.new(0, 4)
                    }
                )
            }
        )
        local SearchElements = {}
        local AllElements = {}
        local function UpdateElementVisibility(searchTerm)
            searchTerm = string.lower(searchTerm or "")
            for element, data in pairs(AllElements) do
                if element and element.Parent then
                    local shouldShow =
                        searchTerm == "" or string.find(string.lower(data.title), searchTerm, 1, true) or
                        (data.description and string.find(string.lower(data.description), searchTerm, 1, true))
                    element.Visible = shouldShow
                end
            end
            task.spawn(
                function()
                    task.wait(0.01)
                    if Window and Window.TabHolder then
                        for _, child in pairs(Window.TabHolder:GetChildren()) do
                            if child:IsA("ScrollingFrame") then
                                local layout = child:FindFirstChild("UIListLayout")
                                if layout then
                                    child.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 2)
                                end
                            end
                        end
                    end
                end
            )
        end
        local function RegisterElement(elementFrame, title, elementType, description)
            if elementFrame and title then
                AllElements[elementFrame] = {
                    title = title,
                    type = elementType or "Element",
                    description = description or ""
                }
            end
        end
        Window.ShowSearch = (Config.Search == nil) and true or (Config.Search and true or false)
        local SearchFrame =
            New(
            "Frame",
            {
                Size = UDim2.new(1, 0, 0, 35),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 0.9,
                ZIndex = 10,
                Visible = false,
                ThemeTag = {
                    BackgroundColor3 = "Element"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 6)
                    }
                ),
                New(
                    "UIStroke",
                    {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Transparency = 0.8,
                        Thickness = 1,
                        ThemeTag = {
                            Color = "ElementBorder"
                        }
                    }
                )
            }
        )
        local SearchTextbox = Components.Textbox(SearchFrame, true)
        SearchTextbox.Frame.Size = UDim2.new(1, -44, 1, -8)
        SearchTextbox.Frame.Position = UDim2.new(0, 10, 0, 4)
        SearchTextbox.Input.PlaceholderText = "Search..."
        SearchTextbox.Input.Text = ""
        local SearchIcon =
            New(
            "ImageLabel",
            {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new(1, -18, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Parent = SearchFrame,
                ThemeTag = {
                    ImageColor3 = "SubText"
                }
            }
        )
        Creator.AddSignal(
            SearchTextbox.Input:GetPropertyChangedSignal("Text"),
            function()
                local searchText = SearchTextbox.Input.Text
                UpdateElementVisibility(searchText)
            end
        )
        Creator.AddSignal(
            SearchTextbox.Input.FocusLost,
            function(enterPressed)
            end
        )
        Creator.AddSignal(
            UserInputService.InputBegan,
            function(input, gameProcessed)
                if gameProcessed then
                    return
                end
                if input.KeyCode == Enum.KeyCode.Escape and SearchTextbox.Input:IsFocused() then
                    SearchTextbox.Input.Text = ""
                    SearchTextbox.Input:ReleaseFocus()
                end
            end
        )
        Window.SearchElements = SearchElements
        Window.AllElements = AllElements
        Window.RegisterElement = RegisterElement
        Window.UpdateElementVisibility = UpdateElementVisibility
        local TabFrame =
            New(
            "Frame",
            {
                Size = UDim2.new(0, Window.TabWidth, 1, Window.ShowSearch and -66 or -31),
                Position = UDim2.new(0, 12, 0, Window.ShowSearch and 54 or 19),
                BackgroundTransparency = 1,
                ClipsDescendants = true
            },
            {
                Window.TabHolder,
                Selector,
                SearchFrame
            }
        )
        Window.TabDisplay =
            New(
            "TextLabel",
            {
                RichText = true,
                Text = "Tab",
                TextTransparency = 0,
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                TextSize = 28,
                TextXAlignment = "Left",
                TextYAlignment = "Center",
                Size = UDim2.new(1, -16, 0, 28),
                Position = UDim2.fromOffset(Window.TabWidth + 26, 56),
                BackgroundTransparency = 1,
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        Window.ContainerHolder =
            New(
            "Frame",
            {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1
            }
        )
        Window.ContainerAnim =
            New(
            "CanvasGroup",
            {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1
            }
        )
        Window.ContainerCanvas =
            New(
            "Frame",
            {
                Size = UDim2.new(1, -Window.TabWidth - 32, 1, -102),
                Position = UDim2.fromOffset(Window.TabWidth + 26, 90),
                BackgroundTransparency = 1
            },
            {
                Window.ContainerAnim,
                Window.ContainerHolder
            }
        )
        Window.Root =
            New(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = Window.Size,
                Position = Window.Position,
                Parent = Config.Parent
            },
            {
                Window.AcrylicPaint.Frame,
                Window.TabDisplay,
                Window.ContainerCanvas,
                TabFrame,
                ResizeStartFrame
            }
        )
        CenterWindow()
        Creator.AddSignal(
            Camera:GetPropertyChangedSignal("ViewportSize"),
            function()
                CenterWindow()
            end
        )
        Window.TitleBar =
            Components.TitleBar(
            {
                Title = Config.Title,
                SubTitle = Config.SubTitle,
                Icon = Config.Icon,
                Parent = Window.Root,
                Window = Window
            }
        )
        if Library.UseAcrylic then
            Window.AcrylicPaint.AddParent(Window.Root)
        end
        local SizeMotor =
            Flipper.GroupMotor.new(
            {
                X = Window.Size.X.Offset,
                Y = Window.Size.Y.Offset
            }
        )
        local PosMotor =
            Flipper.GroupMotor.new(
            {
                X = Window.Position.X.Offset,
                Y = Window.Position.Y.Offset
            }
        )
        _G.CDDrag = 0
        Window.SelectorPosMotor = Flipper.SingleMotor.new(17)
        Window.SelectorSizeMotor = Flipper.SingleMotor.new(0)
        Window.ContainerBackMotor = Flipper.SingleMotor.new(0)
        Window.ContainerPosMotor = Flipper.SingleMotor.new(94)
        SizeMotor:onStep(
            function(values)
                task.wait(_G.CDDrag / 10)
                Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
            end
        )
        PosMotor:onStep(
            function(values)
                task.wait(_G.CDDrag / 10)
                Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
            end
        )
        local LastValue = 0
        local LastTime = 0
        Window.SelectorPosMotor:onStep(
            function(Value)
                local base = Window.TabHolderTop or 45
                local verticalInset = 16
                Selector.Position = UDim2.new(0, 0, 0, base + Value + verticalInset)
                local Now = tick()
                local DeltaTime = Now - LastTime
                if LastValue ~= nil then
                    Window.SelectorSizeMotor:setGoal(Spring((math.abs(Value - LastValue) / (DeltaTime * 60)) + 16))
                    LastValue = Value
                end
                LastTime = Now
            end
        )
        Window.SelectorSizeMotor:onStep(
            function(Value)
                Selector.Size = UDim2.new(0, 4, 0, Value)
            end
        )
        Window.ContainerBackMotor:onStep(
            function(Value)
                Window.ContainerAnim.GroupTransparency = Value
            end
        )
        Window.ContainerPosMotor:onStep(
            function(Value)
                Window.ContainerAnim.Position = UDim2.fromOffset(0, Value)
            end
        )
        local OldSizeX
        local OldSizeY
        Window.Maximize = function(Value, NoPos, Instant)
            Window.Maximized = Value
            Window.TitleBar.MaxButton.Frame.Icon.Image = Value and Components.Assets.Restore or Components.Assets.Max
            if Value then
                OldSizeX = Window.Size.X.Offset
                OldSizeY = Window.Size.Y.Offset
            end
            local SizeX = Value and Camera.ViewportSize.X or OldSizeX
            local SizeY = Value and Camera.ViewportSize.Y or OldSizeY
            SizeMotor:setGoal(
                {
                    X = Flipper[Instant and "Instant" or "Spring"].new(SizeX, {frequency = 6}),
                    Y = Flipper[Instant and "Instant" or "Spring"].new(SizeY, {frequency = 6})
                }
            )
            Window.Size = UDim2.fromOffset(SizeX, SizeY)
            if not NoPos then
                PosMotor:setGoal(
                    {
                        X = Spring(Value and 0 or Window.Position.X.Offset, {frequency = 6}),
                        Y = Spring(Value and 0 or Window.Position.Y.Offset, {frequency = 6})
                    }
                )
            end
        end
        Creator.AddSignal(
            Window.TitleBar.Frame.InputBegan,
            function(Input)
                if
                    Input.UserInputType == Enum.UserInputType.MouseButton1 or
                        Input.UserInputType == Enum.UserInputType.Touch
                 then
                    Dragging = true
                    MousePos = Input.Position
                    StartPos = Window.Root.Position
                    if Window.Maximized then
                        StartPos =
                            UDim2.fromOffset(
                            Mouse.X - (Mouse.X * ((OldSizeX - 100) / Window.Root.AbsoluteSize.X)),
                            Mouse.Y - (Mouse.Y * (OldSizeY / Window.Root.AbsoluteSize.Y))
                        )
                    end
                    Input.Changed:Connect(
                        function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                Dragging = false
                            end
                        end
                    )
                end
            end
        )
        Creator.AddSignal(
            Window.TitleBar.Frame.InputChanged,
            function(Input)
                if
                    Input.UserInputType == Enum.UserInputType.MouseMovement or
                        Input.UserInputType == Enum.UserInputType.Touch
                 then
                    DragInput = Input
                end
            end
        )
        Creator.AddSignal(
            ResizeStartFrame.InputBegan,
            function(Input)
                if
                    Input.UserInputType == Enum.UserInputType.MouseButton1 or
                        Input.UserInputType == Enum.UserInputType.Touch
                 then
                    Resizing = true
                    ResizePos = Input.Position
                end
            end
        )
        Creator.AddSignal(
            UserInputService.InputChanged,
            function(Input)
                if Input == DragInput and Dragging then
                    local Delta = Input.Position - MousePos
                    Window.Position = UDim2.fromOffset(StartPos.X.Offset + Delta.X, StartPos.Y.Offset + Delta.Y)
                    PosMotor:setGoal(
                        {
                            X = Instant(Window.Position.X.Offset),
                            Y = Instant(Window.Position.Y.Offset)
                        }
                    )
                    if Window.Maximized then
                        Window.Maximize(false, true, true)
                    end
                end
                if
                    (Input.UserInputType == Enum.UserInputType.MouseMovement or
                        Input.UserInputType == Enum.UserInputType.Touch) and
                        Resizing
                 then
                    local Delta = Input.Position - ResizePos
                    local StartSize = Window.Size
                    local TargetSize =
                        Vector3.new(StartSize.X.Offset, StartSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * Delta
                    local TargetSizeClamped =
                        Vector2.new(math.clamp(TargetSize.X, 470, 2048), math.clamp(TargetSize.Y, 380, 2048))
                    SizeMotor:setGoal(
                        {
                            X = Flipper.Instant.new(TargetSizeClamped.X),
                            Y = Flipper.Instant.new(TargetSizeClamped.Y)
                        }
                    )
                end
            end
        )
        Creator.AddSignal(
            UserInputService.InputEnded,
            function(Input)
                if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = false
                    Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
                end
            end
        )
        Creator.AddSignal(
            Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"),
            function()
                Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
            end
        )
        Creator.AddSignal(
            UserInputService.InputBegan,
            function(Input)
                if
                    type(Library.MinimizeKeybind) == "table" and Library.MinimizeKeybind.Type == "Keybind" and
                        not UserInputService:GetFocusedTextBox()
                 then
                    if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
                        Window:Minimize()
                    end
                elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
                    Window:Minimize()
                end
            end
        )
        function Window:Minimize()
            Window.Minimized = not Window.Minimized
            Window.Root.Visible = not Window.Minimized
            for _, Option in next, Library.Options do
                if Option and Option.Type == "Dropdown" and Option.Opened then
                    pcall(
                        function()
                            Option:Close()
                        end
                    )
                end
            end
            if not MinimizeNotif then
                MinimizeNotif = true
                local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
                if not Mobile then
                    Library:Notify(
                        {
                            Title = "Interface",
                            Content = "Press " .. Key .. " to toggle the interface.",
                            Duration = 6
                        }
                    )
                else
                    Library:Notify(
                        {
                            Title = "Interface",
                            Content = "Tap to the button to toggle the interface.",
                            Duration = 6
                        }
                    )
                end
            end
            function Window:ToggleSearch()
                Window.ShowSearch = not Window.ShowSearch
                SearchFrame.Visible = Window.ShowSearch
                TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, Window.ShowSearch and -66 or -31)
                TabFrame.Position = UDim2.new(0, 12, 0, Window.ShowSearch and 54 or 19)
            end
            if not RunService:IsStudio() and Library.Minimizer then
                pcall(
                    function()
                        if Mobile then
                            local mobileButton = Library.Minimizer:FindFirstChild("TextButton")
                            if mobileButton then
                                local imageLabel = mobileButton:FindFirstChild("ImageLabel")
                                if imageLabel then
                                    imageLabel.Image = Window.Minimized and "" or ""
                                end
                            end
                        else
                            local desktopButton = Library.Minimizer:FindFirstChild("TextButton")
                            if desktopButton then
                                local imageLabel = desktopButton:FindFirstChild("ImageLabel")
                                if imageLabel then
                                    imageLabel.Image = Window.Minimized and "" or ""
                                end
                            end
                        end
                    end
                )
            end
        end
        function Window:Destroy()
            if Library.UseAcrylic then
                Window.AcrylicPaint.Model:Destroy()
            end
            Window.Root:Destroy()
        end
        local DialogModule = Components.Dialog:Init(Window)
        function Window:Dialog(Config)
            local Dialog = DialogModule:Create()
            Dialog.Title.Text = Config.Title
            local ContentHolder =
                New(
                "ScrollingFrame",
                {
                    BackgroundTransparency = 1,
                    ScrollBarImageTransparency = 0.7,
                    ScrollBarThickness = 4,
                    Position = UDim2.fromOffset(20, 60),
                    Size = UDim2.new(1, -40, 1, -110),
                    CanvasSize = UDim2.fromOffset(0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Parent = Dialog.Root
                }
            )
            local Content =
                New(
                "TextLabel",
                {
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    Text = Config.Content,
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextWrapped = true,
                    Size = UDim2.new(1, -8, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = ContentHolder,
                    ThemeTag = {TextColor3 = "Text"}
                }
            )
            New(
                "UISizeConstraint",
                {
                    MinSize = Vector2.new(300, 165),
                    MaxSize = Vector2.new(620, math.huge),
                    Parent = Dialog.Root
                }
            )
            local maxWidth = math.min(620, Window.Size.X.Offset - 120)
            local baseWidth = math.max(300, math.min(maxWidth, Content.TextBounds.X + 40))
            Dialog.Root.Size = UDim2.fromOffset(baseWidth, 165)
            ContentHolder.Size = UDim2.new(1, -40, 1, -110)
            task.defer(
                function()
                    local contentHeight = Content.TextBounds.Y
                    local desired = math.clamp(contentHeight + 110, 165, 420)
                    Dialog.Root.Size = UDim2.fromOffset(baseWidth, desired)
                    ContentHolder.CanvasSize = UDim2.fromOffset(0, contentHeight)
                end
            )
            for _, Button in next, Config.Buttons do
                Dialog:Button(Button.Title, Button.Callback)
            end
            Dialog:Open()
        end
        local TabModule = Components.Tab:Init(Window)
        function Window:AddTab(TabConfig)
            return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder)
        end
        function Window:SelectTab(Tab)
            TabModule:SelectTab(Tab)
        end
        Creator.AddSignal(
            Window.TabHolder:GetPropertyChangedSignal("CanvasPosition"),
            function()
                LastValue = TabModule:GetCurrentTabPos() + 16
                LastTime = 0
                Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
            end
        )
        return Window
    end
end)()
local ElementsTable = {}
local AddSignal = Creator.AddSignal
ElementsTable.Button =
    (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Button"
    function Element:New(Config)
        assert(Config.Title, "Button - Missing Title")
        Config.Callback = Config.Callback or function()
            end
        local ButtonFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
        local ButtonIco =
            New(
            "ImageLabel",
            {
                Size = UDim2.fromOffset(16, 16),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundTransparency = 1,
                Parent = ButtonFrame.Frame,
                ThemeTag = {
                    ImageColor3 = "Text"
                }
            }
        )
        Creator.AddSignal(
            ButtonFrame.Frame.MouseButton1Click,
            function()
                Library:SafeCallback(Config.Callback)
            end
        )
        return ButtonFrame
    end
    return Element
end)()
ElementsTable.Toggle =
    (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Toggle"
    function Element:New(Idx, Config)
        assert(Config.Title, "Toggle - Missing Title")
        local Toggle = {
            Value = Config.Default or false,
            Callback = Config.Callback or function(Value)
                end,
            Type = "Toggle"
        }
        local ToggleFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
        ToggleFrame.DescLabel.Size = UDim2.new(1, -54, 0, 14)
        Toggle.SetTitle = ToggleFrame.SetTitle
        Toggle.SetDesc = ToggleFrame.SetDesc
        Toggle.Visible = ToggleFrame.Visible
        Toggle.Elements = ToggleFrame
        local ToggleCircle =
            New(
            "ImageLabel",
            {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromOffset(14, 14),
                Position = UDim2.new(0, 2, 0.5, 0),
                ImageTransparency = 0.5,
                ThemeTag = {
                    ImageColor3 = "ToggleSlider"
                }
            }
        )
        local ToggleBorder =
            New(
            "UIStroke",
            {
                Transparency = 0.5,
                ThemeTag = {
                    Color = "ToggleSlider"
                }
            }
        )
        local ToggleSlider =
            New(
            "Frame",
            {
                Size = UDim2.fromOffset(36, 18),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Parent = ToggleFrame.Frame,
                BackgroundTransparency = 1,
                ThemeTag = {
                    BackgroundColor3 = "Accent"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 9)
                    }
                ),
                ToggleBorder,
                ToggleCircle
            }
        )
        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
            Func(Toggle.Value)
        end
        function Toggle:SetValue(Value)
            Value = not (not Value)
            Toggle.Value = Value
            Creator.OverrideTag(ToggleBorder, {Color = Toggle.Value and "Accent" or "ToggleSlider"})
            Creator.OverrideTag(ToggleCircle, {ImageColor3 = Toggle.Value and "ToggleToggled" or "ToggleSlider"})
            TweenService:Create(
                ToggleCircle,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, Toggle.Value and 19 or 2, 0.5, 0)}
            ):Play()
            TweenService:Create(
                ToggleSlider,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {BackgroundTransparency = Toggle.Value and 0.45 or 1}
            ):Play()
            ToggleCircle.ImageTransparency = Toggle.Value and 0 or 0.5
            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end
        function Toggle:Destroy()
            ToggleFrame:Destroy()
            Library.Options[Idx] = nil
        end
        Creator.AddSignal(
            ToggleFrame.Frame.MouseButton1Click,
            function()
                Toggle:SetValue(not Toggle.Value)
            end
        )
        Toggle:SetValue(Toggle.Value)
        Library.Options[Idx] = Toggle
        return Toggle
    end
    return Element
end)()
ElementsTable.Dropdown =
    (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Dropdown"
    local New = Creator.New
    function Element:New(Idx, Config)
        local Dropdown = {
            Values = Config.Values,
            Value = Config.Default,
            Multi = Config.Multi,
            Buttons = {},
            Opened = false,
            Type = "Dropdown",
            Callback = Config.Callback or function()
                end,
            Search = (Config.Search == nil) and true or Config.Search,
            KeepSearch = Config.KeepSearch == true
        }
        if Dropdown.Multi and Config.AllowNull then
            Dropdown.Value = {}
        end
        local DropdownFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        DropdownFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)
        Dropdown.SetTitle = DropdownFrame.SetTitle
        Dropdown.SetDesc = DropdownFrame.SetDesc
        Dropdown.Visible = DropdownFrame.Visible
        Dropdown.Elements = DropdownFrame
        local DropdownDisplay =
            New(
            "TextLabel",
            {
                FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontWeight.Regular,
                    Enum.FontStyle.Normal
                ),
                Text = "",
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = 14,
                AutomaticSize = Enum.AutomaticSize.Y,
                TextYAlignment = Enum.TextYAlignment.Center,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, -40, 0.5, 0),
                Position = UDim2.new(0, 8, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        local DropdownIco =
            New(
            "ImageLabel",
            {
                Size = UDim2.fromOffset(16, 16),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -8, 0.5, 0),
                BackgroundTransparency = 1,
                Rotation = 180,
                ThemeTag = {
                    ImageColor3 = "SubText"
                }
            }
        )
        local DropdownInner =
            New(
            "TextButton",
            {
                Size = UDim2.fromOffset(160, 30),
                Position = UDim2.new(1, -10, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 0.9,
                Parent = DropdownFrame.Frame,
                ThemeTag = {
                    BackgroundColor3 = "DropdownFrame"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 5)
                    }
                ),
                New(
                    "UIStroke",
                    {
                        Transparency = 0.5,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        ThemeTag = {
                            Color = "InElementBorder"
                        }
                    }
                ),
                DropdownIco,
                DropdownDisplay
            }
        )
        local DropdownListLayout =
            New(
            "UIListLayout",
            {
                Padding = UDim.new(0, 3)
            }
        )
        local DropdownScrollFrame =
            New(
            "ScrollingFrame",
            {
                Size = UDim2.new(1, -5, 1, -10),
                Position = UDim2.fromOffset(5, 5),
                BackgroundTransparency = 1,
                ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
                ScrollBarImageTransparency = 0.75,
                ScrollBarThickness = 5,
                BorderSizePixel = 0,
                CanvasSize = UDim2.fromScale(0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollingDirection = Enum.ScrollingDirection.Y
            },
            {
                DropdownListLayout
            }
        )
        local SearchBar
        local SearchBox
        if Dropdown.Search then
            SearchBar =
                New(
                "Frame",
                {
                    Size = UDim2.new(1, -10, 0, 28),
                    Position = UDim2.fromOffset(5, 5),
                    BackgroundTransparency = 0.15,
                    ThemeTag = {BackgroundColor3 = "DropdownFrame"},
                    ZIndex = 24
                },
                {
                    New("UICorner", {CornerRadius = UDim.new(0, 8)}),
                    New(
                        "UIStroke",
                        {
                            Name = "Stroke",
                            Transparency = 0.45,
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            ThemeTag = {Color = "DropdownBorder"}
                        }
                    ),
                    New(
                        "ImageLabel",
                        {
                            BackgroundTransparency = 1,
                            Size = UDim2.fromOffset(16, 16),
                            Position = UDim2.fromOffset(8, 6),
                            ZIndex = 25,
                            ThemeTag = {ImageColor3 = "SubText"}
                        }
                    )
                }
            )
            SearchBox =
                New(
                "TextBox",
                {
                    PlaceholderText = "Search",
                    ClearTextOnFocus = false,
                    Text = "",
                    TextSize = 14,
                    FontFace = Font.new(
                        "rbxasset://fonts/families/GothamSSm.json",
                        Enum.FontWeight.Medium,
                        Enum.FontStyle.Normal
                    ),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = Color3.fromRGB(225, 225, 225),
                    TextTransparency = 0.05,
                    BackgroundTransparency = 1,
                    ThemeTag = {TextColor3 = "SubText", PlaceholderColor3 = "SubText"},
                    Parent = SearchBar,
                    Size = UDim2.new(1, -34, 1, 0),
                    Position = UDim2.fromOffset(28, 0),
                    ZIndex = 24
                }
            )
            local SearchStroke = SearchBar:FindFirstChild("Stroke")
            Creator.AddSignal(
                SearchBox.Focused,
                function()
                    Creator.OverrideTag(SearchBar, {BackgroundColor3 = "DropdownFrame"})
                    if SearchStroke then
                        Creator.OverrideTag(SearchStroke, {Color = "Accent"})
                        SearchStroke.Transparency = 0.25
                    end
                end
            )
            Creator.AddSignal(
                SearchBox.FocusLost,
                function()
                    Creator.OverrideTag(SearchBar, {BackgroundColor3 = "DropdownFrame"})
                    if SearchStroke then
                        Creator.OverrideTag(SearchStroke, {Color = "DropdownBorder"})
                        SearchStroke.Transparency = 0.45
                    end
                end
            )
            DropdownScrollFrame.Position = UDim2.fromOffset(5, 38)
            DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -43)
            local filterToken = 0
            local function ApplyFilter()
                filterToken = 1 + filterToken
                local myToken = filterToken
                task.delay(
                    0.03,
                    function()
                        if myToken ~= filterToken then
                            return
                        end
                        local text = (SearchBox.Text or ""):lower()
                        for _, element in next, DropdownScrollFrame:GetChildren() do
                            if not element:IsA("UIListLayout") then
                                local value = element:FindFirstChild("ButtonLabel") and element.ButtonLabel.Text or ""
                                element.Visible = text == "" or value:lower():find(text, 1, true) ~= nil
                            end
                        end
                        RecalculateCanvasSize()
                        RecalculateListSize()
                    end
                )
            end
            Creator.AddSignal(SearchBox:GetPropertyChangedSignal("Text"), ApplyFilter)
        end
        local DropdownHolderFrame =
            New(
            "Frame",
            {
                Size = UDim2.fromScale(1, 0.6),
                ThemeTag = {
                    BackgroundColor3 = "DropdownHolder"
                }
            },
            {
                SearchBar,
                DropdownScrollFrame,
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 7)
                    }
                ),
                New(
                    "UIStroke",
                    {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        ThemeTag = {
                            Color = "DropdownBorder"
                        }
                    }
                )
            }
        )
        local DropdownHolderCanvas =
            New(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(170, 300),
                Parent = Library.GUI,
                Visible = false
            },
            {
                DropdownHolderFrame,
                New(
                    "UISizeConstraint",
                    {
                        MinSize = Vector2.new(170, 0)
                    }
                )
            }
        )
        table.insert(Library.OpenFrames, DropdownHolderCanvas)
        local function RecalculateListPosition()
            local Add = -40
            if Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y < DropdownHolderCanvas.AbsoluteSize.Y - 5 then
                Add =
                    DropdownHolderCanvas.AbsoluteSize.Y - 5 - (Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y) +
                    40
            end
            DropdownHolderCanvas.Position =
                UDim2.fromOffset(DropdownInner.AbsolutePosition.X - 1, DropdownInner.AbsolutePosition.Y - 5 - Add)
        end
        local ListSizeX = 0
        local function RecalculateListSize()
            local totalCount = #Dropdown.Values
            local itemHeight = 32
            local padding = 3
            local innerMargins = 10
            local estimatedContent =
                (totalCount > 0) and (totalCount * itemHeight + (totalCount - 1) * padding + innerMargins) or
                innerMargins
            local maxHeight = 392
            local many = totalCount > 10
            local targetHeight = math.min(estimatedContent, maxHeight)
            DropdownHolderCanvas.Size = UDim2.fromOffset(ListSizeX, targetHeight)
            DropdownHolderFrame.Size = UDim2.fromScale(1, many and 0.6 or 1)
        end
        local function RecalculateCanvasSize()
            DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
        end
        RecalculateListPosition()
        RecalculateListSize()
        RecalculateCanvasSize()
        Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)
        Creator.AddSignal(
            DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"),
            function()
                RecalculateCanvasSize()
                RecalculateListSize()
            end
        )
        Creator.AddSignal(
            DropdownInner.MouseButton1Click,
            function()
                if Dropdown.Opened then
                    Dropdown:Close()
                    return
                end
                Dropdown:Open()
            end
        )
        Creator.AddSignal(
            DropdownInner.InputBegan,
            function(Input)
                if Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.Opened then
                        Dropdown:Close()
                        return
                    end
                    Dropdown:Open()
                end
            end
        )
        Creator.AddSignal(
            DropdownDisplay:GetPropertyChangedSignal("Text"),
            function()
                for _, Element in next, DropdownScrollFrame:GetChildren() do
                    if not Element:IsA("UIListLayout") then
                        Element.Visible = true
                    end
                end
                RecalculateListPosition()
                RecalculateListSize()
            end
        )
        Creator.AddSignal(
            UserInputService.InputBegan,
            function(Input)
                if
                    Input.UserInputType == Enum.UserInputType.MouseButton1 or
                        Input.UserInputType == Enum.UserInputType.Touch
                 then
                    local AbsPos, AbsSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
                    if
                        Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X or Mouse.Y < (AbsPos.Y - 20 - 1) or
                            Mouse.Y > AbsPos.Y + AbsSize.Y
                     then
                        Dropdown:Close()
                    end
                end
            end
        )
        local ScrollFrame = self.ScrollFrame
        function Dropdown:Open()
            Dropdown.Opened = true
            for _, frame in ipairs(Library.OpenFrames) do
                if frame ~= DropdownHolderCanvas and frame.Visible then
                    frame.Visible = false
                end
            end
            if SearchBox and not Dropdown.KeepSearch then
                SearchBox.Text = ""
            end
            ScrollFrame.ScrollingEnabled = true
            DropdownHolderCanvas.Visible = true
            TweenService:Create(
                DropdownHolderFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Size = UDim2.fromScale(1, 0.6)}
            ):Play()
            TweenService:Create(
                DropdownIco,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Rotation = 0}
            ):Play()
        end
        function Dropdown:Close()
            Dropdown.Opened = false
            ScrollFrame.ScrollingEnabled = false
            DropdownHolderFrame.Size = UDim2.fromScale(1, 0.6)
            DropdownHolderCanvas.Visible = false
            TweenService:Create(
                DropdownIco,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Rotation = 180}
            ):Play()
            Dropdown:Display()
            for _, element in next, DropdownScrollFrame:GetChildren() do
                if not element:IsA("UIListLayout") then
                    element.Visible = true
                end
            end
        end
        function Dropdown:Display()
            local Values = Dropdown.Values
            local Str = ""
            if Config.Multi then
                for Idx, Value in next, Values do
                    if Dropdown.Value[Value] then
                        Str = Str .. Value .. ", "
                    end
                end
                Str = Str:sub(1, #Str - 2)
            else
                Str = Dropdown.Value or ""
            end
            DropdownDisplay.Text = (Str == "" and "--" or Str)
        end
        function Dropdown:GetActiveValues()
            if Config.Multi then
                local T = {}
                for Value, Bool in next, Dropdown.Value do
                    table.insert(T, Value)
                end
                return T
            else
                return Dropdown.Value and 1 or 0
            end
        end
        function Dropdown:SetActiveValues(Value)
            Dropdown.Value = Value
            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
            Dropdown:BuildDropdownList()
        end
        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values
            local Buttons = {}
            for _, Element in next, DropdownScrollFrame:GetChildren() do
                if not Element:IsA("UIListLayout") then
                    Element:Destroy()
                end
            end
            local Count = 0
            for Idx, Value in next, Values do
                local Table = {}
                Count = Count + 1
                local ButtonSelector =
                    New(
                    "Frame",
                    {
                        Size = UDim2.fromOffset(4, 14),
                        BackgroundColor3 = Color3.fromRGB(76, 194, 255),
                        Position = UDim2.fromOffset(-1, 16),
                        AnchorPoint = Vector2.new(0, 0.5),
                        ThemeTag = {
                            BackgroundColor3 = "Accent"
                        }
                    },
                    {
                        New(
                            "UICorner",
                            {
                                CornerRadius = UDim.new(0, 2)
                            }
                        )
                    }
                )
                local ButtonLabel =
                    New(
                    "TextLabel",
                    {
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                        Text = Value,
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromOffset(10, 0),
                        Name = "ButtonLabel",
                        ThemeTag = {
                            TextColor3 = "Text"
                        }
                    }
                )
                local Button =
                    New(
                    "TextButton",
                    {
                        Size = UDim2.new(1, -5, 0, 32),
                        BackgroundTransparency = 1,
                        ZIndex = 23,
                        Text = "",
                        Parent = DropdownScrollFrame,
                        ThemeTag = {
                            BackgroundColor3 = "DropdownOption"
                        }
                    },
                    {
                        ButtonSelector,
                        ButtonLabel,
                        New(
                            "UICorner",
                            {
                                CornerRadius = UDim.new(0, 6)
                            }
                        )
                    }
                )
                local Selected
                if Config.Multi then
                    Selected = Dropdown.Value[Value]
                else
                    Selected = Dropdown.Value == Value
                end
                local BackMotor, SetBackTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency")
                local SelMotor, SetSelTransparency = Creator.SpringMotor(1, ButtonSelector, "BackgroundTransparency")
                local SelectorSizeMotor = Flipper.SingleMotor.new(6)
                SelectorSizeMotor:onStep(
                    function(value)
                        ButtonSelector.Size = UDim2.new(0, 4, 0, value)
                    end
                )
                Creator.AddSignal(
                    Button.MouseEnter,
                    function()
                        SetBackTransparency(Selected and 0.85 or 0.89)
                    end
                )
                Creator.AddSignal(
                    Button.MouseLeave,
                    function()
                        SetBackTransparency(Selected and 0.89 or 1)
                    end
                )
                Creator.AddSignal(
                    Button.MouseButton1Down,
                    function()
                        SetBackTransparency(0.92)
                    end
                )
                Creator.AddSignal(
                    Button.MouseButton1Up,
                    function()
                        SetBackTransparency(Selected and 0.85 or 0.89)
                    end
                )
                function Table:UpdateButton()
                    if Config.Multi then
                        Selected = Dropdown.Value[Value]
                        if Selected then
                            SetBackTransparency(0.89)
                        end
                    else
                        Selected = Dropdown.Value == Value
                        SetBackTransparency(Selected and 0.89 or 1)
                    end
                    SelectorSizeMotor:setGoal(Flipper.Spring.new(Selected and 14 or 6, {frequency = 6}))
                    SetSelTransparency(Selected and 0 or 1)
                end
                AddSignal(
                    Button.Activated,
                    function()
                        local Try = not Selected
                        if Dropdown:GetActiveValues() == 1 and not Try and not Config.AllowNull then
                        else
                            if Config.Multi then
                                Selected = Try
                                Dropdown.Value[Value] = Selected and true or nil
                            else
                                Selected = Try
                                Dropdown.Value = Selected and Value or nil
                                for _, OtherButton in next, Buttons do
                                    OtherButton:UpdateButton()
                                end
                            end
                            Table:UpdateButton()
                            Dropdown:Display()
                            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
                        end
                    end
                )
                Table:UpdateButton()
                Dropdown:Display()
                Buttons[Button] = Table
            end
            ListSizeX = 0
            for Button, Table in next, Buttons do
                if Button.ButtonLabel then
                    if Button.ButtonLabel.TextBounds.X > ListSizeX then
                        ListSizeX = Button.ButtonLabel.TextBounds.X
                    end
                end
            end
            ListSizeX = ListSizeX + 30
            RecalculateCanvasSize()
            RecalculateListSize()
        end
        function Dropdown:SetValues(NewValues)
            if NewValues then
                Dropdown.Values = NewValues
            end
            Dropdown:BuildDropdownList()
        end
        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func
            Func(Dropdown.Value)
        end
        function Dropdown:SetValue(Val)
            if Dropdown.Multi then
                local nTable = {}
                for Value, Bool in next, Val do
                    if table.find(Dropdown.Values, Value) then
                        nTable[Value] = true
                    end
                end
                Dropdown.Value = nTable
            else
                if not Val then
                    Dropdown.Value = nil
                elseif table.find(Dropdown.Values, Val) then
                    Dropdown.Value = Val
                end
            end
            Dropdown:BuildDropdownList()
            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
        end
        function Dropdown:Destroy()
            DropdownFrame:Destroy()
            Library.Options[Idx] = nil
        end
        Dropdown:BuildDropdownList()
        Dropdown:Display()
        local Defaults = {}
        if type(Config.Default) == "string" then
            local Idx = table.find(Dropdown.Values, Config.Default)
            if Idx then
                table.insert(Defaults, Idx)
            end
        elseif type(Config.Default) == "table" then
            for _, Value in next, Config.Default do
                local Idx = table.find(Dropdown.Values, Value)
                if Idx then
                    table.insert(Defaults, Idx)
                end
            end
        elseif type(Config.Default) == "number" and Dropdown.Values[Config.Default] ~= nil then
            table.insert(Defaults, Config.Default)
        end
        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Config.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index]
                end
                if not Config.Multi then
                    break
                end
            end
            Dropdown:BuildDropdownList()
            Dropdown:Display()
        end
        Library.Options[Idx] = Dropdown
        return Dropdown
    end
    return Element
end)()
ElementsTable.Paragraph = (function()
    local Paragraph = {}
    Paragraph.__index = Paragraph
    Paragraph.__type = "Paragraph"
    function Paragraph:New(Config)
        Config.Content = Config.Content or ""
        local Paragraph = Components.Element(Config.Title, Config.Content, Paragraph.Container, false, Config)
        Paragraph.Frame.BackgroundTransparency = 0.92
        Paragraph.Border.Transparency = 0.6
        Paragraph.SetTitle = Paragraph.SetTitle
        Paragraph.SetDesc = Paragraph.SetDesc
        Paragraph.Visible = Paragraph.Visible
        Paragraph.Elements = Paragraph
        return Paragraph
    end
    return Paragraph
end)()
ElementsTable.Slider =
    (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Slider"
    function Element:New(Idx, Config)
        assert(Config.Title, "Slider - Missing Title.")
        assert(Config.Default, "Slider - Missing default value.")
        assert(Config.Min, "Slider - Missing minimum value.")
        assert(Config.Max, "Slider - Missing maximum value.")
        assert(Config.Rounding, "Slider - Missing rounding value.")
        local Slider = {
            Value = nil,
            Min = Config.Min,
            Max = Config.Max,
            Rounding = Config.Rounding,
            Callback = Config.Callback or function(Value)
                end,
            Type = "Slider"
        }
        local Dragging = false
        local SliderFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        SliderFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)
        Slider.Elements = SliderFrame
        Slider.SetTitle = SliderFrame.SetTitle
        Slider.SetDesc = SliderFrame.SetDesc
        Slider.Visible = SliderFrame.Visible
        local SliderDot =
            New(
            "ImageLabel",
            {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, -7, 0.5, 0),
                Size = UDim2.fromOffset(14, 14),
                ImageTransparency = 0.5,
                ThemeTag = {
                    ImageColor3 = "Accent"
                }
            }
        )
        local SliderRail =
            New(
            "Frame",
            {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(7, 0),
                Size = UDim2.new(1, -14, 1, 0)
            },
            {
                SliderDot
            }
        )
        local SliderFill =
            New(
            "Frame",
            {
                Size = UDim2.new(0, 0, 1, 0),
                ThemeTag = {
                    BackgroundColor3 = "Accent"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(1, 0)
                    }
                )
            }
        )
        local SliderDisplay =
            New(
            "TextLabel",
            {
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Text = "Value",
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 100, 0, 14),
                Position = UDim2.new(0, -4, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                ThemeTag = {
                    TextColor3 = "SubText"
                }
            }
        )
        local SliderInner =
            New(
            "Frame",
            {
                Size = UDim2.new(1, 0, 0, 4),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundTransparency = 0.4,
                Parent = SliderFrame.Frame,
                ThemeTag = {
                    BackgroundColor3 = "SliderRail"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(1, 0)
                    }
                ),
                New(
                    "UISizeConstraint",
                    {
                        MaxSize = Vector2.new(150, math.huge)
                    }
                ),
                SliderDisplay,
                SliderFill,
                SliderRail
            }
        )
        Creator.AddSignal(
            SliderDot.InputBegan,
            function(Input)
                if
                    Input.UserInputType == Enum.UserInputType.MouseButton1 or
                        Input.UserInputType == Enum.UserInputType.Touch
                 then
                    Dragging = true
                end
            end
        )
        Creator.AddSignal(
            SliderDot.InputEnded,
            function(Input)
                if
                    Input.UserInputType == Enum.UserInputType.MouseButton1 or
                        Input.UserInputType == Enum.UserInputType.Touch
                 then
                    Dragging = false
                end
            end
        )
        Creator.AddSignal(
            UserInputService.InputChanged,
            function(Input)
                if Dragging then
                    local position = nil
                    if Input.UserInputType == Enum.UserInputType.MouseMovement then
                        position = Input.Position
                    elseif Input.UserInputType == Enum.UserInputType.Touch then
                        position = Input.Position
                    end
                    if position then
                        local SizeScale =
                            math.clamp((position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
                        Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
                    end
                end
            end
        )
        Creator.AddSignal(
            SliderRail.InputBegan,
            function(Input)
                if Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    local SizeScale =
                        math.clamp((Input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
                    Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
                end
            end
        )
        Creator.AddSignal(
            SliderRail.InputEnded,
            function(Input)
                if Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end
        )
        function Slider:OnChanged(Func)
            Slider.Changed = Func
            Func(Slider.Value)
        end
        function Slider:SetValue(Value)
            self.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Rounding)
            SliderDot.Position = UDim2.new((self.Value - Slider.Min) / (Slider.Max - Slider.Min), -7, 0.5, 0)
            SliderFill.Size = UDim2.fromScale((self.Value - Slider.Min) / (Slider.Max - Slider.Min), 1)
            SliderDisplay.Text = tostring(self.Value)
            Library:SafeCallback(Slider.Callback, self.Value)
            Library:SafeCallback(Slider.Changed, self.Value)
        end
        function Slider:Destroy()
            SliderFrame:Destroy()
            Library.Options[Idx] = nil
        end
        Slider:SetValue(Config.Default)
        Library.Options[Idx] = Slider
        return Slider
    end
    return Element
end)()
ElementsTable.Keybind =
    (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Keybind"
    function Element:New(Idx, Config)
        assert(Config.Title, "KeyBind - Missing Title")
        assert(Config.Default, "KeyBind - Missing default value.")
        local Keybind = {
            Value = Config.Default,
            Toggled = false,
            Mode = Config.Mode or "Toggle",
            Type = "Keybind",
            Callback = Config.Callback or function(Value)
                end,
            ChangedCallback = Config.ChangedCallback or function(New)
                end,
            Internal = {
                Pressed = false,
                LastDown = {}
            }
        }
        local Picking = false
        local KeybindFrame = Components.Element(Config.Title, Config.Description, self.Container, true)
        Keybind.SetTitle = KeybindFrame.SetTitle
        Keybind.SetDesc = KeybindFrame.SetDesc
        Keybind.Visible = KeybindFrame.Visible
        Keybind.Elements = KeybindFrame
        local KeybindDisplayLabel =
            New(
            "TextLabel",
            {
                FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontWeight.Regular,
                    Enum.FontStyle.Normal
                ),
                Text = Config.Default,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Center,
                Size = UDim2.new(0, 0, 0, 14),
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                ThemeTag = {
                    TextColor3 = "Text"
                }
            }
        )
        local KeybindDisplayFrame =
            New(
            "TextButton",
            {
                Size = UDim2.fromOffset(0, 30),
                Position = UDim2.new(1, -10, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 0.9,
                Parent = KeybindFrame.Frame,
                AutomaticSize = Enum.AutomaticSize.X,
                ThemeTag = {
                    BackgroundColor3 = "Keybind"
                }
            },
            {
                New(
                    "UICorner",
                    {
                        CornerRadius = UDim.new(0, 5)
                    }
                ),
                New(
                    "UIPadding",
                    {
                        PaddingLeft = UDim.new(0, 8),
                        PaddingRight = UDim.new(0, 8)
                    }
                ),
                New(
                    "UIStroke",
                    {
                        Transparency = 0.5,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        ThemeTag = {
                            Color = "InElementBorder"
                        }
                    }
                ),
                KeybindDisplayLabel
            }
        )
        function Keybind:GetState()
            if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then
                return false
            end
            if Keybind.Mode == "Always" then
                return true
            elseif Keybind.Mode == "Hold" then
                if Keybind.Value == "None" then
                    return false
                end
                local Key = Keybind.Value
                if Key == "MouseLeft" or Key == "MouseRight" then
                    return Key == "MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or
                        Key == "MouseRight" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                else
                    return UserInputService:IsKeyDown(Enum.KeyCode[Keybind.Value])
                end
            else
                return Keybind.Toggled
            end
        end
        function Keybind:SetValue(Key, Mode)
            Key = Key or Keybind.Key
            Mode = Mode or Keybind.Mode
            KeybindDisplayLabel.Text = Key
            Keybind.Value = Key
            Keybind.Mode = Mode
        end
        function Keybind:OnClick(Callback)
            Keybind.Clicked = Callback
        end
        function Keybind:OnChanged(Callback)
            Keybind.Changed = Callback
            Callback(Keybind.Value)
        end
        function Keybind:DoClick()
            Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
            Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
        end
        function Keybind:Destroy()
            KeybindFrame:Destroy()
            Library.Options[Idx] = nil
        end
        Creator.AddSignal(
            KeybindDisplayFrame.InputBegan,
            function(Input)
                if
                    Input.UserInputType == Enum.UserInputType.MouseButton1 or
                        Input.UserInputType == Enum.UserInputType.Touch
                 then
                    Picking = true
                    KeybindDisplayLabel.Text = "..."
                    wait(0.2)
                    local Event
                    Event =
                        UserInputService.InputBegan:Connect(
                        function(Input)
                            local Key
                            if Input.UserInputType == Enum.UserInputType.Keyboard then
                                Key = Input.KeyCode.Name
                            elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Key = "MouseLeft"
                            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                                Key = "MouseRight"
                            end
                            local EndedEvent
                            EndedEvent =
                                UserInputService.InputEnded:Connect(
                                function(Input)
                                    local match = false
                                    if
                                        Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode and Key and
                                            Input.KeyCode.Name == Key
                                     then
                                        match = true
                                    elseif Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                        match = true
                                    elseif
                                        Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
                                     then
                                        match = true
                                    end
                                    if match then
                                        Picking = false
                                        KeybindDisplayLabel.Text = Key
                                        Keybind.Value = Key
                                        Library:SafeCallback(
                                            Keybind.ChangedCallback,
                                            Input.KeyCode or Input.UserInputType
                                        )
                                        Library:SafeCallback(Keybind.Changed, Input.KeyCode or Input.UserInputType)
                                        Event:Disconnect()
                                        EndedEvent:Disconnect()
                                    end
                                end
                            )
                        end
                    )
                end
            end
        )
        Creator.AddSignal(
            UserInputService.InputBegan,
            function(Input)
                if not Picking and not UserInputService:GetFocusedTextBox() then
                    if Keybind.Mode == "Toggle" then
                        local Key = Keybind.Value
                        if Key == "MouseLeft" or Key == "MouseRight" then
                            if
                                (Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1) or
                                    (Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2)
                             then
                                Keybind.Toggled = not Keybind.Toggled
                                Keybind:DoClick()
                            end
                        elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                            if Input.KeyCode and Input.KeyCode.Name == Key then
                                Keybind.Toggled = not Keybind.Toggled
                                Keybind:DoClick()
                            end
                        end
                    elseif Keybind.Mode == "Hold" then
                        local Key = Keybind.Value
                        if Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Keybind.Internal.Pressed = true
                            Keybind.Toggled = false
                        elseif Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                            Keybind.Internal.Pressed = true
                            Keybind.Toggled = false
                        elseif
                            Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode and
                                Input.KeyCode.Name == Key
                         then
                            Keybind.Internal.Pressed = true
                            Keybind.Toggled = true
                            Keybind:DoClick()
                        end
                    end
                end
            end
        )
        Creator.AddSignal(
            UserInputService.InputEnded,
            function(Input)
                if Keybind.Mode == "Hold" then
                    local Key = Keybind.Value
                    if Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Keybind.Internal.Pressed = false
                        if Keybind.Toggled then
                            Keybind.Toggled = false
                            Keybind:DoClick()
                        end
                    elseif Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                        Keybind.Internal.Pressed = false
                        if Keybind.Toggled then
                            Keybind.Toggled = false
                            Keybind:DoClick()
                        end
                    elseif
                        Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode and Key and
                            Input.KeyCode.Name == Key
                     then
                        Keybind.Internal.Pressed = false
                        if Keybind.Toggled then
                            Keybind.Toggled = false
                            Keybind:DoClick()
                        end
                    end
                end
            end
        )
        Library.Options[Idx] = Keybind
        return Keybind
    end
    return Element
end)()
ElementsTable.Colorpicker =
    (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Colorpicker"
    local New = Creator.New

    function Element:New(Idx, Config)
        assert(Config.Title, "Colorpicker - Missing Title")
        local Colorpicker = {
            Value = Config.Default or {H = 0, S = 1, V = 1},
            Transparency = Config.Transparency or 0,
            Callback = Config.Callback or function()
                end,
            Type = "Colorpicker"
        }

        local PickerFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        Colorpicker.Elements = PickerFrame
        Colorpicker.SetTitle = PickerFrame.SetTitle
        Colorpicker.SetDesc = PickerFrame.SetDesc
        Colorpicker.Visible = PickerFrame.Visible

        local Preview =
            New(
            "Frame",
            {
                Size = UDim2.fromOffset(26, 20),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundTransparency = 0.9,
                Parent = PickerFrame.Frame,
                ThemeTag = {BackgroundColor3 = "DropdownHolder"}
            },
            {
                New("UICorner", {CornerRadius = UDim.new(0, 4)})
            }
        )

        local PreviewColor =
            New(
            "Frame",
            {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 0,
                Parent = Preview
            },
            {
                New("UICorner", {CornerRadius = UDim.new(0, 4)})
            }
        )

        local Popup =
            New(
            "Frame",
            {
                Size = UDim2.fromOffset(300, 220),
                Visible = false,
                Parent = Library.GUI,
                BackgroundTransparency = 1
            },
            {
                New("UICorner", {CornerRadius = UDim.new(0, 8)})
            }
        )

        local HueBar =
            New(
            "Frame",
            {
                Size = UDim2.new(0, 24, 1, -40),
                Position = UDim2.fromOffset(8, 8),
                BackgroundTransparency = 0,
                Parent = Popup,
                ThemeTag = {BackgroundColor3 = "DropdownHolder"}
            },
            {
                New("UICorner", {CornerRadius = UDim.new(0, 6)})
            }
        )

        local SV =
            New(
            "Frame",
            {
                Size = UDim2.new(1, -48, 1, -40),
                Position = UDim2.fromOffset(40, 8),
                BackgroundTransparency = 0,
                Parent = Popup,
                ThemeTag = {BackgroundColor3 = "DropdownHolder"}
            },
            {
                New("UICorner", {CornerRadius = UDim.new(0, 6)})
            }
        )

        local AlphaBar =
            New(
            "Frame",
            {
                Size = UDim2.new(1, -16, 0, 16),
                Position = UDim2.fromOffset(8, Popup.Size.Y.Offset - 24),
                BackgroundTransparency = 0,
                Parent = Popup,
                ThemeTag = {BackgroundColor3 = "DropdownHolder"}
            },
            {
                New("UICorner", {CornerRadius = UDim.new(0, 6)})
            }
        )

        local function hsvToColor(h, s, v)
            return Color3.fromHSV(h % 1, math.clamp(s, 0, 1), math.clamp(v, 0, 1))
        end

        local function UpdatePreview()
            local c = hsvToColor(Colorpicker.Value.H, Colorpicker.Value.S, Colorpicker.Value.V)
            PreviewColor.BackgroundColor3 = c
            PreviewColor.BackgroundTransparency = math.clamp(Colorpicker.Transparency, 0, 1)
        end

        local Picking = false

        Creator.AddSignal(
            Preview.InputBegan,
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1 or
                        input.UserInputType == Enum.UserInputType.Touch
                 then
                    Popup.Position = UDim2.new(0.5, -150, 0.5, -110)
                    Popup.Visible = true
                    Picking = true
                end
            end
        )

        Creator.AddSignal(
            UserInputService.InputBegan,
            function(input, processed)
                if processed then
                    return
                end
                if input.UserInputType == Enum.UserInputType.MouseButton1 and Popup.Visible then
                    local mousePos = Vector2.new(input.Position.X, input.Position.Y)
                    if
                        not (mousePos.X >= Popup.AbsolutePosition.X and
                            mousePos.X <= Popup.AbsolutePosition.X + Popup.AbsoluteSize.X and
                            mousePos.Y >= Popup.AbsolutePosition.Y and
                            mousePos.Y <= Popup.AbsolutePosition.Y + Popup.AbsoluteSize.Y)
                     then
                        Popup.Visible = false
                        Picking = false
                    end
                end
            end
        )

        local function SetColorFromHSV(h, s, v)
            Colorpicker.Value.H = h
            Colorpicker.Value.S = s
            Colorpicker.Value.V = v
            UpdatePreview()
            Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value, Colorpicker.Transparency)
        end

        local draggingHue = false
        local draggingSV = false
        local draggingAlpha = false

        Creator.AddSignal(
            HueBar.InputBegan,
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1 or
                        input.UserInputType == Enum.UserInputType.Touch
                 then
                    draggingHue = true
                end
            end
        )
        Creator.AddSignal(
            HueBar.InputEnded,
            function(input)
                draggingHue = false
            end
        )

        Creator.AddSignal(
            SV.InputBegan,
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1 or
                        input.UserInputType == Enum.UserInputType.Touch
                 then
                    draggingSV = true
                end
            end
        )
        Creator.AddSignal(
            SV.InputEnded,
            function(input)
                draggingSV = false
            end
        )

        Creator.AddSignal(
            AlphaBar.InputBegan,
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1 or
                        input.UserInputType == Enum.UserInputType.Touch
                 then
                    draggingAlpha = true
                end
            end
        )
        Creator.AddSignal(
            AlphaBar.InputEnded,
            function(input)
                draggingAlpha = false
            end
        )

        Creator.AddSignal(
            UserInputService.InputChanged,
            function(input)
                if
                    input.UserInputType ~= Enum.UserInputType.MouseMovement and
                        input.UserInputType ~= Enum.UserInputType.Touch
                 then
                    return
                end
                if draggingHue then
                    local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                    local h = 1 - y
                    SetColorFromHSV(h, Colorpicker.Value.S, Colorpicker.Value.V)
                elseif draggingSV then
                    local localPos = Vector2.new(input.Position.X, input.Position.Y) - SV.AbsolutePosition
                    local s = math.clamp(localPos.X / SV.AbsoluteSize.X, 0, 1)
                    local v = 1 - math.clamp(localPos.Y / SV.AbsoluteSize.Y, 0, 1)
                    SetColorFromHSV(Colorpicker.Value.H, s, v)
                elseif draggingAlpha then
                    local x =
                        math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / AlphaBar.AbsoluteSize.X, 0, 1)
                    Colorpicker.Transparency = 1 - x
                    UpdatePreview()
                    Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value, Colorpicker.Transparency)
                end
            end
        )

        UpdatePreview()

        function Colorpicker:SetValue(HSV, Transparency)
            if type(HSV) == "table" then
                Colorpicker.Value = {H = HSV.H or HSV[1] or 0, S = HSV.S or HSV[2] or 1, V = HSV.V or HSV[3] or 1}
            end
            Colorpicker.Transparency = Transparency or Colorpicker.Transparency
            UpdatePreview()
            Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value, Colorpicker.Transparency)
        end

        function Colorpicker:OnChanged(Func)
            Colorpicker.Changed = Func
            Func(Colorpicker.Value, Colorpicker.Transparency)
        end

        function Colorpicker:Destroy()
            PickerFrame:Destroy()
            Library.Options[Idx] = nil
            if Popup then
                Popup:Destroy()
            end
        end

        Library.Options[Idx] = Colorpicker
        return Colorpicker
    end

    return Element
end)()

ElementsTable.Input =
    (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Input"
    local New = Creator.New

    function Element:New(Idx, Config)
        assert(Config.Title, "Input - Missing Title")
        local Input = {
            Value = Config.Default or "",
            Callback = Config.Callback or function()
                end,
            Type = "Input"
        }
        local InputFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        Input.Elements = InputFrame
        Input.SetTitle = InputFrame.SetTitle
        Input.SetDesc = InputFrame.SetDesc
        Input.Visible = InputFrame.Visible

        local Textbox = Components.Textbox(InputFrame.Frame, Config.Acrylic)
        Textbox.Input.Text = Input.Value

        Creator.AddSignal(
            Textbox.Input.Changed,
            function()
                Input.Value = Textbox.Input.Text
                Library:SafeCallback(Input.Callback, Input.Value)
            end
        )

        function Input:SetValue(Text)
            Text = Text or ""
            Input.Value = Text
            Textbox.Input.Text = Text
        end

        function Input:OnChanged(Func)
            Input.Changed = Func
            Func(Input.Value)
        end

        function Input:Destroy()
            InputFrame:Destroy()
            Library.Options[Idx] = nil
        end

        Library.Options[Idx] = Input
        return Input
    end

    return Element
end)()

local Icons = {}
function Library:GetIcon(Name)
    return Icons[Name] or Name or ""
end

local SaveManager = {}
do
    SaveManager.Folder = "fluentplus_configs"
    SaveManager.Options = {}
    SaveManager.Library = Library

    function SaveManager:SetLibrary(library)
        self.Library = library
        self.Options = library.Options
    end

    function SaveManager:Save(name)
        local out = {}
        for k, v in pairs(self.Library.Options) do
            if v and v.Type then
                if v.Type == "Toggle" then
                    out[k] = {Type = "Toggle", Value = v.Value}
                elseif v.Type == "Slider" then
                    out[k] = {Type = "Slider", Value = v.Value}
                elseif v.Type == "Dropdown" then
                    out[k] = {Type = "Dropdown", Value = v.Value}
                elseif v.Type == "Colorpicker" then
                    out[k] = {Type = "Colorpicker", Value = v.Value, Transparency = v.Transparency}
                elseif v.Type == "Keybind" then
                    out[k] = {Type = "Keybind", Value = v.Value, Mode = v.Mode}
                elseif v.Type == "Input" then
                    out[k] = {Type = "Input", Value = v.Value}
                end
            end
        end
        local ok, json =
            pcall(
            function()
                return httpService:JSONEncode(out)
            end
        )
        if ok then
            pcall(
                function()
                    writefile(self.Folder .. "/" .. name .. ".json", json)
                end
            )
        end
    end

    function SaveManager:Load(name)
        pcall(
            function()
                if isfile(self.Folder .. "/" .. name .. ".json") then
                    local content = readfile(self.Folder .. "/" .. name .. ".json")
                    local data = httpService:JSONDecode(content)
                    for k, v in pairs(data) do
                        local opt = self.Library.Options[k]
                        if opt then
                            if v.Type == "Toggle" and opt.SetValue then
                                opt:SetValue(v.Value)
                            end
                            if v.Type == "Slider" and opt.SetValue then
                                opt:SetValue(v.Value)
                            end
                            if v.Type == "Dropdown" and opt.SetValue then
                                opt:SetValue(v.Value)
                            end
                            if v.Type == "Colorpicker" and opt.SetValue then
                                opt:SetValue(v.Value, v.Transparency)
                            end
                            if v.Type == "Keybind" and opt.SetValue then
                                opt:SetValue(v.Value, v.Mode)
                            end
                            if v.Type == "Input" and opt.SetValue then
                                opt:SetValue(v.Value)
                            end
                        end
                    end
                end
            end
        )
    end
end

Library.SaveManager = SaveManager

local InterfaceManager = {}
do
    InterfaceManager.Settings = {Theme = "Dark", WindowTransparency = 0.9}
    function InterfaceManager:SetLibrary(library)
        self.Library = library
    end
    function InterfaceManager:SetTheme(name)
        if name == "Dark" then
            self.Settings.Theme = "Dark"
            Creator.Theme = "Dark"
            Creator.UpdateTheme()
        end
    end
    function InterfaceManager:SetWindowTransparency(v)
        self.Settings.WindowTransparency = v
        Library:ToggleTransparency(v < 1)
    end
end
Library.InterfaceManager = InterfaceManager

Library.Elements = {}
for k, v in pairs(ElementsTable) do
    Library.Elements[k] = v
end

function Library:CreateWindow(Config)
    Config = Config or {}
    local Parent = gethui and gethui() or LocalPlayer:WaitForChild("PlayerGui")
    local WindowSize = Config.Size or UDim2.fromOffset(900, 600)
    local TabWidth = Config.TabWidth or 180
    local TabLogo = Config.TabLogo
    local Window =
        Components.Window(
        {
            Title = Config.Title or "Window",
            SubTitle = Config.SubTitle,
            Icon = nil,
            Size = WindowSize,
            Parent = Parent,
            TabWidth = TabWidth
        }
    )
    if TabLogo and type(TabLogo) == "string" and TabLogo ~= "" then
        Window.TabWidth = math.floor(TabWidth * 2.5)
        local Logo =
            Creator.New(
            "ImageLabel",
            {
                Size = UDim2.fromOffset(Window.TabWidth, 56),
                Position = UDim2.new(0, 12, 0, 12),
                BackgroundTransparency = 1,
                Image = "",
                Parent = Window.Root
            }
        )
        pcall(
            function()
                if TabLogo ~= "" then
                    Logo.Image = TabLogo
                end
            end
        )
    end
    ProtectGui(Library.GUI)
    table.insert(self.Windows, Window)
    self.Window = Window
    return Window
end

function Library:SetTheme(Value)
    if Value == "Dark" then
        Creator.Theme = "Dark"
        Creator.UpdateTheme()
    end
end

function Library:Destroy()
    for _, win in ipairs(self.Windows) do
        pcall(
            function()
                win:Destroy()
            end
        )
    end
    self.GUI:Destroy()
    self.Unloaded = true
end

do
    local pressedKeys = {}
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local name = input.KeyCode.Name
            pressedKeys[name] = true
            for _, opt in pairs(Library.Options) do
                if opt and opt.Type == "Keybind" and not UserInputService:GetFocusedTextBox() then
                    local key = opt.Value
                    if key == name then
                        if opt.Mode == "Toggle" then
                            opt.Toggled = not opt.Toggled
                            opt:DoClick()
                        elseif opt.Mode == "Hold" then
                            opt.Internal.Pressed = true
                            opt.Toggled = true
                            opt:DoClick()
                        elseif opt.Mode == "Always" then
                        end
                    end
                end
            end
        elseif
            input.UserInputType == Enum.UserInputType.MouseButton1 or
                input.UserInputType == Enum.UserInputType.MouseButton2
         then
            local mouseKey = input.UserInputType == Enum.UserInputType.MouseButton1 and "MouseLeft" or "MouseRight"
            pressedKeys[mouseKey] = true
            for _, opt in pairs(Library.Options) do
                if opt and opt.Type == "Keybind" and not UserInputService:GetFocusedTextBox() then
                    local key = opt.Value
                    if key == mouseKey then
                        if opt.Mode == "Toggle" then
                            opt.Toggled = not opt.Toggled
                            opt:DoClick()
                        elseif opt.Mode == "Hold" then
                            opt.Internal.Pressed = true
                            opt.Toggled = true
                            opt:DoClick()
                        end
                    end
                end
            end
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local name = input.KeyCode and input.KeyCode.Name
            if name then
                pressedKeys[name] = nil
                for _, opt in pairs(Library.Options) do
                    if opt and opt.Type == "Keybind" and opt.Mode == "Hold" then
                        if opt.Value == name then
                            opt.Internal.Pressed = false
                            if opt.Toggled then
                                opt.Toggled = false
                                opt:DoClick()
                            end
                        end
                    end
                end
            end
        elseif
            input.UserInputType == Enum.UserInputType.MouseButton1 or
                input.UserInputType == Enum.UserInputType.MouseButton2
         then
            local mouseKey = input.UserInputType == Enum.UserInputType.MouseButton1 and "MouseLeft" or "MouseRight"
            pressedKeys[mouseKey] = nil
            for _, opt in pairs(Library.Options) do
                if opt and opt.Type == "Keybind" and opt.Mode == "Hold" then
                    if opt.Value == mouseKey then
                        opt.Internal.Pressed = false
                        if opt.Toggled then
                            opt.Toggled = false
                            opt:DoClick()
                        end
                    end
                end
            end
        end
    end

    Creator.AddSignal(UserInputService.InputBegan, onInputBegan)
    Creator.AddSignal(UserInputService.InputEnded, onInputEnded)
end

Library.Creator = Creator
Library.Components = Components
Library.ElementsTable = ElementsTable

return Library
