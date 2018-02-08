#Thatcher Lane
#CITS 205 - Assignment 1
#Jan 22, 2018
#
#solving problems 1.4, 1.9, and 1.14

#interestCalculator()
#Pre: none
#Post: none
#prints the balance of an account every year for 3 years making 5% interest (uses while loop)
def interestCalculator():
    years = 1
    balance = 1000

    while(years < 4):
        balance *= 1.05
        print("Balance after ", years, "year(s) :", str(balance), "\n")
        years+=1

#printHouse()
#Pre: none
#Post: none
#prints ascii art house
def printHouse():
    print("    +   \n",
          "  + +   \n",
          " +   +  \n",
          "+-----+ \n",
          "| ._. | \n",
          "| | | | \n",
          "+-+-+-+ \n")


#printBirthRecords()
#Pre: none
#Post: none
#prints 2 columns, one containing names, the other containing birth dates
#   uses while loop and an iterator
def printBirthRecords():
    name = ['Steve', 'Frank', 'Abbey', 'Allen', 'David'] 
    age = ["01/01/01", "02/02/02", "03/03/03", "04/04/04", "05/05/05"]
    iterator = 0

    while(iterator < 5):
        print(name[iterator], "     |     ", age[iterator], "\n")
        iterator+=1


#function call to print interest after 3 years
print("Printing the balance of a bank account (with initial balance of 1000) after 5 years: \n")
interestCalculator()

print("\n")
print("\n")

#function call to print ascii house
print("Printing a lovely little house for you to live in:\n")
printHouse()

print("\n")
print("\n")

#funciton call to print 5 people and their age
print("Printing the birth records of 5 close friends:\n")
printBirthRecords()


 

