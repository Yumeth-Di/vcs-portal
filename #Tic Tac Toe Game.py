#Tic Tac Toe Game
import random

listr = [int(1) , int(2) , int(3) , int(4) , int(5) , int(6) , int(7) , int(8), int(9) ]

bg  = f"""{listr[0]}|{listr[1]}|{listr[2]}
{listr[3]}|{listr[4]}|{listr[5]}
{listr[6]}|{listr[7]}|{listr[8]}
"""
print(bg)


x = int(input("Where do u want to put the mark : "))

listr[(x-1)] = "*"

bg  = f"""{listr[0]}|{listr[1]}|{listr[2]}
{listr[3]}|{listr[4]}|{listr[5]}
{listr[6]}|{listr[7]}|{listr[8]}
"""
print(bg)

listp = [item for item in listr if type(item) == int]
n = random.choice(listp)

listr[n] = "@"

bg  = f"""{listr[0]}|{listr[1]}|{listr[2]}
{listr[3]}|{listr[4]}|{listr[5]}
{listr[6]}|{listr[7]}|{listr[8]}
"""

print(bg)

po0 = 2,4,5
po1 = 1,4,5,6,3
po2 = 2,5,6
po3 = 1,2,5,8,7
po4 = 1,2,3,4,6,7,8,9
po5 = 3,2,5,8,9
po6 = 4,5,8
po7 = 7,4,5,6,9
po8 = 6,5,8

polist = [po0, po1, po2 ,po3, po4 ,po5 ,po6 ,po7, po8]

truepos = polist[n]
def function03():
    for i in polist[n]

def function04():
    pass

def function08():
    pass

y = input("Enter ur second value : ")

if len(polist[n]) == 3:
    function03()

elif len(polist[n]) == 4:
    function04()

elif len(polist[n]) == 8:
    function08()
  

