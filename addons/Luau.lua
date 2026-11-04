local function HighlightLuau(Source)
    Source = tostring(Source or "")

    local Keywords = {
        ["and"] = true,
        ["break"] = true,
        ["continue"] = true,
        ["do"] = true,
        ["else"] = true,
        ["elseif"] = true,
        ["end"] = true,
        ["export"] = true,
        ["for"] = true,
        ["function"] = true,
        ["if"] = true,
        ["in"] = true,
        ["local"] = true,
        ["not"] = true,
        ["or"] = true,
        ["repeat"] = true,
        ["return"] = true,
        ["then"] = true,
        ["type"] = true,
        ["until"] = true,
        ["while"] = true,
    }

    local Constants = {
        ["true"] = true,
        ["false"] = true,
        ["nil"] = true,
    }

    local Builtins = {
        ["assert"] = true,
        ["error"] = true,
        ["getmetatable"] = true,
        ["ipairs"] = true,
        ["next"] = true,
        ["pairs"] = true,
        ["pcall"] = true,
        ["print"] = true,
        ["rawequal"] = true,
        ["rawget"] = true,
        ["rawset"] = true,
        ["require"] = true,
        ["select"] = true,
        ["setmetatable"] = true,
        ["tonumber"] = true,
        ["tostring"] = true,
        ["type"] = true,
        ["typeof"] = true,
        ["warn"] = true,
        ["xpcall"] = true,
    }

    local Colors = {
        Keyword = "#C792EA",
        Constant = "#F78C6C",
        Builtin = "#82AAFF",
        String = "#C3E88D",
        Comment = "#718096",
        Number = "#F78C6C",
    }

    local function Escape(Text)
        return Text
            :gsub("&", "&amp;")
            :gsub("<", "&lt;")
            :gsub(">", "&gt;")
            :gsub('"', "&quot;")
            :gsub("'", "&apos;")
    end

    local Result = {}
    local Length = #Source
    local Position = 1

    local function Add(Text, Color)
        Text = Escape(Text)

        if Color then
            table.insert(
                Result,
                '<font color="' .. Color .. '">' .. Text .. "</font>"
            )
        else
            table.insert(Result, Text)
        end
    end

    -- Read a Lua long string or long comment starting at an opening bracket.
    local function ReadLongBracket(Start)
        local Equals = Source:sub(Start):match("^%[(=*)%[")
        if Equals == nil then
            return nil
        end

        local OpeningLength = #Equals + 2
        local Closing = "]" .. Equals .. "]"
        local _, EndPosition = Source:find(
            Closing,
            Start + OpeningLength,
            true
        )

        return EndPosition or Length
    end

    while Position <= Length do
        local Rest = Source:sub(Position)
        local Character = Source:sub(Position, Position)
        local Pair = Source:sub(Position, Position + 1)

        if Pair == "--" then
            local LongEnd = ReadLongBracket(Position + 2)

            if LongEnd then
                Add(Source:sub(Position, LongEnd), Colors.Comment)
                Position = LongEnd + 1
            else
                local Newline = Source:find("\n", Position, true)
                local EndPosition = Newline and Newline - 1 or Length

                Add(Source:sub(Position, EndPosition), Colors.Comment)
                Position = EndPosition + 1
            end

        elseif Character == "'" or Character == '"' or Character == "`" then
            local Quote = Character
            local EndPosition = Position + 1

            while EndPosition <= Length do
                local Current = Source:sub(EndPosition, EndPosition)

                if Current == "\\" then
                    EndPosition += 2
                elseif Current == Quote then
                    EndPosition += 1
                    break
                else
                    EndPosition += 1
                end
            end

            Add(
                Source:sub(Position, EndPosition - 1),
                Colors.String
            )

            Position = EndPosition

        elseif Character == "[" and ReadLongBracket(Position) then
            local EndPosition = ReadLongBracket(Position)

            Add(Source:sub(Position, EndPosition), Colors.String)
            Position = EndPosition + 1

        elseif Character:match("[%a_]") then
            local Word = Rest:match("^[%a_][%w_]*")

            if Keywords[Word] then
                Add(Word, Colors.Keyword)
            elseif Constants[Word] then
                Add(Word, Colors.Constant)
            elseif Builtins[Word] then
                Add(Word, Colors.Builtin)
            else
                Add(Word)
            end

            Position += #Word

        elseif Character:match("%d") then
            local Number = Rest:match("^0[xX][%da-fA-F_]+")
                or Rest:match("^0[bB][01_]+")
                or Rest:match("^%d[%d_]*%.?[%d_]*[eE][%+%-]?[%d_]+")
                or Rest:match("^%d[%d_]*%.?[%d_]*")

            Add(Number, Colors.Number)
            Position += #Number

        else
            Add(Character)
            Position += 1
        end
    end

    return table.concat(Result)
end
return HighlightLuau
