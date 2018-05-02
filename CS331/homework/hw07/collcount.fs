\ collcount.fs
\ Thatcher Lane
\ CS 331
\ Assignment 7

: Collatz ( n -- c )
  dup 1 = if
  2 -
  else
  dup 2 mod
  0= if
  2 /
  else
  3 * 1 +
  then
  then ;

\ Recursively through through the collatz function to reach base case of 1
: Collatz-Length ( n -- c )
  dup -1 = invert if
  Collatz recurse 1 +
  then ;

\ Wrapper class
: collcount ( n -- c)
  Collatz-Length ;
