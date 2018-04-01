## Thatcher Lane
## Assignment 7
## CITS 205

import csv
import collections

#initalizing variables
rowCount = 0
jpCount = 0
ukCount = 0
deCount = 0
lastName = []
dupName = []

#greeting user
print("Hello, this progam analyzes the file 'mydata.csv'.")
print("Here are the statistics we found: \n\n")

with open('mydata.csv', 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        #insert last name to list for later use
        lastName.append(row[1])
        #counting total number of entries
        rowCount += 1

        #completing count for email extensions
        email = row[2]
        if email[-3:] == ".jp":
            jpCount += 1
        if email[-3:] == ".uk":
            ukCount += 1
        if email[-3:] == ".de":
            deCount +=1

##finding duplicate names
for i in range(len(lastName)):
  for j in range(i + 1, len(lastName)):
    if lastName[i] == lastName[j]:
        dupName.append(lastName[i])

##printing findings to file
outFile = open("lastname_results.txt","w+")
outFile.write("# of entries: " + str(rowCount) + "\n")
outFile.write("# of emails ending in .jp: " + str(jpCount) + "\n")
outFile.write("# of emails ending in .uk: " + str(ukCount) + "\n")
outFile.write("# of emails ending in .de: " + str(deCount) + "\n")
outFile.write("The duplicate surnames are: " + str(dupName) + "\n")

##printing finding to console
print("# of entries: " + str(rowCount))
print("# of emails ending in .jp: " + str(jpCount))
print("# of emails ending in .uk: " + str(ukCount))
print("# of emails ending in .de: " + str(deCount))
print("The duplicate surnames are: " + str(dupName))
print("\n\n")

#thank user and tell them where their information has been stored
print("Thank you for using the program. These statistics have been saves to the file 'lastname_results.txt'.")
