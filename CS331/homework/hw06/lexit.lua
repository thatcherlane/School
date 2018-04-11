--lexit.lua
--Thatcher Lane
--Hw03
--CS 331

lexit = {}		--module to export

-- *** exports *** ---

	lexit.KEY = 1
	lexit.ID = 2
	lexit.NUMLIT = 3
	lexit.STRLIT = 4
	lexit.OP = 5
	lexit.PUNCT = 6
	lexit.MAL = 7

	lexit.catnames =
	{
		"Keyword",
		"Identifier",
		"NumericLiteral",
		"StringLiteral",
		"Operator",
		"Punctuation",
		"Malformed"
	}

	local binaryOnly = false

	function lexit.preferOp()
		binaryOnly = true
	end
---------------------------------------

-- *** parse functions *** ---

	local function empty(c)
		return ( c:len() ~= 1 )
	end

	local function legal(c)
		if empty(c) then
			return false
		end

		return ( c >= " " and c <= "~" )
	end

	local function digit(c)
		if empty(c) then
			return false
		end

		return ( c >= "0" and c <= "9" )
	end

	local function letter(c)
		if empty(c) then
			return false
		end

		return ( (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") )
	end

	local function whiteSpace(c)
		if empty(c) then
			return false
		end

		return ( c == " " or c == "\t" or c == "\n" or c == "\r" or c == "\f" )
	end
----------------------------------------

--- *** main function *** ---

	function lexit.lex(raw)

		--state machine variables--

		local pos
		local state
		local str
		local char
		local category
		local userType = false
		local delim

		--state handler table index
		local DONE = 0
		local START = 1
		local WORD = 2
		local NUMBER = 3
		local OPERATOR = 4
		local STRING = 5

		--tables to match operators and keys
		local ops = { "=","&&","||","!","==","!=","<","<=",">",">=","+","-","*", "/", "%", "[", "]", ";" }
		local key = {"call","cr","else","elseif","end","false","if","input","print","func","true","while"}

		--state machine functions--

		local function matchOp(ch, idx)
			for i=1, #ops do
				if ops[i]:len() >- idx then
					if ops[i]:sub(idx,idx) == ch then
						return true
					end
				end
			end

			return false
		end

		local function isOp(s)
			for i=1, #ops do
				if s == ops[i] then
					return true
				end
			end

			return false
		end

		local function isKey(s)
			for i = 1, #key do
				if s == key[i] then
					return true
				end
			end

			return false
		end

		local function hasExp(c)

			for i = 1, c:len() do
				e = c:sub(i,i)
				if e == "e" or e == "E" then
					return true
				end
			end

			return false

		end


		local function currentChar()
			return raw:sub(pos,pos)
		end

		local function getChar()
			return raw:sub(pos,pos)
		end

		local function lookAhead(n)
			return raw:sub(pos+n, pos+n)
		end

		local function skipChar()
			pos = pos + 1
		end

		local function addChar()
			str = str .. getChar()
			skipChar()
		end

		local function skipWhite()
			if not (pos > raw:len()) then

				while whiteSpace(getChar()) do
					skipChar()
				end
				char = getChar()
				if char == "#" then
					while char ~= "\n" and char ~= "\f" and not empty(char) do
						skipChar()
						char = getChar()
					end
					skipChar()
					skipWhite()
				end
			end
		end


		--state handler functions--

		local function handle_DONE()
			io.write("Program Error")
			assert(0)
		end

		local function handle_START()
			if not legal(char) then
				addChar()
				category = lexit.MAL
				state = DONE
			elseif letter(char) or char == "_" then
				addChar()
				userType = true
				category = lexit.ID
				state = WORD
			elseif letter(char) then
				addChar()
				state = WORD
			elseif digit(char) or char == "+" or char == "-" then
				addChar()
				state = NUMBER
			elseif char == '"' or char == "'" then
				addChar()
				delim = char
				state = STRING
			elseif matchOp(char, 1) then
				addChar()
				state = OPERATOR
			else
				addChar()
				category = lexit.PUNCT
				state = DONE
			end
		end

		local function handle_WORD()

			if not userType then
				category = lexit.MAL
			end

			if letter(char) or digit(char) then
				addChar()
			elseif userType and (letter(char) or (digit(char) and str:len() ~= 1) or char == "_") then	--for user types
				addChar()
			else

				if isKey(str) then
					category = lexit.KEY
				end

				state = DONE
				if str == "%" then
					category = lexit.OP
				end
				if str == "&" then
					if char == "&" then
						addChar()
						category = lexit.OP
					else
						category = lexit.PUNCT
					end
				end

				userType = false
			end
		end

		local function handle_NUMBER()
			category = lexit.NUMLIT

			if (str == "+" or str == "-") and ( binaryOnly or not digit(char)) then
				category = lexit.OP
				state = DONE
			elseif digit(char) then
				addChar()
			elseif (char == "e" or char == "E") and str ~= "+" and str ~= "-" and not hasExp(str) then	--this got pretty heavy, I probably should have just made handle_EXP
				if digit(lookAhead(1)) or ( lookAhead(1) == "+" and digit(lookAhead(2)) ) then

					addChar()
					state = START
				else
					state = DONE
				end
			else
				state = DONE
			end

		end

		local function handle_OPERATOR()
			category = lexit.OP
			if matchOp(char, 2) then
				if isOp(str .. char) then
					addChar()
				end
			end

			if not isOp(str) then
				category = lexit.PUNCT
			end

			state = DONE
		end

		local function handle_STRING()
			if char == delim then
				addChar()
				state = DONE
				category = lexit.STRLIT
			elseif char == "" or char == "\n" then
				addChar()
				state = DONE
				category = lexit.MAL
			else
				addChar()
			end
		end

		--state handler table--

		local handler =
		{
			[DONE] = handle_DONE,
			[START] = handle_START,
			[WORD] = handle_WORD,
			[NUMBER] = handle_NUMBER,
			[OPERATOR] = handle_OPERATOR,
			[STRING] = handle_STRING

		}


	--- *** main iterator function *** ---

		local function iter(d1, d2)

			if pos > raw:len() then
				binaryOnly = false
				return nil, nil
			end

			str = ""
			state = START
			while state ~= DONE do
				char = getChar()
				handler[state] ()
			end


			skipWhite()
			binaryOnly = false
			return str, category
		end


		pos = 1
		skipWhite()

		return iter, nil, nil
	end
------------------------------------

return lexit 	--export module
