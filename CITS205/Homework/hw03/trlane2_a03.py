#############################################
# Thatcher Lane
# CITS 205
# Assignment 3
# Star sign program
#############################################

## library used to determine a if the users date of birth is valid
import datetime

## declare all variables used
correctDate = True
name = ""
starSign = ""
fortune = ""
birthYear = 0
birthMonth = 0
birthDay = 0

## introduce the program to the user
print("Hello! Nice to see you today! Welcome to our astrology program.")
## retrieve the users name
name = input("Please enter your name: ")

## while loop used to repeat prompting for birthYear, birthMonth, and birthDay until
## a valid date is entered. Also accounts for leap years becuase of year inclusion
while correctDate:
    ## prompts for birth date YYYY/MM/DD
    birthYear = int(input("Please enter the year of your birth in (YYYY) format (e.g. 1981):"))
    birthMonth = int(input("Please enter the month of your birth (1-12):"))
    birthDay = int(input("Please enter the day of your birth (1-31):"))

    ## try block that creates a new datetime object with the provided dates. If an exception is
    ##   thrown then we move to the except before changing the bool that affects our while statement
    try:
        newDate = datetime.datetime(birthYear, birthMonth, birthDay)
        correctDate = False

    ## Prints a message to the user telling them that they entered an invalid dates
    ## moves back to a new iteration of the while loop
    except ValueError:
        print("Be sure that you are entering a valid month and day. Please try again. ")


## nested if else statement that assigns star sign and fortune
## As a side note I found a list of fortune cookie fortunes and used them
##   as fortunes for the different star signs. The Lucky Numbers are all mine though
if ((birthMonth==3 and birthDay >= 21)or(birthMonth==4 and birthDay<= 19)):
        starSign = "Aries"
        fortune = "A dubious friend may be an enemy in camouflage. Lucky Numbers: 12, 7, 1"
elif ((birthMonth==4 and birthDay >= 20)or(birthMonth==5 and birthDay<= 20)):
        starSign = "Taurus"
        fortune = "Man is born to live and not prepared to live. Take wise advantage of your time. Lucky Numbers: 48, 36, 21"
elif ((birthMonth==5 and birthDay >= 21)or(birthMonth==6 and birthDay<= 20)):
        starSign = "Gemini"
        fortune = "Soon life will become more interesting. Lucky Numbers: 33, 19, 6"
elif ((birthMonth==6 and birthDay >= 21)or(birthMonth==7 and birthDay<= 22)):
        starSign = "Cancer"
        fortune = "Time and patience are called for many surprises await you! Lucky Numbers: 11, 4, 99"
elif ((birthMonth==7 and birthDay >= 23)or(birthMonth==8 and birthDay<= 22)):
        starSign = "Leo"
        fortune = "You are admired by everyone for your talent and ability. Lucky Numbers: 2, 121, 77"
elif ((birthMonth==8 and birthDay >= 23)or (birthMonth==9 and birthDay<= 22)):
        starSign = "Virgo"
        fortune = "Your talents will be recognized and suitably rewarded. Lucky Numbers: 9, 55, 73"
elif ((birthMonth==9 and birthDay >= 23)or(birthMonth==10 and birthDay<= 22)):
        starSign = "Libra"
        fortune = "Your quick wits will get you out of a tough situation. Lucky Numbers: 1, 42, 100"
elif ((birthMonth==10 and birthDay >= 23)or(birthMonth==11 and birthDay<= 21)):
        starSign = "Scorpio"
        fortune = "Your moods signal a period of change. Lucky Numbers: 5, 93, 60"
elif ((birthMonth==11 and birthDay >= 22)or(birthMonth==12 and birthDay<= 21)):
        starSign = "Sagittarius"
        fortune = "Change is happening in your life, so go with the flow! Lucky Numbers: 8, 12, 99"
elif ((birthMonth==12 and birthDay >= 22)or(birthMonth==1 and birthDay<= 19)):
        starSign = "Capricorn"
        fortune = "Romance moves you in a new direction. Lucky Numbers: 17, 24, 88 "
elif ((birthMonth==1 and birthDay >= 20)or(birthMonth==2 and birthDay<= 18)):
        starSign = "Aquarius"
        fortune = "Because you demand more from yourself, others respect you deeply. Lucky Numbers: 7, 49 76"
elif ((birthMonth==2 and birthDay >= 19)or(birthMonth==3 and birthDay<= 20)):
        starSign = "Pices"
        fortune = "Don’t just think, act! Lucky Numbers: 9, 10, 105"

## Prints the users name, star sign, and their fortune. 
print("Hello", name, "! Your star sign is " + starSign + ".")
print("Here is your fortune: \n", fortune)
