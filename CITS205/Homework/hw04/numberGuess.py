## Thatcher Lane
## CITS 205
## Loops - Extra Credit Assignment
## 02/23/18

import random
secretValue=0
difLevel=0
numGuess=0
userGuess=0
continueGuessing = True
count = 1


#function called to give feedback on if the number is too high or too low
def giveFeedback(userGuess, secretValue):
    difference = abs(secretValue - userGuess)
    if(userGuess > secretValue):
        if(difference < 5):
            print("Ohh, so close. Just a little too high.")
        else:
            print("Wow... That was WAAAYYY too high. Tone it back a little ok?")
    else:
        if(difference < 5):
            print("That was a pretty good guess, you are a little on the low side though.")
        else:
            print("Not even close. Way too low man. Pick something closer please.")

#Generate a random number
secretValue = random.randint(1, 50)
print(secretValue)

#Set Difficulty Level
print("Please select a difficulty level: \n 1 = Easy (30 guesses) \n 2 = Medium (20 guesses) \n 3 = Hard (10 guesses)")
validInput = True
while(validInput):
    difLevel = int(input("What level would you like to play?"))
    if(difLevel == 1):
        numGuess = 30
        validInput = False
    elif(difLevel == 2):
        numGuess = 20
        validInput = False
    elif(difLevel == 3):
        numGuess = 10
        validInput = False
    else:
        print("Not a valid input. Please try again.")
    

#Intro Program
print("Why hello there! How are you doing today? I see you are interested in playing a little game. I have a secret number. Can you guess it?")

#Get user input
while(count <= numGuess):
    print("What is guess number", str(count) + "?")
    userGuess = int(input())
    #Compare and give feedback
    if(userGuess == secretValue):
        print("Congradulations!! You guessed my number correctly! I can't believe it... Next time I will have to think of a better number.")
        break
    else:
        giveFeedback(userGuess, secretValue)


