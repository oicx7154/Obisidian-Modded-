return function(Tab, JSON_URL)
    local HttpService = game:GetService("HttpService")

    local authors = {}
    local gamesByAuthor = {}
    local loadError

    if cloneref then
      HttpService = cloneref(game:GetService("HttpService"))
    end
    -- 获取 JSON
    local ok, result = pcall(function()
        local raw = game:HttpGet(JSON_URL)
        return HttpService:JSONDecode(raw)
    end)

    if not ok then
        loadError = "读取JSON 失败：\n" .. tostring(result)
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

                    for _, gameName in ipairs(author.games) do
                        if type(gameName) == "string" and gameName ~= "" then
                            table.insert(gameNames, "• " .. gameName)
                        end
                    end

                    table.insert(authors, author.name)

                    gamesByAuthor[author.name] = #gameNames > 0 and ("支持的游戏：\n" .. table.concat(gameNames, "\n"))  or "该作者暂无支持的游戏。"
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

    local Dropdown

    Dropdown = Tab.support:AddParagraphDropdown({
        Title = "作者支持的游戏",
        Side = "Left",
        Mode = "Inline",

        MaxVisibleItems = 4,
        Values = authors,
        Default = nil,

        Content = hasAuthors
            and gamesByAuthor[authors[1]]
            or tostring(loadError),

        Callback = function(selected)
            if Dropdown then
                Dropdown:SetContent(
                    gamesByAuthor[selected] or "该作者暂无支持的游戏。")
            end
        end,
    })

    return Dropdown
end
