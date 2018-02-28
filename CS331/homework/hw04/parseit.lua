--[[
-- lexit.lua
-- Sam Erie
-- CSCE331
-- Chappell
-- lexer for assignment 3
-- first module of Kanchil interpreter
-- passes all lexit_test.lua tests
-- 2/18/17
parse grammar
    (1)     	program 	  →   	stmt_list
    (2)     	stmt_list 	  →   	{ statement }
    (3)     	statement 	  →   	“cr”
    (4)     	  	|   	“print” ( STRLIT | expr )
    (5)     	  	|   	“input” lvalue
    (6)     	  	|   	“set” lvalue “:” expr
    (7)     	  	|   	“sub” ID stmt_list “end”
    (8)     	  	|   	“call” ID
    (9)     	  	|   	“if” expr stmt_list { “elseif” expr stmt_list } [ “else” stmt_list ] “end”
    (10)     	  	|   	“while” expr stmt_list “end”
    (11)     	expr 	  →   	comp_expr { ( “&&” | “||” ) comp_expr }
    (12)     	comp_expr 	  →   	“!” comp_expr
    (13)     	  	|   	arith_expr { ( “==” | “!=” | “<” | “<=” | “>” | “>=” ) arith_expr }
    (14)     	arith_expr 	  →   	term { ( “+” | “-” ) term }
    (15)     	term 	  →   	factor { ( “*” | “/” | “%” ) factor }
    (16)     	factor 	  →   	( “+” | “-” ) factor
    (17)     	  	|   	“(” expr “)”
    (18)     	  	|   	NUMLIT
    (19)     	  	|   	( “true” | “false” )
    (20)     	  	|   	lvalue
    (21)     	lvalue 	  →   	ID [ “[” expr “]” ]
lex categories
    lexit.KEY = 1
    lexit.ID = 2
    lexit.ID = 3
    lexit.NUMLIT = 4
    lexit.STRLIT = 5
    lexit.OP = 6
    lexit.PUNCT = 7
    lexit.MAL = 8
]]

parseit = {}
lexit = require "lexit"

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

local iter
local state
local retStr
local retCat

local str
local cat

-- matchString
-- Given string, see if current lexeme string form is equal to it. If
-- so, then advance to next lexeme & return true. If not, then do not
-- advance, return false.
-- Function init must be called before this function is called.
local function matchString(s)
    if lexstr == s then
        advance()
        return true
    else
        return false
    end
end


local function advanceLexer()

    if str == "]" or str == ")" or str == "true" or str == "false" or cat == lexit.ID or cat == lexit.NUMLIT then
        lexit.preferOp()
    end

	retStr, retCat = iter(state, retStr)

	if retStr ~= nil then
		str, cat = retStr, retCat
	else
		str, cat = "", 0
	end
end


local function initLexer(raw)
	iter, state, retStr = lexit.lex(raw)
	advanceLexer()
end

local function isCompareOp(op)

    local match = false
    local comps = {"==","!=","<=","<",">=",">"}

    for i = 1, #comps do
        if op == comps[i] then
            match = true
        end
    end

    return match

end


function parseit.parse(raw)


	initLexer(raw)

	local good, ast = parse_stmt_list()
	local done = (cat == 0)	--atend

	return good, done, ast

