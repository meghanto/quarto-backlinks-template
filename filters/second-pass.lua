local json = quarto.json
local pandoc_path = pandoc.path
local projectdir = "/Users/meghanto/Documents/hackUO/quarto-backlinks/"
local json_file_path = projectdir .. "/" .. "md_links.json"


function read_backlinks()
    local file = io.open(json_file_path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return json.decode(content) or {}
    end
    return {}
end

function create_backlinks_section(sources)
    local header = pandoc.Header(2, "Backlinks")
    local backlink_list = {}


    
    for _, source in ipairs(sources) do
        local relativesource = pandoc_path.make_relative(projectdir .. source,pandoc_path.directory(quarto.doc.input_file),true)
        local link = pandoc.Link(source:gsub("%.%w+$", ""),relativesource)


        table.insert(backlink_list, link)
    end
    
    local bullet_list = pandoc.BulletList(backlink_list)
    return pandoc.Div({header, bullet_list})
end

function Pandoc(doc)
    local current_file = pandoc_path.make_relative(quarto.doc.input_file, projectdir, true)

    local backlinks = read_backlinks()


    if backlinks[current_file] then
        local backlinks_section = create_backlinks_section(backlinks[current_file])
        table.insert(doc.blocks, backlinks_section)
    end
    
    return doc
end
