-- pa2.lua
-- Thatcher Lane
-- CS 331
-- Assignment 2


local pa2 = {}

-- mapArray()
-- Takes a function f and an array t.
-- Returns an array containing f(it) for each item array t after performing f(it).
function pa2.mapArray(f, t)

  retValue = {}

  for key, value in pairs(t) do
    retValue[key] = f(value)
  end

  return retValue
end

-- concatMax()
-- Takes a string s and an integer i.
-- Returns a string with concatenations of as many copies of s as possible without exceeding i
-- if i < s concatMax() returns an empty string ""
function pa2.concatMax(s, i)
  size = s:len()
  origStr = s
  totalCopies = math.floor((i - size)/size)

  if (totalCopies < 0)
    then return ""
  end

  if (totalCopies == 0)
    then return s
  else
    copies = 0
    while(copies < totalCopies) do
      s = s..origStr
      copies = copies + 1
    end
    return s
  end

end


-- collatz
-- This takes an integer parameter k and yields one or more integers
-- these are the entries in the Collatz sequence starting at k
function pa2.collatz(k)

  while true do
    if k == 1 then
      coroutine.yield(k)
      break
    end

    if ((k%2) == 0) then
      coroutine.yield(k)
      k = k/2;

    else
      coroutine.yield(k)
      k = (3*k)+1
    end
  end

end

return pa2
