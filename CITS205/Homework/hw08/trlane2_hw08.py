## Thatcher Lane
# CITS 205
# Assignment 8

#initalize variable
students = {}
runCondition = True

#adds students to dictionary
def addStudent(name, grade):
    students.update({str(name):str(grade)})

#removes students from dictionary
def removeStudent(name):
    del students[str(name)]

#modifies grade of student
def modifyGrade(name, newGrade):
    students[str(name)] = str(newGrade)

#prints name: grade for every student
def printGrades():
    for name in students:
        print(name + ": " + students[name])

#loop that itereates through until exit command is given
while runCondition:
    print("Hello, please select an option for our grading program:")
    print("1: Add a student")
    print("2: Remove a student")
    print("3: Update a student grade")
    print("4: Print all grades")
    print("5: Exit")

    choice = int(input(""))

    #get user input and adds student
    if choice == 1:
        name = str(input("Please enter student name to add: "))
        grade = str(input("Please enter student grade: "))
        print("")
        addStudent(name, grade)
        print("\n")

    #get user input and removes student
    if choice == 2:
        name = str(input("Please enter student name to remove: "))
        print("")
        removeStudent(name)
        print("\n")

    #get user input and updates grade
    if choice == 3:
        name = str(input("Please enter student name to update: "))
        grade = str(input("Please enter student grade to update: "))

        isValidStudent = name in students

        if isValidStudent:
            modifyGrade(name, grade)
            print("\n")
        else:
            print("")
            print("There is no student named " + name)
            print("Please try again.")
            print("\n")

    #prints names and grades
    if choice == 4:
        print("")
        printGrades()
        print("\n")

    #Exits program
    if choice == 5:
        print("")
        print("Thank you for using the program. Have a nice day.")
        runCondition = False
