## Thatcher Lane
# Assignment 09
# Use of template provided by Jeannette Okinczyc

##
#  This module defines the Counter class.
#

## Models a tally counter whose value can be incremented, viewed, or reset.
#
class Counter :
    ## Gets the current value of this counter.
    #  @return the current value
    #
    def getValue(self) :
       return self._value

    ## Advances the value of this counter by 1.
    #
    def click(self) :
       self._value = self._value + 1

    ## Resets the value of this counter to 0.
    #
    def reset(self) :
       self._value = 0

    ## Allows user to undo click but not go into negative numbers
    #
    def undo(self):
        if self._value > 0:
            self._value = self._value - 1
        else:
            print("There are zero clicks recorded. Premission Denied.")
