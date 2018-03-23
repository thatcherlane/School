## Thatcher Lane
# CITS 205
# Assignment 6
# 03/22/2018

from random import *


#creating variables that will be used
inRun = False
outputString = ""
outputList = []

#generate an empty list 20 items to populate will dice rolls
diceRolls = [None] * 20

#populate diceRolls list with values
for x in range(0,20):
    diceRolls[x] = randint(1,6)

#iterate through range of diceRolls list
for i in range(0,len(diceRolls)):

    #if at the last item stop iterating to prevent out of index error
    if i == 19:
        break

    #check if we are starting a run and not already in one
        # then append a ( to output
    if (diceRolls[i] == diceRolls[i+1]) and not inRun:
        outputList.append("(")
        inRun = True
    
    #add next dice roll to output
    outputList.append(diceRolls[i])

    #if we are in a run check to see if run has ended
    if inRun:
        if diceRolls[i] != diceRolls[i+1]: 
            outputList.append(")")
            inRun = False

#add last value to the output list
outputList.append(diceRolls[19])

#check if dice rolls end with a run and append ) if it does
if inRun:
    outputList.append(")")

#write outputList contents to a string and print them to the screen
for i in range(0,len(outputList)):
    outputString = outputString + " " + str(outputList[i])

print(outputString)


