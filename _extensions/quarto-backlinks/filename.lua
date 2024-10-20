local projectdir = "/Users/meghanto/Documents/hackUO/quarto-backlinks"
local relativeinputfile = pandoc.path.make_relative(quarto.doc.input_file, projectdir, true)

return {
    ['filename'] = function(args, kwargs, meta) 
      return pandoc.Str(relativeinputfile)
    end
  }