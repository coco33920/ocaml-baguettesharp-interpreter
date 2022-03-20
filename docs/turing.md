# Binary Turing Machine
## Introduction
Here is the "tutorial" explaining the implementation of a Binary Turing Machine in Baguette#  
The machine is based on this [python](https://sandipanweb.wordpress.com/2020/08/08/simulating-a-turing-machine-with-python-and-executing-programs/) machine and adapted for Baguette#, it served to implement String and Array manipulation instruction in B#.  
The present page is translated from the French [TIPE report](https://github.com/coco33920/rapport_tipe).

## Specification
An infinite RAM is not possible in real life, so here is the specification of the implemented machine
- The tape is of length 1000 initialized with *2* characters because as a binary machine 2 is not part of the alphabet (which is {0,1})
- The input is placed at the index 500 and the head is placed at the first character of the input 
- Programs are a list of lines of form STATE-READ-TOWRITE-DIRECTION-NEWSTATE, e.g. if when we read a 1 in the 0 state we 
move right, and we transfer to machine state 1 we will write 0-1-2-r-1
- The limit, for performance reason is 100 states, but this number is modifiable in the code (when matrices are created)
- The end state is "H", a right translation of the head is "r", a left translation is "l" and a null-translation is "*"
  
## Initialization 
The code of the initialization is shown bellow  
![init](img/turing/init.png)      
In the first line we init the initial state of the machine to "0", we then ask the input tape to the user (the input of the program). The next line is not entirely shown, it initialize the tape as a 500 length "22..." string then the input then a 500 length "22..." string.  
The most important thing here is the *TARTEALARHUBARBE* instruction call, it constructs a matrix of size *n* by *p* (here 100 by 3) initialized with 0 everywhere. These three matrices will store the program. Two other variable *n* and *i* are there to control the program loop, *n* is the number of line of the program and *i* is init at 0 (this will be the variable of looping)