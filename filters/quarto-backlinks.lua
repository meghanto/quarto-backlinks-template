local json = quarto.json
local pandoc_path = pandoc.path

local links = {}
local projectdir = "/Users/meghanto/Documents/hackUO/quarto-backlinks"
local relativeinputfile = pandoc_path.make_relative(quarto.doc.input_file, projectdir, true)
local json_file_path = projectdir .. "/" .. "md_links.json"

function removeDotDot(path)
    local parts = {}
    for part in path:gmatch("[^/]+") do
        if part == ".." then
            if #parts > 0 and parts[#parts] ~= ".." then
                table.remove(parts)
            else
                table.insert(parts, part)
            end
        elseif part ~= "." then
            table.insert(parts, part)
        end
    end
    return table.concat(parts, "/")
end

function Link(el)
    if el.target:match('%.?md$') then
        local target = removeDotDot(pandoc_path.directory(relativeinputfile) .. "/" .. el.target)
        links[target] = relativeinputfile
    end
    return el
end

function read_existing_json()
    local file = io.open(json_file_path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return json.decode(content) or {}
    end
    return {}
end

function merge_links(existing, new)
    for dest, source in pairs(new) do
        if existing[dest] then
            if type(existing[dest]) == "string" then
                existing[dest] = {existing[dest]}
            end
            if not table.contains(existing[dest], source) then
                table.insert(existing[dest], source)
            end
        else
            existing[dest] = {source}
        end
    end
    return existing
end

function table.contains(tbl, item)
    for _, value in pairs(tbl) do
        if value == item then return true end
    end
    return false
end

function Pandoc(doc)
    doc = doc:walk {
        Link = Link
    }

    local existing_links = read_existing_json()
    local merged_links = merge_links(existing_links, links)

    local json_output = json.encode(merged_links)
    local file = io.open(json_file_path, "w")
    file:write(json_output)
    file:close()

    return doc
end