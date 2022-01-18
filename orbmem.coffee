
variables = []

add_var = (var) ->
    variables.push var

del_var = (var) ->
    variables.remove var

cmp_var = (var1, var2) ->
    return var1 is var2

# return -1 if fail
getid_var = (var) ->
    return variables.indexOf var

getlist_var = () ->
    return variables


