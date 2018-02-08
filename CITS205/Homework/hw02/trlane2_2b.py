##
# Assignment 2 pt 2 - drawing with turtles
# Thatcher Lane
# CITS 205


# creating various turtles of different colors
import turtle
win = turtle.Screen()
turtle1 = turtle.Turtle()
turtle1.color('red')
turtle2 = turtle.Turtle()
turtle2.color('green')
turtle3 = turtle.Turtle()
turtle3.color('blue')
turtle4 = turtle.Turtle()
turtle4.color('indigo')
turtle5 = turtle.Turtle()
turtle5.color('pink')
turtle6 = turtle.Turtle()
turtle6.color('purple')


#Pre: Input must be a valid integer greater than zero
#Post: recursivley calculates the fibonacci sequence
#      and returns once a base case of zero is reached
#define function to recursively calculate fibonacci sequence
def fibo(n):
   if n <= 1:
       return n
   else:
       return(fibo(n-1) + fibo(n-2))


#find userinput on how many item s in sequence to generate
#    at least 10 is recomended to draw a suffienct pattern
n = int(input("How many terms would you like to calculate? "))

# check if the number of terms is valid
if n <= 0:
   #error checking for a valid number of sequence items
   print("Plese enter a positive integer (at lease ten is recomended to draw a sufficient pattern")
else:
   for i in range(n):
       #assign fibo number to x * multiplier for ease of viewing
       x = fibo(i)*25

       #move turtles forward fibo distance and rotate them
       turtle1.forward(x)
       turtle1.left(55)
       turtle2.forward(x)
       turtle2.left(45)
       turtle3.forward(x)
       turtle3.left(30)
       turtle4.forward(x)
       turtle4.left(25)
       turtle5.forward(x)
       turtle5.left(50)
       turtle6.forward(x)
       turtle6.left(35)

       
       

       
       
