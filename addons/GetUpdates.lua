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

    local announcementLabel = Groupbox.gx:AddLabel(hasEntries and "正在加载更新公告……" or ("更新公告加载失败：\n" .. tostring(loadError)), true)

    local function escapeRichText(text)
        local result = tostring(text)
            :gsub("&", "&amp;")
            :gsub("<", "&lt;")
            :gsub(">", "&gt;")
            :gsub('"', "&quot;")
            :gsub("'", "&apos;")
    
        return result
    end
    
    local markers = {
        { symbol = "🟢", color = "#55FF7F" },
        { symbol = "🔴", color = "#FF5555" },
        { symbol = "🟡", color = "#FFD75F" },
        { symbol = "🟣", color = "#C77DFF" }
    }
    
    local function formatContent(content)
        local formatted = {}
    
        for line in (tostring(content) .. "\n"):gmatch("(.-)\n") do
            local foundStart, foundEnd, foundColor
    
            for _, marker in ipairs(markers) do
                local startPos, endPos = line:find(marker.symbol, 1, true)
    
                if startPos and (not foundStart or startPos < foundStart) then
                    foundStart = startPos
                    foundEnd = endPos
                    foundColor = marker.color
                end
            end
    
            if foundStart then
                local before = line:sub(1, foundStart - 1)
                local after = line:sub(foundEnd + 1)
    
                table.insert(
                    formatted,
                    escapeRichText(before)
                        .. '<font color="' .. foundColor .. '">'
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
    Groupbox.tz:AddLabel("🟢新增\n🔴删除\n🟡修复\n🟣优化",true)
    local image = Groupbox.mz:AddImage("", {
        Image = imageId,
        Height = 200,
        Transparency = 0,
        BackgroundTransparency = 0,
    })

    return announcementLabel, dropdown, image
end
