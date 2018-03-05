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
minutesParam = 0
hoursParam = 0

def getInput():
    return 0

#getTimeName
# params:
# return:
#
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


thing = getTimeName(12, 58)
print(thing)

