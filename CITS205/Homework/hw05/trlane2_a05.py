##Thatcher Lane
# CITS 205
# Assignment 5


minutesToWords = {1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five', \
                6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten', \
                11: 'eleven', 12: 'twelve', 13: 'thirteen', 14: 'fourteen', \
                15: 'fifteen', 16: 'sixteen', 17: 'seventeen', 18: 'eighteen', \
                19: 'nineteen', 20: 'twenty', 21: 'twenty one', 22: 'twenty two', \
                23: 'twenty three', 24: 'twenty four', 25: 'twenty five', \
                26: 'twenty six', 27: 'twenty seven', 28: 'twenty eight', \
                29: 'twenty nine', 30: 'thirty', 31: 'thirty one', 32: 'thirty two', \
                33: 'thirty three', 34: 'thirty four', 35: 'thirty five', 36: 'thirty six', \
                37: 'thirty seven', 38: 'thirty eight', 39: 'thirty nine', 40: 'forty'}

hoursToWords = {1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five', \
            6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten', \
            11: 'eleven', 12: 'twelve', 13: 'one'}

specialTimes = {0: "o'clock", 15: "quarter after", 30: "half past", 45: "quarter til"}


timeName = ""

#getTimeName
# params: hours - the hour of the time
#         minutes - the minutes of the time
# returns: returns a string that is the time
#          of day written in plain english
# Pre: -hours must be between 0 and 12
#      -minutes must be between 1 and 60
# Post: timeName string is no longer empty
def getTimeName(hours, minutes):
    if (minutes == 0 or minutes == 15 or minutes == 30 or minutes == 45) :
        if minutes == 0 :
            timeName = hoursToWords[hours] + " " + specialTimes[minutes]
        elif minutes == 15 or minutes == 30:
            timeName = specialTimes[minutes] + " " + hoursToWords[hours]
        else:
            timeName = specialTimes[minutes] + " " + hoursToWords[hours+1]

    else:
        if minutes > 40:
            newMinutes = 60 - minutes
            timeName = minutesToWords[newMinutes] + " minute(s) until " + hoursToWords[hours+1]
        else:
            timeName = minutesToWords[minutes] + " minute(s) past " + hoursToWords[hours]
            

    return timeName

#used to get input for hours from user
# returns int
def setHours():
    while True:
        hours = int(input("please enter the hours: "))
        if hours > 0 and hours < 13:
            return hours
        else:
            print("please enter a valid input")
    
#Used to get input for minutes from user
# returns int
def setMins():
    while True:
        minutes = int(input("please enter the minutes: "))
        if minutes >= 0 and minutes <= 59:
            return minutes
        else:
            print("please enter a valid input")

hoursParam = setHours()
minutesParam = setMins()
result = getTimeName(hoursParam, minutesParam)
print(result)

