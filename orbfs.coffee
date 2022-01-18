fs = require "fs"

exports.readFile = 
readFile = (fpath, encoding="utf8") ->
    if fpath != undefined
        try
            content = fs.readFileSync fpath, encoding
            return content
        catch err
            if err.errno is -2
                return [err.errno, "Failed to read #{err.path}. Make sure file with that name exist"]
            else
                return [err.errno, "Failed to read file with an unknown error"]
    else
        return [err.errno, "File path can't be undefined"]