end


 --parse functions--


    function parse_lvalue()
        local good, ast, newast, tempstr

        good = true
        ast = {SIMPLE_VAR, str}
        tempstr = str
        advanceLexer()

            if str == "[" then
                ast = tempstr
                advanceLexer()

                good, newast = parse_expr()
                if str ~= "]" or not good then
                    return false, nil
                end
                advanceLexer()

                ast = {ARRAY_VAR, ast, newast}
            end

            return good, ast

    end

    function parse_factor()

        local good, ast, newast

        --conditions are all ors so I think I
        --can consolidate (elseif) with one return at
        --bottom

        if str == "+" or str == "-" then
            ast = {UN_OP, str}
            advanceLexer()

            good, newast = parse_factor()
            ast= {ast, newast}
            if not good then
                return false, nil
            end

            return good, ast
        end

        if str == "(" then

            advanceLexer()

            good, ast = parse_expr()
            if not good then
                return false, nil
            end

            if str == ")" then  --do this opposite in lvalue, should normalize
                advanceLexer()
                return good, ast
            else
                return false, nil
            end
        end

        if str == "true" or str == "false" then
            ast = {BOOLLIT_VAL, str}
            advanceLexer()
            return true, ast
        end

        if cat == lexit.NUMLIT then
            ast = {NUMLIT_VAL, str}
            advanceLexer()
            return true, ast
        end

        if cat == lexit.ID then
            good, ast = parse_lvalue()
            if not good then
                return false, nil
            end


            return good, ast
        end

        --if it gets here its not a factor
        return false, nil
    end

    function parse_term()

        local good, ast, newast, save

        good, ast = parse_factor()
        if not good then
            return false, nil
        end

         while str == "*" or str == "/" or str == "%" do

                save = str
                advanceLexer()

                good, newast = parse_factor()
                if not good then
                    return false, nil
                end

            ast = {{BIN_OP, save}, ast, newast}
        end

        return good, ast

    end

    function parse_arith_expr()

        local good, ast, newast, save

        good, ast = parse_term()
        if not good then
            return false, nil
        end

         while str == "+" or str == "-" do

                save = str
                advanceLexer()

                good, newast = parse_term()
                if not good then
                    return false, nil
                end

                ast = {{BIN_OP, save}, ast, newast}
        end

        return good, ast

    end




    function parse_comp_expr()

        local good, ast, newast, save

        if str == "!" then
            ast = {UN_OP, str}
            advanceLexer()

            good, newast = parse_comp_expr()
            if not good then
                return false, nil
            end

            ast = {ast, newast}
            return good, ast

        end

        good, ast = parse_arith_expr()
        if not good then
            return false, nil
        end

         while isCompareOp(str) do

                save = str
                advanceLexer()

                good, newast = parse_arith_expr()
                if not good then
                    return false, nil
                end

                ast = {{BIN_OP, save}, ast, newast}
        end

            return good, ast
    end


    function parse_expr()
      local good, ast, saveop, newast

      good, ast = parse_comp_expr()
      if not good then
          return false, nil
      end

      while true do
          saveop = lexstr
          if not matchString("&&") and not matchString("||") then
              break
          end

          good, newast = parse_comp_expr()
          if not good then
              return false, nil
          end

          ast = { { BIN_OP, saveop}, ast, newast }
    end

        return true, ast
    end


    function parse_statement()

        local good, ast, newast, thirdast, save

        if cat == lexit.KEY then

            -- if str == "cr" then
            --
            --     advanceLexer()
            --     return true, {CR_STMT}
            if str == "print" then

                advanceLexer()

                if cat == lexit.STRLIT then
                    save = str
                    advanceLexer()
                    return true, {PRINT_STMT, {STRLIT_OUT, save}}
                end

                good, ast = parse_expr()
                if not good then
                    return false, nil
                end

                return good, {PRINT_STMT, ast}
            elseif str == "input" then

                advanceLexer()

                if cat == lexit.ID then

                    good, ast = parse_lvalue()
                    if not good then
                        return false, nil
                    end

                    return good, {INPUT_STMT, ast}
                else
                    --input with no variable
                    return false, nil
                end
            -- elseif str == "set" then
            --
            --     advanceLexer()
            --
            --     if cat == lexit.ID then
            --
            --         good, ast = parse_lvalue()
            --         if not good then
            --             return false, nil
            --         end
            --
            --         if str == ":" then
            --
            --             advanceLexer()
            --
            --             good, newast = parse_expr()
            --             if not good then
            --                 return false, nil
            --             end
            --
            --             return good, {SET_STMT, ast, newast}
            --         else
            --             --set with no : (assignment op)
            --             return false, nil
            --         end
            --      else
            --         --set with no LHS
            --         return false, nil
            --     end
            elseif str == "func" then

                advanceLexer()

                if cat == lexit.ID then

                    save = str
                    advanceLexer()

                    good, ast = parse_stmt_list()
                    if not good then
                        return false, nil
                    end

                    if str ~= "end" then
                        return false, nil
                    end

                    advanceLexer()

                    ast = {FUNC_STMT, save, ast}

                    return good, ast

                else
                    return false, nil
                end
                elseif str == "call" then

                    advanceLexer()

                    if str == "call" then
                      return false, nil
                    end

                    if cat == lexit.ID then

                        ast = {CALL_FUNC, str}
                        advanceLexer()
                        return true, ast
                    end


                elseif str == "if" then

                    advanceLexer()

                    good, ast = parse_expr()
                    if not good then
                        return false, nil
                    end

                    good, newast = parse_stmt_list()
                    if not good then
                        return false, nil
                    end

                    ast = {IF_STMT, ast, newast}


                    while str == "elseif" do

                        advanceLexer()

                        good, newast = parse_expr()
                        if not good then
                            return false, nil
                        end

                        good, thirdast = parse_stmt_list()
                        if not good then
                            return false, nil
                        end

                        ast[#ast+1] = newast
                        ast[#ast+1] = thirdast
                    end

                    if str == "else" then
                        advanceLexer()
                        good, newast = parse_stmt_list()
                        if not good then
                            return false, nil
                        end

                        ast[#ast+1] = newast
                    end

                    if str ~= "end" then
                        return false, nil
                    end

                    advanceLexer()

                    return good, ast
                elseif str == "while" then

                    advanceLexer()

                    good, ast = parse_expr()
                    if not good then
                        return false, nil
                    end

                    good, newast = parse_stmt_list()

                    if not good then
                        return false, nil
                    end

                    ast = {WHILE_STMT, ast, newast}

                    if str ~= "end" then
                        return false, nil
                    end

                    advanceLexer()

                    return good, ast

            end
                --this is if it makes it past all ifs
                --and hasn't returned...hence keyword that isnt a statement
                return true, nil

        else
            --this is if it's not a keyword...still can be good syntax
            return true, nil
        end
    end

    function parse_print_arg()
      return true, nil
    end

    function parse_stmt_list()

        local good, ast, newast

        good = true
        ast = {STMT_LIST}

        while cat ~= 0 and str ~= "end" and str ~= "elseif" and str ~= "else" do

            good, newast = parse_statement()

            if not good then
                return false, nil
            elseif newast == nil then  --good syntax but bad program
                return true, nil        --idk needed to get past first tests like input "end"
            end

            --appends new element onto ast table (array)
            ast[#ast+1] = newast

        end


        return good, ast

    end



return parseit
