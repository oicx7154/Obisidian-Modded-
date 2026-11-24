local jsonUrl = "https://raw.githubusercontent.com/luojunjun43-del/1/refs/heads/main/QuickGame.json"

return function(Tab, Library)
    local function getService(name)
        local service = game:GetService(name)
        if type(cloneref) == "function" then
            local ok, cloned = pcall(cloneref, service)
            if ok and cloned then
                return cloned
            end
        end
        return service
    end
    local HttpService = getService("HttpService")
    local TeleportService = getService("TeleportService")
    local Players = getService("Players")
    local LocalPlayer = Players.LocalPlayer
    assert(Tab and Tab.ft, "未找到Tab")
    assert(Library, "未传入 Library")
    local ok, response = pcall(function()
        return request({
            Url = jsonUrl,
            Method = "GET",
        })
    end)
    if not ok or not response or type(response.Body) ~= "string" then
        warn("[快速跳转] JSON 请求失败：", response)
        return
    end
    if response.StatusCode and (response.StatusCode < 200 or response.StatusCode >= 300) then
        warn("[快速跳转] HTTP 状态码：", response.StatusCode)
        return
    end
    local decoded, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    if not decoded or type(data) ~= "table" then
        warn("[快速跳转] JSON 解析失败：", data)
        return
    end
    local addedCount = 0
    for index, entry in ipairs(data) do
        if type(entry) ~= "table" then
            warn("[快速跳转] 第 " .. index .. " 项不是对象")
            continue
        end
        local name = entry.Name
        local placeId = tonumber(entry.PlaceId)
        local gameId = tonumber(entry.GameId)
        if type(name) ~= "string" or name == "" then
            warn("[快速跳转] 第 " .. index .. " 项缺少 Name")
            continue
        end
        if not placeId or placeId <= 0 or placeId % 1 ~= 0 then
            warn("[快速跳转] " .. name .. " 的 PlaceId 无效")
            continue
        end
        if not gameId or gameId <= 0 or gameId % 1 ~= 0 then
            warn("[快速跳转] " .. name .. " 的 GameId 无效")
            continue
        end
        addedCount += 1
        local group
        if addedCount % 2 == 1 then
            group = Tab.ft:AddLeftGroupbox(name)
        else
            group = Tab.ft:AddRightGroupbox(name)
        end
        local imageOk, imageError = pcall(function()
            group:AddImage("游戏图标" .. index, {
                GameIcon = true,
                GameId = gameId,
                Height = 180,
                ScaleType = Enum.ScaleType.Fit,
                BackgroundTransparency = 1
            })
        end)
        if not imageOk then
            warn("[快速跳转] " .. name .. " 的图片创建失败：", imageError)
        end
        group:AddButton("快速跳转" .. index, {
            Text = "快速跳转",
            Func = function()
                local teleportOk, teleportError = pcall(function()
                    TeleportService:Teleport(placeId, LocalPlayer)
                end)
                if not teleportOk then
                    Library:Notify({
                        Title = "提示",
                        Description = "传送请求失败：" .. tostring(teleportError),
                        Time = 5,
                    })
                end
            end,
        })
    end
end
