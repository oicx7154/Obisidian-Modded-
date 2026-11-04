return function(Tab)
    local JSON_URL =  "https://raw.githubusercontent.com/luojunjun43-del/1/main/SupportGame.json"

    local HttpService = game:GetService("HttpService")

    if type(cloneref) == "function" then
        HttpService = cloneref(HttpService)
    end

    local authors = {}
    local gamesByAuthor = {}
    local loadError

    local ok, result = pcall(function()
        local raw = game:HttpGet(JSON_URL)
        return HttpService:JSONDecode(raw)
    end)

    if not ok then
        loadError = "读取或解析 JSON 失败：\n" .. tostring(result)
    elseif type(result) ~= "table" or type(result.authors) ~= "table" then
        loadError = "JSON 格式错误：需要包含 authors 数组"
    else
        for _, author in ipairs(result.authors) do
            if type(author) == "table"
                and type(author.name) == "string"
                and author.name ~= ""
                and type(author.games) == "table"
            then
                if gamesByAuthor[author.name] == nil then
                    local gameNames = {}

                    for _, name in ipairs(author.games) do
                        if type(name) == "string" and name ~= "" then
                            table.insert(gameNames, "• " .. name)
                        end
                    end

                    table.insert(authors, author.name)

                    gamesByAuthor[author.name] = #gameNames > 0
                        and table.concat(gameNames, "\n")
                        or "该作者暂无支持的游戏。"
                else
                    warn("重复的作者名称，已跳过：", author.name)
                end
            end
        end
    end

    local hasAuthors = #authors > 0

    if not hasAuthors then
        authors = { "暂无作者" }
        loadError = loadError or "JSON 中没有有效的作者数据"
    end

    local paragraph = Tab.support:AddParagraph({
        Title = hasAuthors and (authors[1] .. " 支持的游戏") or "支持的游戏",
        Content = hasAuthors
            and gamesByAuthor[authors[1]]
            or tostring(loadError),
        Side = "Left",
        RichText = false,
    })

    local dropdown = Tab.support:AddParagraphDropdown({
        Title = "选择作者",
        Side = "Right",
        Mode = "Inline",
        MaxVisibleItems = 4,
        ExpandColumns = 2,
        ListOnly = true,
        Expandable = true,
        Multi = false,
        AllowNull = false,
        Values = authors,
        Default = 1,

        Callback = function(selected)
            if gamesByAuthor[selected] then
                paragraph:SetTitle(tostring(selected) .. " 支持的游戏")
                paragraph:SetContent(gamesByAuthor[selected])
            end
        end,
    })
    local tips = Tab.support:AddParagraph({
        Title = "提示",
        Content = "表情符号的意思\n"..
"🟢=正常使用\n"..
"🟡=正在维护/部分功能失效\n"..
"🔴=不能使用\n"..
"🟣=将会更新(等1到5天)\n"..
"🟤=短暂下架/之后会更\n"..
"🔵=有活动/正常使用\n"..
"⛔=建议拿小号使用\n"..
"⚫=存在风险问题不建议使用\n"..
"🌀=要传送进游戏内(对局)\n"..
"💰=定制脚本\n"..
"🔒=需要特殊卡密\n"..
"💸=永久专属\n"..
"🤖=有ai成分\n\n"..
"仅供设备\n"..
"仅电脑=💻\n"..
"仅手机=📱\n"..
"电脑或手机=💻📱\n"..
"部分功能手机用不了=📵\n"..
"部分功能电脑用不了=🚫\n",
        Side = "Right",
        RichText = false,
        Collapsible = true,
    })
    
    return dropdown, paragraph, tips
end
