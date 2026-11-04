local HttpService = cloneref(game:GetService("HttpService"))

local function ShowAnnouncement(Window, Library, Config)
    Config = Config or {}

    local Url = Config.Url
    local SaveFile = Config.SaveFile or "UpdateAnnouncement.json"
    local DialogId = Config.DialogId or "RemoteAnnouncement"
    local ButtonText = Config.ButtonText or "我知道了"

    if type(Url) ~= "string" or Url == "" then
        warn("Announcement: JSON URL is missing.")
        return false
    end

    local Request = type(request) == "function" and request
        or type(http_request) == "function" and http_request
        or type(syn) == "table" and type(syn.request) == "function" and syn.request

    if not Request then
        warn("Announcement: request is unavailable.")
        return false
    end

    local Success, Response = pcall(Request, {
        Url = Url,
        Method = "GET",
    })

    if not Success or type(Response) ~= "table" then
        warn("Announcement: failed to request JSON.", Response)
        return false
    end

    local StatusCode = tonumber(Response.StatusCode)
    if StatusCode and (StatusCode < 200 or StatusCode >= 300) then
        warn("Announcement: JSON request failed with status", StatusCode)
        return false
    end

    if type(Response.Body) ~= "string" or Response.Body == "" then
        warn("Announcement: JSON response is empty.")
        return false
    end

    local Decoded, Data = pcall(function()
        return HttpService:JSONDecode(Response.Body)
    end)

    if not Decoded or type(Data) ~= "table" then
        warn("Announcement: invalid JSON.", Data)
        return false
    end

    if Data.Enabled ~= true then
        return false
    end

    if type(Data.Version) ~= "string" or Data.Version == "" then
        warn("Announcement: Version must be a non-empty string.")
        return false
    end

    local Version = Data.Version
    local Title = type(Data.Title) == "string" and Data.Title or "脚本公告"
    local Content = type(Data.Content) == "string" and Data.Content or ""
    local RepeatEnabled = Data.RepeatEnabled == true
    local IntervalDays = tonumber(Data.IntervalDays) or 3

    if IntervalDays ~= IntervalDays or IntervalDays == math.huge or IntervalDays == -math.huge then
        IntervalDays = 3
    end

    IntervalDays = math.max(0, IntervalDays)

    local SavedData

    if type(isfile) == "function" and type(readfile) == "function" then
        local Checked, Exists = pcall(isfile, SaveFile)

        if Checked and Exists then
            local ReadSuccess, SavedText = pcall(readfile, SaveFile)

            if ReadSuccess and type(SavedText) == "string" then
                local SavedDecoded, Result = pcall(function()
                    return HttpService:JSONDecode(SavedText)
                end)

                if SavedDecoded and type(Result) == "table" then
                    SavedData = Result
                end
            end
        end
    else
        warn("Announcement: file reading is unavailable; confirmation cannot be remembered across runs.")
    end

    if SavedData and SavedData.Version == Version then
        if not RepeatEnabled then
            return false
        end

        local ClosedAt = tonumber(SavedData.ClosedAt)
        local Now = os.time()

        if ClosedAt and ClosedAt == ClosedAt and ClosedAt <= Now then
            local Elapsed = Now - ClosedAt
            if Elapsed < IntervalDays * 86400 then
                return false
            end
        end
    end

    if Library.ActiveDialog then
        warn("Announcement: another dialog is active; announcement was skipped.")
        return false
    end

    if Library.Dialogues and Library.Dialogues[DialogId] then
        warn("Announcement: dialog ID is already in use:", DialogId)
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
                Title = ButtonText,
                Variant = "Primary",
                Callback = function(Dialog)
                    if type(writefile) == "function" then
                        local Encoded, SavedText = pcall(function()
                            return HttpService:JSONEncode({
                                Version = Version,
                                ClosedAt = os.time(),
                            })
                        end)

                        if Encoded then
                            local Written, WriteError = pcall(writefile, SaveFile, SavedText)
                            if not Written then
                                warn("Announcement: failed to save confirmation.", WriteError)
                            end
                        else
                            warn("Announcement: failed to encode confirmation.", SavedText)
                        end
                    else
                        warn("Announcement: file writing is unavailable; confirmation cannot be remembered across runs.")
                    end

                    Dialog:Dismiss()
                end,
            },
        },
    })

    return true
end

return ShowAnnouncement
