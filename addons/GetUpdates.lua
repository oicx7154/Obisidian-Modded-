return function(Groupbox)
    local JSON_URL = "https://raw.githubusercontent.com/luojunjun43-del/1/refs/heads/main/Update%20Announcement.json"

    local DefaultImage = "rbxassetid://71686922157317"
    local imageId = DefaultImage

    local HttpService = game:GetService("HttpService")

    if type(cloneref) == "function" then
        HttpService = cloneref(HttpService)
    end

    local data
    local loadError

    local requestOk, raw = pcall(function()
        return game:HttpGet(JSON_URL)
    end)

    if not requestOk then
        loadError = "读取 GitHub 失败：\n" .. tostring(raw)
    else
        local decodeOk, decoded = pcall(function()
            return HttpService:JSONDecode(raw)
        end)

        if not decodeOk then
            loadError = "JSON 解析失败：\n" .. tostring(decoded)
        elseif type(decoded) ~= "table" or type(decoded.updates) ~= "table" then
            loadError = "JSON 格式错误：需要包含 updates 数组"
        else
            data = decoded
        end
    end

    local choices = {}
    local entryByChoice = {}
    local defaultIndex = 1

    if data then
        if type(data.image) == "string" and data.image ~= "" then
            imageId = data.image
        end

        local latestVersion = tostring(data.latest or "")

        for _, entry in ipairs(data.updates) do
            if type(entry) == "table"
                and entry.date ~= nil
                and entry.version ~= nil
            then
                local date = tostring(entry.date)
                local version = tostring(entry.version)
                local choice = date .. "(" .. version .. ")"

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

    local hasEntries = #choices > 0

    if not hasEntries then
        choices = { "暂无更新" }
        loadError = loadError or "updates 中没有有效的更新记录"
    end

    local announcementLabel = Groupbox.gx:AddLabel(
        hasEntries and "正在加载更新公告……"
            or ("更新公告加载失败：\n" .. tostring(loadError)),
        true
    )

    local function escapeRichText(text)
        return tostring(text)
            :gsub("&", "&amp;")
            :gsub("<", "&lt;")
            :gsub(">", "&gt;")
            :gsub('"', "&quot;")
            :gsub("'", "&apos;")
    end
    
    local colors = {
        ["+"] = "#55FF7F", -- 新增：绿色
        ["-"] = "#FF5555", -- 删除 / 修复：红色
        ["*"] = "#FFD75F", -- 优化：黄色
    }
    
    local function formatContent(content)
        local formatted = {}
    
        for line in (tostring(content) .. "\n"):gmatch("(.-)\n") do
            local before, marker, after = line:match("^(.-)%[([+%-%*])%](.*)$")
    
            if marker then
                table.insert(
                    formatted,
                    escapeRichText(before)
                        .. "[" .. marker .. "]"
                        .. '<font color="' .. colors[marker] .. '">'
                        .. escapeRichText(after)
                        .. "</font>"
                )
            else
                table.insert(formatted, escapeRichText(line))
            end
        end
    
        return table.concat(formatted, "\n")
    end
    
    local function showEntry(entry)
        if not entry then
            return
        end
    
        local dateVersion =
            tostring(entry.date or "") .. "(" .. tostring(entry.version or "") .. ")"
    
        local content = formatContent(entry.content or "")
    
        announcementLabel:SetText(
            escapeRichText(dateVersion) .. "\n\n" .. content
        )
    end
    local dropdown = Groupbox.gxxz:AddDropdown("更新日志", {
        Values = choices,
        Default = defaultIndex,
        AlwaysOpen = false,
        Multi = false,
        Text = "更新日志",

        Callback = function(selected)
            if type(selected) == "table" then
                selected = selected[1]
            end

            showEntry(entryByChoice[tostring(selected)])
        end,
    })

    if hasEntries then
        showEntry(entryByChoice[choices[defaultIndex]])
    end

    local image = Groupbox.mz:AddImage("", {
        Image = imageId,
        Height = 200,
        Transparency = 0,
        BackgroundTransparency = 0,
    })

    return announcementLabel, dropdown, image
end
