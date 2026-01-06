local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UIS = game:GetService("UserInputService") local player = Players.LocalPlayer local flying = false local SPEED = 70 local ACCEL = 0.18 local MIN_SPEED = 20 local MAX_SPEED = 500 local bv, bg, conn, noclipConn local currentVelocity = Vector3.zero local savedAutoRotate local
function
  getChar() local char = player.Character or player.CharacterAdded:Wait() local hum = char:WaitForChild("Humanoid") local hrp = char:WaitForChild("HumanoidRootPart") return char, hum, hrp
end
local
function
  startNoClip(char) noclipConn = RunService.Stepped:Connect(
  function
    ()
    for
    _, v in ipairs(char:GetDescendants())
    do
      
      if
      v:IsA("BasePart")
      then
        v.CanCollide = false
      end
      
    end
    
  end
  )
end
local
function
  stopNoClip(char)
  if
  noclipConn
  then
    noclipConn:Disconnect()
  end
  
  for
  _, v in ipairs(char:GetDescendants())
  do
    
    if
    v:IsA("BasePart")
    then
      v.CanCollide = true
    end
    
  end
  
end
local
function
  startFly()
  if
  flying
  then
    return
  end
  flying = true local char, hum, hrp = getChar() savedAutoRotate = hum.AutoRotate hum.AutoRotate = false hum:ChangeState(Enum.HumanoidStateType.Physics) startNoClip(char) bv = Instance.new("BodyVelocity", hrp) bv.MaxForce = Vector3.new(1e9,1e9,1e9) bg = Instance.new("BodyGyro", hrp) bg.MaxTorque = Vector3.new(1e9,1e9,1e9) bg.P = 9e4 conn = RunService.RenderStepped:Connect(
  function
    () local cam = workspace.CurrentCamera local move = hum.MoveDirection local f = cam.CFrame.LookVector local r = cam.CFrame.RightVector local dir = f * move:Dot(f) + r * move:Dot(r)
    if
    dir.Magnitude > 0
    then
      dir = dir.Unit
    end
    currentVelocity = currentVelocity:Lerp(dir * SPEED, ACCEL) bv.Velocity = currentVelocity bg.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + f, Vector3.new(0,1,0))
  end
  )
end
local
function
  stopFly()
  if
  not flying
  then
    return
  end
  flying = false
  if
  conn
  then
    conn:Disconnect()
  end
  
  if
  bv
  then
    bv:Destroy()
  end
  
  if
  bg
  then
    bg:Destroy()
  end
  local char, hum = getChar() stopNoClip(char) hum.AutoRotate = savedAutoRotate ~= nil and savedAutoRotate or true hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end
