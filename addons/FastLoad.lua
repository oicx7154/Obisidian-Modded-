return function(Tab, Library)
    task.spawn(function()
        local JsonUrl = "https://raw.githubusercontent.com/luojunjun43-del/1/refs/heads/main/QuickGame.json"
        local function GetService(Name)
            local Service = game:GetService(Name)
            if type(cloneref) == "function" then
                local Success, Cloned = pcall(cloneref, Service)
                if Success and Cloned then
                    return Cloned
                end
            end
            return Service
        end
        local function Notify(Text)
            if Library then
                Library:Notify({
                    Title = "快速跳转",
                    Description = tostring(Text),
                    Time = 5,
                })
            else
                warn("[快速跳转]", Text)
            end
        end
        if not Tab or not Tab.ft then
            Notify("未找到 Tab.ft")
            return
        end
        if not Library then
            warn("[快速跳转] 未传入 Library")
            return
        end
        local HttpService = GetService("HttpService")
        local TeleportService = GetService("TeleportService")
        local LocalPlayer = GetService("Players").LocalPlayer
        local Request = type(request) == "function" and request
            or type(http_request) == "function" and http_request
            or type(syn) == "table" and type(syn.request) == "function" and syn.request
        if not Request then
            Notify("当前环境不支持请求函数")
            return
        end
        local Success, Response = pcall(Request, {
            Url = JsonUrl,
            Method = "GET",
        })
        if not Success or type(Response) ~= "table" then
            Notify("JSON 请求失败：" .. tostring(Response))
            return
        end
        local StatusCode = tonumber(Response.StatusCode)
        if StatusCode and (StatusCode < 200 or StatusCode >= 300) then
            Notify("JSON 请求失败，HTTP 状态码：" .. StatusCode)
            return
        end
        if type(Response.Body) ~= "string" or Response.Body == "" then
            Notify("JSON 内容为空")
            return
        end
        local Decoded, Data = pcall(function()
            return HttpService:JSONDecode(Response.Body)
        end)
        if not Decoded or type(Data) ~= "table" then
            Notify("JSON 解析失败：" .. tostring(Data))
            return
        end
        local AddedCount = 0
        for Index, Entry in ipairs(Data) do
            if type(Entry) ~= "table" then
                warn("[快速跳转] 第 " .. Index .. " 项不是对象")
                continue
            end
            local Name = Entry.Name
            local PlaceId = tonumber(Entry.PlaceId)
            local GameId = tonumber(Entry.GameId)
            if type(Name) ~= "string" or Name == "" then
                warn("[快速跳转] 第 " .. Index .. " 项缺少 Name")
                continue
            end
            if not PlaceId or PlaceId <= 0 or PlaceId % 1 ~= 0 then
                warn("[快速跳转] " .. Name .. " 的 PlaceId 无效")
                continue
            end
            if not GameId or GameId <= 0 or GameId % 1 ~= 0 then
                warn("[快速跳转] " .. Name .. " 的 GameId 无效")
                continue
            end
            AddedCount += 1
            local Group
            if AddedCount % 2 == 1 then
                Group = Tab.ft:AddLeftGroupbox(Name)
            else
                Group = Tab.ft:AddRightGroupbox(Name)
            end
                print(
                    "[快速跳转图片]",
                    "名称:", Name,
                    "GameId:", GameId,
                    "PlaceId:", PlaceId
                )
            local ImageOk, ImageError = pcall(function()
                Group:AddImage("游戏图标" .. Index, {
                    Image = "rbxassetid://0",
                    GameIcon = true,
                    GameId = GameId,
                    Height = 180,
                    ScaleType = Enum.ScaleType.Fit,
                    Transparency = 0,
                    Color = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                })
            end)
                print(
    "[AddImage]",
    "标识:", Idx,
    "GameIcon:", GameIcon,
    "GameId:", GameId,
    "实际地址:", ImageLabel.Image,
    "透明度:", ImageLabel.ImageTransparency,
    "尺寸:", ImageLabel.AbsoluteSize
)
            if not ImageOk then
                warn("[快速跳转] " .. Name .. " 的图片创建失败：", ImageError)
            end
            Group:AddButton("快速跳转" .. Index, {
                Text = "快速跳转",
                Func = function()
                    local TeleportOk, TeleportError = pcall(function()
                        TeleportService:Teleport(PlaceId, LocalPlayer)
                    end)
                    if not TeleportOk then
                        Notify("传送请求失败：" .. tostring(TeleportError))
                    end
                end,
            })
        end
    end)
end
