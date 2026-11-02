return function(Tab)
    local JSON_URL =  "https://raw.githubusercontent.com/用户名/仓库名/main/supportgame.json"

    local HttpService = game:GetService("HttpService")
    if cloneref then
    HttpService = cloneref(game:GetService("HttpService"))
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
                and gamesByAuthor[author.name] == nil
            then
                local gameNames = {}

                for _, name in ipairs(author.games) do
                    if type(name) == "string" and name ~= "" then
                        table.insert(gameNames, "• " .. name)
                    end
                end

                table.insert(authors, author.name)
                gamesByAuthor[author.name] = #gameNames > 0
                    and ("支持的游戏：\n" .. table.concat(gameNames, "\n"))
                    or "该作者暂无支持的游戏。"
            end
        end
    end

    local hasAuthors = #authors > 0

    if not hasAuthors then
        authors = { "暂无作者" }
        loadError = loadError or "JSON 中没有有效的作者数据"
    end

    local dropdown

    dropdown = Tab.InfoTab:AddParagraphDropdown({
        Title = "作者支持的游戏",
        Side = "Left",
        Mode = "Inline",
        MaxVisibleItems = 4,

        Values = authors,
        Default = 1,

        Content = hasAuthors
            and gamesByAuthor[authors[1]]
            or tostring(loadError),

        Callback = function(selected)
            if dropdown then
                dropdown:SetContent(
                    gamesByAuthor[selected] or "该作者暂无支持的游戏。"
                )
            end
        end,
    })

    return dropdown
end
