--Thatcher Lane
--
--
--
--

local parseit = {}
lexit = require "lexit"

local iter
local state
local outStr
local outCat


local str = ""
local cat = 0


local STMT_LIST   = 1
local INPUT_STMT  = 2
local PRINT_STMT  = 3
local FUNC_STMT   = 4
local CALL_FUNC   = 5
local IF_STMT     = 6
local WHILE_STMT  = 7
local ASSN_STMT   = 8
local CR_OUT      = 9
local STRLIT_OUT  = 10
local BIN_OP      = 11
local UN_OP       = 12
local NUMLIT_VAL  = 13
local BOOLLIT_VAL = 14
local SIMPLE_VAR  = 15
local ARRAY_VAR   = 16


-- Utility Functions:

-- atEnd
local function atEnd()
  return cat == 0
end

-- advanceLexer
local function advanceLexer()
  outStr, outCat = iter(state, outStr)

  if outStr ~= nil then
    str, cat = outStr, outCat
    if cat == lexit.ID or cat == lexit.NUMLIT or str == ")" or str == "true" or str == "false" then
      lexit.preferOp()
    end
  else
    str, cat = "", 0
  end
end

-- matchString
local function matchString(s)
  if str == s then
    advanceLexer()
    return true

  else
    return false
  end

end

-- matchCat
local function matchCat(c)
  if cat == c then
    advanceLexer()
    return true

  else
    return false
  end

end

-- init
local function init(prog)
  iter, state, outStr = lexit.lex(prog)
  advanceLexer()
end

-- parse
function parseit.parse(prog)
  init(prog)

  local good, ast = parse_program()  -- Parse start symbol
  local done = atEnd()

  return good, done, ast
end



-- parse_program
function parse_program()

  local good, ast
  good, ast = parse_stmt_list()
  return good, ast

end


-- parse_stmt_list
function parse_stmt_list()
  local good, ast, newast

  ast = { STMT_LIST }
  while true do
    if str ~= "input"
      and str ~= "print"
      and str ~= "func"
      and str ~= "call"
      and str ~= "if"
      and str ~= "while"
      and cat ~= lexit.ID then
        return true, ast
    end

    good, newast = parse_statement()
    if not good then
        return false, nil
    end

    table.insert(ast, newast)
  end
  return true, ast
end


-- parse_statement
function parse_statement()

  local good, ast1, ast2, savelex

  if matchString("input") then
    good, ast1 = parse_lvalue()
    if not good then
        return false, nil
    end

    return true, { INPUT_STMT, ast1 }

  elseif matchString("print") then
    good, ast1 = parse_print_arg()
    if not good then
        return false, nil
    end

    ast2 = { PRINT_STMT, ast1 }

    while true do
        if not matchString(";") then
            break
        end

        good, ast1 = parse_print_arg()
        if not good then
            return false, nil
        end

        table.insert(ast2, ast1)
    end

    return true, ast2

  elseif matchString("func") then
    savelex = str
    if not matchCat(lexit.ID) then
        return false, nil
    end

    good, ast1 = parse_stmt_list()
    if not good then
        return false, nil
    end

    if not matchString("end") then
        return false, nil
    end

    return true, {FUNC_STMT, savelex, ast1}

  elseif matchString("call") then
    savestring = str

    if not matchCat(lexit.ID) then
        return false, nil
    end

    return true, {CALL_FUNC, savestring}

  elseif matchString("if") then
    good, ast1 = parse_expr()
    if not good then
        return false, nil
    end

    good, ast2 = parse_stmt_list()
    if not good then
        return false, nil
    end

    ast1 = {IF_STMT, ast1, ast2}

    while true do
      if not matchString("elseif") then
        break
      end

      good, ast2 = parse_expr()
      if not good then
          return false, nil
      end

      table.insert(ast1, ast2)

      good, ast2 = parse_stmt_list()
      if not good then
          return false, nil
      end

      table.insert(ast1, ast2)
    end

    if  matchString("else") then
      good, ast2 = parse_stmt_list()
      if not good then
          return false, nil
      end

      table.insert(ast1, ast2)
    end

    if not matchString("end") then
      return false, nil
    end

    return true, ast1

  elseif matchString("while") then
    good, ast1 = parse_expr()
    if not good then
      return false, nil
    end

    good, ast2 = parse_stmt_list()
    if not good then
      return false, nil
    end

    if not matchString("end") then
      return false, nil
    end
    return true, {WHILE_STMT, ast1, ast2}
  end

  good, ast1 = parse_lvalue()
  if not good then
    return false, nil
  end
  if not matchString("=") then
    return false, nil
  end
  good, ast2 = parse_expr()
  if not good then
    return false, nil
  end
  return true, {ASSN_STMT, ast1, ast2}