local gui = Instance.new("ScreenGui", player.PlayerGui) gui.Name = "FlyGUI" gui.IgnoreGuiInset = true gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling gui.ResetOnSpawn = false local frame = Instance.new("Frame", gui) frame.Size = UDim2.fromScale(0.55,0.32) frame.Position = UDim2.fromScale(0.5,0.5) frame.AnchorPoint = Vector2.new(0.5,0.5) frame.BackgroundColor3 = Color3.fromRGB(15,25,55) frame.BorderSizePixel = 0 frame.ZIndex = 20 Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18) local layout = Instance.new("UIListLayout", frame) layout.Padding = UDim.new(0,10) layout.HorizontalAlignment = Enum.HorizontalAlignment.Center Instance.new("UIPadding", frame).PaddingTop = UDim.new(0,12) local header = Instance.new("TextLabel", frame) header.Size = UDim2.new(1,-20,0,32) header.BackgroundTransparency = 1 header.Text = "FLY V1.0 — by DOFY" header.Font = Enum.Font.GothamBold header.TextSize = 16 header.TextColor3 = Color3.fromRGB(220,230,255) local toggle = Instance.new("TextButton", frame) toggle.Size = UDim2.new(1,-20,0,40) toggle.Text = "FLY : OFF" toggle.Font = Enum.Font.GothamBold toggle.TextSize = 14 toggle.BackgroundColor3 = Color3.fromRGB(30,55,120) toggle.TextColor3 = Color3.new(1,1,1) Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,14) local hideBtn = Instance.new("TextButton", frame) hideBtn.Size = UDim2.new(1,-20,0,34) hideBtn.Text = "HIDE MENU" hideBtn.Font = Enum.Font.GothamBold hideBtn.TextSize = 13 hideBtn.BackgroundColor3 = Color3.fromRGB(18,30,65) hideBtn.TextColor3 = Color3.new(1,1,1) Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,12) local iconBtn = Instance.new("ImageButton", gui) iconBtn.Size = UDim2.fromScale(0.20,0.20) iconBtn.Position = UDim2.fromScale(0.9,0.5) iconBtn.AnchorPoint = Vector2.new(0.5,0.5) iconBtn.BackgroundTransparency = 1 iconBtn.Image = "rbxassetid://101689883102462" iconBtn.Visible = false iconBtn.ZIndex = 50 Instance.new("UIAspectRatioConstraint", iconBtn).AspectRatio = 1
do
  local dragging, startPos, startInput iconBtn.InputBegan:Connect(
  function
    (i)
    if
    i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
    then
      dragging = true startInput = i.Position startPos = iconBtn.Position
    end
    
  end
  ) UIS.InputChanged:Connect(
  function
    (i)
    if
    dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch)
    then
      local delta = i.Position - startInput iconBtn.Position = UDim2.new( startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y )
    end
    
  end
  ) UIS.InputEnded:Connect(
  function
    (i)
    if
    i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
    then
      dragging = false
    end
    
  end
  )
end
local speedRow = Instance.new("Frame", frame) speedRow.Size = UDim2.new(1,-20,0,40) speedRow.BackgroundTransparency = 1 local rowLayout = Instance.new("UIListLayout", speedRow) rowLayout.FillDirection = Enum.FillDirection.Horizontal rowLayout.Padding = UDim.new(0,10) rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center local minus = Instance.new("TextButton", speedRow) minus.Size = UDim2.new(0.25,0,1,0) minus.Text = "−" minus.Font = Enum.Font.GothamBold minus.TextSize = 20 minus.BackgroundColor3 = Color3.fromRGB(20,40,90) minus.TextColor3 = Color3.new(1,1,1) Instance.new("UICorner", minus).CornerRadius = UDim.new(0,12) local speedLabel = Instance.new("TextLabel", speedRow) speedLabel.Size = UDim2.new(0.4,0,1,0) speedLabel.BackgroundTransparency = 1 speedLabel.Text = "Speed: "..SPEED speedLabel.Font = Enum.Font.Gotham speedLabel.TextSize = 14 speedLabel.TextColor3 = Color3.fromRGB(200,215,255) local plus = Instance.new("TextButton", speedRow) plus.Size = UDim2.new(0.25,0,1,0) plus.Text = "+" plus.Font = Enum.Font.GothamBold plus.TextSize = 20 plus.BackgroundColor3 = Color3.fromRGB(20,40,90) plus.TextColor3 = Color3.new(1,1,1) Instance.new("UICorner", plus).CornerRadius = UDim.new(0,12) toggle.MouseButton1Click:Connect(
function
  ()
  if
  flying
  then
    toggle.Text = "FLY : OFF" stopFly()
  else
    toggle.Text = "FLY : ON" startFly()
  end
  
end
) hideBtn.MouseButton1Click:Connect(
function
  () frame.Visible = false iconBtn.Visible = true
end
) iconBtn.MouseButton1Click:Connect(
function
  () frame.Visible = true iconBtn.Visible = false
end
) plus.MouseButton1Click:Connect(
function
  () SPEED = math.clamp(SPEED + 10, MIN_SPEED, MAX_SPEED) speedLabel.Text = "Speed: "..SPEED
end
) minus.MouseButton1Click:Connect(
function
  () SPEED = math.clamp(SPEED - 10, MIN_SPEED, MAX_SPEED) speedLabel.Text = "Speed: "..SPEED
end
)
