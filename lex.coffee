fs = require "./orbfs.coffee"


exports.sequences = 
sequences = []
exports.literal = 
literal = []
exports.keywords = 
keywords = []
exports.ignore = 
ignore = []
exports.operators = 
operators = []
exports.variables = 
variables = []



# TODO: handle_error
handle_error = (lex_result) ->
    for info in lex_result
        token = info[0]
        word = info[1]



smart_cut = (code) ->
    # Delete comment lines before processing
    nc = ""
    for line in code.split "\n"
        if line[0] isnt "#"
            # adds extra line break at end of the code. It's fine
            nc += line + "\n"

    code = nc

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
    sc_data = smart_cut code
    for token in sc_data
        # console.log token
        if token in ignore
            continue

        for li in literal
            if typeof li is "string"
                if token is li
                    out.push ["%literal%", token]
                    continue
            else
                if token.match(li) isnt null
                    out.push ["%literal%", token]
                    continue

        for kw in keywords
            if typeof kw is "string"
                if token is kw
                    out.push ["%keyword%", token]
                    continue
            else
                if token.match(kw) isnt null
                    out.push ["%keyword%", token]
                    continue
        
        for op in operators
            if typeof op is "string"
                if token is op
                    out.push ["%operator%", token]
                    continue
            else
                if token.match(op) isnt null
                    out.push ["%operator%", token]
                    continue

        for va in variables
            if typeof va is "string"
                if token is va
                    out.push ["%variable%", token]
                    continue
            else
                if token.match(va) isnt null
                    out.push ["%variable%", token]
                    continue
        



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
            else if syntax is "-operators"
                mode = "operators"
                continue
            else if syntax is "-variables"
                mode = "variables"
                continue
            
            
            if mode is "literal"
                literal.push parse_cfg_line syntax
                    
            if mode is "sequences"
                sequences.push parse_cfg_line syntax

            if mode is "keywords"
                keywords.push parse_cfg_line syntax

            if mode is "ignore"
                ignore.push parse_cfg_line syntax
            
            if mode is "operators"
                operators.push parse_cfg_line syntax

            if mode is "variables"
                variables.push parse_cfg_line syntax

    else
        console.error result[1]
        process.exit()





