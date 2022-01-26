fs = require "./orbfs.coffee"
orbstr_f = require "./datatypes/orbstr.coffee"



sequences = {}


# Replace variables with native types
exports.gen_var_types = 
gen_var_types = (lex_result) ->
    out = []
    for item in lex_result
        tc = item[0]
        if typeof item[1] is "string"
            out.push [tc, item[1]]
        else
            data = item[1][0]
            dtype = item[1][1]
            if dtype is "orbstr"
                out.push [tc, dtype, new orbstr_f.orbstr(data)]
    out

exports.init = 
init = (semantic_cfg_path) ->
    result = fs.readFile semantic_cfg_path
    if typeof result is "string"
        pr = {}
        pr["seq"] = []
        pr["cmd"] = []
        is_cmd_passing = no
        for lp in result.split "\n"
            for token in lp.split " "
                if token == "->"
                    is_cmd_passing = yes
                    continue

                if not is_cmd_passing
                    pr["seq"].push token.split ":"
                else
                    pr["cmd"].push token
        sequences = pr
    else
        console.error result[1]
        process.exit()

exports.analyze_and_execute = 
analyze_and_execute = (typed_lex_results) ->
    # Will search the first token and then other if first comes
    