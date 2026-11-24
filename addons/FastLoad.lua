return function(Tab, jsonUrl)
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
    assert(Tab and Tab.ft, "未找到")
    assert(type(jsonUrl) == "string" and jsonUrl ~= "", "未提供 JSON 链接")
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
    for index, entry in ipairs(data) do
        if type(entry) ~= "table" then
            warn("[快速跳转] 第 " .. index .. " 项不是对象")
            continue
        end
        local name = entry.Name
        local placeId = tonumber(entry.PlaceId)
        local gameId = tonumber(entry.GameId)
        local direction = tostring(entry.Direction or "Left"):lower()
        local imageType = entry.ImageType or "GameIcon"
        if type(name) ~= "string" or name == "" then
            warn("[快速跳转] 第 " .. index .. " 项缺少 Name")
            continue
        end
        if not placeId or placeId <= 0 or placeId % 1 ~= 0 then
            warn("[快速跳转] " .. name .. " 的 PlaceId 无效")
            continue
        end
        if imageType ~= "GameIcon" and imageType ~= "GameThumbnail" then
            warn("[快速跳转] " .. name .. " 的 ImageType 无效")
            continue
        end
        if imageType == "GameIcon" and (not gameId or gameId <= 0 or gameId % 1 ~= 0) then
            warn("[快速跳转] " .. name .. " 缺少有效的 GameId")
            continue
        end
        local group
        if direction == "right" then
            group = Tab.ft:AddRightGroupbox(name)
        else
            group = Tab.ft:AddLeftGroupbox(name)
        end
        local imageInfo = {
            Image = "rbxassetid://0",
            Height = 180,
            ScaleType = Enum.ScaleType.Fit,
        }
        if imageType == "GameThumbnail" then
            imageInfo.GameThumbnail = true
            imageInfo.PlaceId = placeId
        else
            imageInfo.GameIcon = true
            imageInfo.GameId = gameId
        end
        local imageOk, imageError = pcall(function()
            group:AddImage("游戏图标" .. index, imageInfo)
        end)
        if not imageOk then
            warn("[快速跳转] " .. name .. " 的图片创建失败：", imageError)
        end
        group:AddButton("快速跳转" .. index, {
            Text = "快速跳转",
            Func = function()
                local teleportOk, teleportError = pcall(function()
                    TeleportService:TeleportAsync(placeId, {LocalPlayer})
                end)
                if not teleportOk then
                    warn("[快速跳转] 传送请求失败：", teleportError)
                end
            end,
        })
    end
end