end

-- parse_print_arg
function parse_print_arg()
  local good, ast, savelex
  if matchString("cr") then
    return true, {CR_OUT}
  end
  savelex = str
  if matchCat(lexit.STRLIT) then
    return true, {STRLIT_OUT, savelex}
  end
  good, ast = parse_expr()
  if not good then
    return false, nil
  end
  return true, ast
end

-- parse_expr
function parse_expr()
  local good, ast, ast2, saveop
  good, ast = parse_comp_expr()
  if not good then
    return false, nil
  end
  while true do
    saveop = str
    if not matchString("&&") and not matchString("||") then
      return true, ast
    end
    good, ast2 = parse_comp_expr()
    if not good then
      return false, nil
    end
    ast = {{BIN_OP, saveop}, ast, ast2}
  end
end

-- parse_comp_expr
function parse_comp_expr()
  local good, ast, saveop, ast2
  if matchString("!") then
    good, ast = parse_comp_expr()
    if not good then
      return false, nil
    end
    return true, {{UN_OP, "!"}, ast}
  end
  good, ast = parse_arith_expr()
  if not good then
    return false, nil
  end
  while true do
    saveop = str
    if not matchString("==") and not matchString("!=") and not matchString("<")
    and not matchString("<=") and not matchString(">") and not matchString(">=") then
      return true, ast
    end
    good, ast2 = parse_arith_expr()
    if not good then
      return false, nil
    end
    ast = {{BIN_OP, saveop}, ast, ast2}
  end
end

-- parse_arith_expr
function parse_arith_expr()
  local good, ast, ast2, saveop
  good, ast = parse_term()
  if not good then
    return false, nil
  end
  while true do
    saveop = str
    if not matchString("+") and not matchString("-") then
      return true, ast
    end
    good, ast2 = parse_term()
    if not good then
      return false, nil
    end
    ast = {{BIN_OP, saveop}, ast, ast2}
  end
end

-- parse_lvalue
function parse_lvalue()
  local good, ast, id
  id = str
  if not matchCat(lexit.ID) then
    return false, nil
  end
  if not matchString("[") then
    return true, {SIMPLE_VAR, id}
  end

  good, ast = parse_expr()
  if not good then
    return false, nil
  end

  if not matchString("]") then
    return false, nil
  end
  return true, {ARRAY_VAR, id, ast}
end

-- parse_term
function parse_term()
  local good, ast, saveop, newast

  good, ast = parse_factor()
  if not good then
      return false, nil
  end

  while true do
    saveop = str
    if not matchString("*") and not matchString("/") and not matchString("%") then
        return true, ast
    end

    good, newast = parse_factor()
    if not good then
        return false, nil
    end

    ast = { { BIN_OP, saveop }, ast, newast }
  end
end


-- parse_factor
function parse_factor()
  local savelex, good, ast

  savelex = str
  if matchCat(lexit.NUMLIT) then
      return true, { NUMLIT_VAL, savelex }
  elseif matchString("(") then
      good, ast = parse_expr()
      if not good then
          return false, nil
      end

      if not matchString(")") then
          return false, nil
      end

      return true, ast
  elseif matchString("call") then
    savelex = str
    if matchCat(lexit.ID) then
      return true, {CALL_FUNC, savelex}
    end
  elseif matchString("+") or matchString("-") then
    good, ast = parse_factor()
    if not good then
      return false, nil
    end
    return true, {{UN_OP, savelex}, ast}
  elseif matchString("true") or matchString("false") then
    return true, {BOOLLIT_VAL, savelex}
  else
    good, ast = parse_lvalue()
    if not good then
      return false, nil
    end
    return true, ast
  end
end

return parseit
