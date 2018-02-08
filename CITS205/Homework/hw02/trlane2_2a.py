##
# Assignment two
# Thatcher Lane
# CITS 205 

##prompts user to input two numbers
num1 = int(input("please enter a number: \n"))
num2 = int(input("please enter a second number: \n"))


##Pre: None
##Post: None
##the sum of two numbers
sumOfNumbers = num1+num2 
print("Sum of your two numbers is:", sumOfNumbers)

##Pre: None
##Post: None
##the difference of two numbers
diffOfNumbers = num1-num2
print("Difference of your two numbers is:", diffOfNumbers)

##Pre: None
##Post: None
##the product of two numbers
productOfNumbers = num1*num2
print("Product of your two numbers is:", productOfNumbers)

##Pre: None
##Post: None
##the average of two numbers
print("Average of your two numbers is:", productOfNumbers/2)

##Pre: None
##Post: None
##the distance of two numbers (absolute value of the difference)
print("Distance between your two numbers is:", abs(diffOfNumbers))

##Pre: None
##Post: None
##the maximum of two numbers (the larger of the two)
maxOfNumbers = max(num1, num2)
print("Maximum of your two numbers is:", maxOfNumbers)

##Pre: None
##Post: None     
##the minimum of two numbers (the smaller of the two)
print("Minimum of your two numbers is:", min(num1, num2))
