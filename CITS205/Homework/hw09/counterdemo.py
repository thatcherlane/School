##
#  This program demonstrates the Counter class.
#

# Import the Counter class from the counter module.
from counter import Counter

tally = Counter()
tally.reset()

print("*click*")
tally.click()
print("*click*")
tally.click()
print("*click*")
tally.click()
print("*click*")
tally.click()

result = tally.getValue()
print("That's:", result, "riders!")

print("*click*")

tally.click()
print("Oops! That was a mis-click!")
tally.undo()
tally.undo()

result = tally.getValue()
print("That's:", result, "riders!")
