lex = require "./lex.coffee"
fs = require "./orbfs.coffee"


syntax_cfg_path = "./config/syntax.cfg"


Array.prototype.remove = (value) ->
    i = this.indexOf value
    if i isnt -1 then this.splice i, 1 else this
    



printHelp = () ->
    console.log "Help printed."


exec = (code_str) ->
    undefined


lex.init syntax_cfg_path


for arg, i in process.argv
    if arg is "-h" or arg is "--help"
        printHelp()
    else if arg is "-e" or arg is "--exec"
        fpath = process.argv[i + 1]
        code_raw = fs.readFile fpath

        if typeof code_raw isnt "string"
            console.error code_raw[1]
            process.exit()

        lex_result = lex.parse_code code_raw
        console.log lex_result