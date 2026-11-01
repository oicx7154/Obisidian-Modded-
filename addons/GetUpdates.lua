return function(config)
    local HttpService = cloneref(game:GetService("HttpService"))

    local url = config.JsonUrl
    local dev = tostring(config.Dev)
    local gameId = tostring(game.GameId)

    local choices = {}
    local entryByChoice = {}
    local defaultIndex = 1
    local loadError

    local separator = url:find("?", 1, true) and "&" or "?"
    local requestUrl = url .. separator .. "t=" .. tostring(os.time())

    local success, result = pcall(function()
        local raw = game:HttpGet(requestUrl)
        return HttpService:JSONDecode(raw)
    end)

    if not success then
        loadError = "读取或解析公告失败：\n" .. tostring(result)
    elseif type(result) ~= "table" or type(result.games) ~= "table" then
        loadError = "JSON 格式错误：缺少 games 对象"
    else
        local gameData = result.games[gameId]

        if type(gameData) ~= "table" then
            loadError = "没有找到当前体验的公告。\nUniverse ID：" .. gameId
        elseif type(gameData.developers) ~= "table" then
            loadError = "当前体验缺少 developers 对象"
        else
            local devData = gameData.developers[dev]

            if type(devData) ~= "table" then
                loadError = "没有找到开发者「" .. dev .. "」的公告"
            elseif type(devData.updates) ~= "table" then
                loadError = "开发者「" .. dev .. "」缺少 updates 数组"
            else
                local latestVersion = tostring(devData.latest or "")

                for _, entry in ipairs(devData.updates) do
                    if type(entry) == "table"
                        and entry.date ~= nil
                        and entry.version ~= nil
                    then
                        local version = tostring(entry.version)
                        local choice =
                            tostring(entry.date) .. "(" .. version .. ")"

                        if not entryByChoice[choice] then
                            table.insert(choices, choice)
                            entryByChoice[choice] = entry

                            if version == latestVersion then
                                defaultIndex = #choices
                            end
                        end
                    end
                end
            end
        end
    end

    local hasEntries = #choices > 0

    if not hasEntries then
        choices = { "暂无更新" }
        loadError = loadError or "没有有效的更新记录"
    end

    local announcementLabel = config.AnnouncementBox:AddLabel( hasEntries and "正在加载更新公告……" or ("更新公告加载失败：\n" .. tostring(loadError)), true)

    local function showEntry(entry)
        if not entry then
            return
        end

        local title = tostring(entry.date) .. "(" .. tostring(entry.version) .. ")"

        announcementLabel:SetText(title .. "\n\n" .. tostring(entry.content or ""))
    end

    local dropdown = config.UpdateLogBox:AddDropdown("更新日志", {
        Text = "更新日志",
        Values = choices,
        Default = defaultIndex,
        Multi = false,
        AlwaysOpen = false,

        Callback = function(selected)
            showEntry(entryByChoice[selected])
        end,
    })

    if hasEntries then
        showEntry(entryByChoice[choices[defaultIndex]])
    end
    local imageId = config.DefaultImage or "rbxassetid://71686922157317"
    
    local imageOk, imageData = pcall(function()
        local raw = game:HttpGet(config.ImageJsonUrl)
        return HttpService:JSONDecode(raw)
    end)
    
    if imageOk and type(imageData) == "table" then
        if type(imageData.image) == "string" and imageData.image ~= "" then
            imageId = imageData.image
        end
    end
    
    local image = config.ImageBox:AddImage("", {
        Image = imageId,
        Height = 200,
        Transparency = 0,
        BackgroundTransparency = 0,
        ScaleType = Enum.ScaleType.Stretch,
    })
    return announcementLabel, dropdown,image
end
