repeat task.wait() until game:IsLoaded()

local TCS = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local RStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local isLegacy = TCS.ChatVersion == Enum.ChatVersion.LegacyChatService
local ChatBar = CoreGui:FindFirstChild("TextBoxContainer", true) or PlayerGui:FindFirstChild("Chat"):FindFirstChild("ChatBar", true)
ChatBar = ChatBar:FindFirstChild("TextBox") or ChatBar

local Keywords = {
    --phrases
    {"i",  "і"},
    {"e",  "е"},
    {"g",  "g"},
    {"c",  "с"},
    {"o",  "о"},
    {"p",  "р"},
    {"s",  "ѕ"},
    {"u",  "u"},
    {"I",  "Ӏ"},
    {"E",  "Е"},
    {"G", "ꓖ"},
    {"C",  "С"},
    {"O", "О"},
    {"P",  "Р"},
    {"S",  "Ѕ"},
    {"U",  "𐓎"},
    {"a", "а"},
    {"x", "х"},
    {"y", "у"},
    {"A", "А"},
    {"H", "Н"},
    {"K", "К"},
    {"T", "Т"},
    {"X", "Х"},
    {"I", "Ι"},
    {"h", "һ"},
    {" ", " "}, -- Don't delete
}

local Gen = function(Message)
    for _, info in Keywords do
        local real = info[1]
        local bypass = info[2]
        Message = Message:gsub(real, bypass)
    end
    return Message
end

local Chat = function(Message)
    if isLegacy then
        local ChatRemote = RStorage:FindFirstChild("SayMessageRequest", true)
        ChatRemote:FireServer(Message, "All")
    else
        local Channel = TCS.TextChannels.RBXGeneral
        Channel:SendAsync(Message)
    end
end

local Fake = function(Message)
    if isLegacy then
        Players:Chat(Message)
    else
        local Channel = TCS.TextChannels.RBXGeneral
        Channel:SendAsync(("!Frendly Message!"):format(Message))
        -- ^^^ it's too fucking annoying
    end
end

local chars = {}
for i=97,122 do chars[#chars+1]=string.char(i) end
for i=65,90 do chars[#chars+1]=string.char(i) end

local RNG = function(length)
    local str = ""
    for i = 1, length do
        str = str .. chars[math.random(#chars)]
    end
    return str
end

local Connection = Instance.new("BindableFunction")

for _, c in getconnections(ChatBar.FocusLost) do
    c:Disconnect()
end

ChatBar.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        Connection:Invoke(ChatBar.Text)
        ChatBar.Text = ""
    end
end)

local NotifyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/PeaPattern/notif-lib/main/main.lua"))()

NotifyModule:Notify("walter23132121's Chat Bypasser", 8)
wait(1)
NotifyModule:Notify("IF You Found A Bug Or A Problem Please Send Me A DM Explaining The Bug (walter23132121)", 8)
wait(3)
NotifyModule:Notify("Enjoy!", 8)

local bypassEnabled = true

UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE then return end
    if Input.KeyCode == getgenv().KeyBind then
        bypassEnabled = not bypassEnabled
        NotifyModule:Notify("Bypass " .. (bypassEnabled and "enabled" or "disabled"), 1)
    end
end)

Connection.OnInvoke = function(Message)
    if bypassEnabled then
        Message = Gen(Message)
        Message = "(ﾒ́́́́́́́́́ﾒ́́́́́́́́́ﾒ́́́́́́́́́ﾒ́́́́́́́́́ﾒ́́́́́́́́́ﾒ́́́́́́́́́ﾒ́́́́́́́́́) " .. Message
    end
    Chat(Message)
end