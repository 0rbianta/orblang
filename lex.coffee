fs = require "./orbfs.coffee"


exports.sequences = 
sequences = []
exports.literal = 
literal = []
exports.keywords = 
keywords = []
exports.ignore = 
ignore = []

smart_cut = (code) ->
    code = code.replaceAll "\n", " "
    is_passing = [no, null]
    out = []
    wbuild = ""
    for pc, i in code
        if is_passing[0]
            if is_passing[1] is "("
                if pc is ")" 
                    is_passing = [no, null]
                    wbuild = "(" + wbuild + ")"

                    continue
            if is_passing[1] is '"'
                if pc is '"' and code[i - 1] isnt "\\"
                    is_passing = [no, null]
                    wbuild = '"' + wbuild + '"'
                    continue
            
            wbuild += pc

        else
            if pc is "(" or pc is '"'
                is_passing = [yes, pc]
                continue

            if pc is " "
                out.push wbuild
                wbuild = ""
            else
                wbuild += pc
    return out


exports.parse_code = 
parse_code = (code) ->
    out = []
    for token in smart_cut code
        # console.log token
        if token in ignore
            continue

        for li in literal
            if typeof li is "string"
                if token is li
                    out.push ["%literal%", token]
            else
                if token.match(li) isnt null
                    out.push ["%literal%", token]

        for kw in keywords
            if typeof kw is "string"
                if token is kw
                    out.push ["%keyword%", token]
            else
                if token.match(kw) isnt null
                    out.push ["%keyword%", token]

    return out


parse_cfg_line = (line) ->
    out = ""
    if line[..4] is "reg->"
        reg = ///#{line[5..line.length]}///
        # add regex here
        out = reg
    else if line[..5] is "hexc->"
        ch = String.fromCharCode parseInt line[6..line.length], 16
        out = ch
    else
        out = line
    return out


exports.init =
init = (syntax_cfg_path) ->
    result = fs.readFile syntax_cfg_path
    if typeof result is "string"
        mode = "literal"
        for syntax in result.split "\n"

            if syntax[0] == "#"
                continue

            if syntax is "-literal"
                mode = "literal"
                continue
            else if syntax is "-sequences"
                mode = "sequences"
                continue
            else if syntax is "-keywords"
                mode = "keywords"
                continue
            else if syntax is "-ignore"
                mode = "ignore"
                continue
            
            if mode is "literal"
                literal.push parse_cfg_line syntax
                    
            if mode is "sequences"
                sequences.push parse_cfg_line syntax

            if mode is "keywords"
                keywords.push parse_cfg_line syntax

            if mode is "ignore"
                ignore.push parse_cfg_line syntax

    else
        console.error result[1]
        process.exit()





