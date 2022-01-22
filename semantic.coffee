fs = require "./orbfs.coffee"

sequences = []

exports.init = 
init = (semantic_cfg_path) ->
    result = fs.readFile semantic_cfg_path
    if typeof result is "string"
        pr = []
        for lp in result.split " "
            pr.push lp.split ":"
        sequences = pr
    else
        console.error result[1]
        process.exit()

exports.analyze_and_execute = 
analyze_and_execute = (lex_result) ->
    for seq in sequences
        console.log seq

    # for data in lex_result
    #     type = ""
    #     raw = ""
    #     li_cls = ""
    # 
    # 
    #     type = data[0]
    #     if "%literal%" is data[0]
    #         raw = data[1][0]
    #         li_cls = data[1][1]
    #     else
    #         raw = data[1]

