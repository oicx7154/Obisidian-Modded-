local HttpService = cloneref(game:GetService("HttpService"))

local function GetRequestFunction()
    if type(request) == "function" then
        return request
    end

    if type(http_request) == "function" then
        return http_request
    end

    if type(syn) == "table" and type(syn.request) == "function" then
        return syn.request
    end

    return nil
end

local function ShowAnnouncement(Window, Library, Config)
    assert(typeof(Window) == "table", "Announcement: Window must be a table")
    assert(typeof(Library) == "table", "Announcement: Library must be a table")

    Config = Config or {}

    local Url = Config.Url
    local SaveFile = Config.SaveFile or "ObsUI_Announcement.json"
    local DialogId = Config.DialogId or "RemoteAnnouncement"

    assert(typeof(Url) == "string" and Url ~= "", "Announcement: Url is required")
    assert(typeof(SaveFile) == "string" and SaveFile ~= "", "Announcement: SaveFile must be a string")

    local Request = GetRequestFunction()

    if not Request then
        warn("Announcement: request is unavailable.")
        return false
    end

    local Success, Response = pcall(Request, {
        Url = Url,
        Method = "GET",
        Headers = {
            ["Cache-Control"] = "no-cache",
        },
    })

    if not Success or typeof(Response) ~= "table" then
        warn("Announcement: failed to request announcement.")
        return false
    end

    local StatusCode = tonumber(Response.StatusCode)

    if StatusCode and (StatusCode < 200 or StatusCode >= 300) then
        warn("Announcement: request failed with status", StatusCode)
        return false
    end

    if typeof(Response.Body) ~= "string" or Response.Body == "" then
        warn("Announcement: response body is empty.")
        return false
    end

    local DecodeSuccess, Data = pcall(function()
        return HttpService:JSONDecode(Response.Body)
    end)

    if not DecodeSuccess or typeof(Data) ~= "table" then
        warn("Announcement: invalid JSON.")
        return false
    end

    if Data.Enabled ~= true then
        return false
    end

    if typeof(Data.Version) ~= "string" or Data.Version == "" then
        warn("Announcement: Version must be a non-empty string.")
        return false
    end

    local Version = Data.Version
    local Title = typeof(Data.Title) == "string" and Data.Title or "脚本公告"
    local Content = typeof(Data.Content) == "string" and Data.Content or ""

    local IntervalDays = tonumber(Data.IntervalDays) or 3

    if IntervalDays ~= IntervalDays or IntervalDays == math.huge then
        IntervalDays = 3
    end

    IntervalDays = math.max(0, IntervalDays)

    local State

    if type(isfile) == "function" and type(readfile) == "function" then
        local ReadSuccess, Result = pcall(function()
            if not isfile(SaveFile) then
                return nil
            end

            return HttpService:JSONDecode(readfile(SaveFile))
        end)

        if ReadSuccess and typeof(Result) == "table" then
            State = Result
        end
    end

    local Now = os.time()

    if State and State.Version == Version then
        local ClosedAt = tonumber(State.ClosedAt)

        if ClosedAt and ClosedAt <= Now then
            local Elapsed = Now - ClosedAt
            local IntervalSeconds = IntervalDays * 24 * 60 * 60

            if Elapsed < IntervalSeconds then
                return false
            end
        end
    end

    -- Avoid stacking the announcement over an existing dialog.
    if Library.ActiveDialog and not Library.ActiveDialog.Destroyed then
        warn("Announcement: another dialog is active; announcement was skipped.")
        return false
    end

    -- Avoid replacing another dialog with the same ID.
    if Library.Dialogues and Library.Dialogues[DialogId] then
        warn("Announcement: dialog ID is already in use.")
        return false
    end

    Window:AddDialog(DialogId, {
        Title = Title,
        Description = Content,

        OutsideClickDismiss = false,
        AutoDismiss = false,

        FooterButtons = {
            {
                Id = "Confirm",
                Title = Config.ButtonText or "我知道了",
                Variant = "Primary",

                Callback = function(Dialog)
                    -- Save only when the player acknowledges the announcement.
                    if type(writefile) == "function" then
                        local SaveSuccess, Err = pcall(function()
                            local SaveData = {
                                Version = Version,
                                ClosedAt = os.time(),
                            }

                            writefile(SaveFile, HttpService:JSONEncode(SaveData))
                        end)

                        if not SaveSuccess then
                            warn("Announcement: failed to save state:", tostring(Err))
                        end
                    else
                        warn("Announcement: writefile is unavailable.")
                    end

                    Dialog:Dismiss()
                end,
            },
        },
    })

    return true
end

return ShowAnnouncement
