return function(Window, Library)
    task.spawn(function()
        local ModuleUrl = "https://raw.githubusercontent.com/oicx7154/Obisidian-Modded-/main/addons/Announcement.lua"
        local Request = type(request) == "function" and request
            or type(http_request) == "function" and http_request
            or type(syn) == "table" and type(syn.request) == "function" and syn.request

        if not Request then
            warn("Announcement: request is unavailable.")
            return
        end

        local Success, Response = pcall(Request, {
            Url = ModuleUrl,
            Method = "GET",
        })

        if not Success or type(Response) ~= "table" then
            warn("Announcement: failed to load module.", Response)
            return
        end

        local StatusCode = tonumber(Response.StatusCode)
        if StatusCode and (StatusCode < 200 or StatusCode >= 300) then
            warn("Announcement: module request failed with status", StatusCode)
            return
        end

        if type(Response.Body) ~= "string" or Response.Body == "" then
            warn("Announcement: module response is empty.")
            return
        end

        local Compiled, Chunk, CompileError = pcall(loadstring, Response.Body)
        if not Compiled or type(Chunk) ~= "function" then
            warn("Announcement: failed to compile module:", CompileError or Chunk)
            return
        end

        local Loaded, ShowAnnouncement = pcall(Chunk)
        if not Loaded or type(ShowAnnouncement) ~= "function" then
            warn("Announcement: module failed to load or did not return a function.", ShowAnnouncement)
            return
        end

        local Called, Result = pcall(ShowAnnouncement, Window, Library, {
            Url = "https://raw.githubusercontent.com/luojunjun43-del/1/refs/heads/main/Update%20Announcement.json",
            SaveFile = "Update.json",
            DialogId = "RemoteAnnouncement",
            ButtonText = "我知道了",
        })

        if not Called then
            warn("Announcement: failed to show announcement.", Result)
        end
    end)
end
