lex = require "./lex.coffee"
semantic = require "./semantic.coffee"
fs = require "./orbfs.coffee"


lex_cfg_path = "./config/lex.cfg"
semantic_cfg_path = "./config/semantic.cfg"


Array.prototype.remove = (value) ->
    i = this.indexOf value
    if i isnt -1 then this.splice i, 1 else this
    



printHelp = () ->
    console.log "Help printed."


exec = (code_raw) ->
        lex_results = lex.parse_code code_raw
        if lex_results[1].length isnt 0
            console.error "Syntax error. Dumping..."
            console.error lex_results[1]
            process.exit()

        semantic.analyze_and_execute lex_results[0]



lex.init lex_cfg_path
semantic.init semantic_cfg_path


for arg, i in process.argv
    if arg is "-h" or arg is "--help"
        printHelp()
    else if arg is "-e" or arg is "--exec"
        fpath = process.argv[i + 1]
        code_raw = fs.readFile fpath

        if typeof code_raw isnt "string"
            console.error code_raw[1]
            process.exit()

        exec(code_raw)
