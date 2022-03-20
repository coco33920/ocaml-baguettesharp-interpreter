# Binary Turing Machine
## Introduction
Here is the "tutorial" explaining the implementation of a Binary Turing Machine in Baguette#  
The machine is based on this [python](https://sandipanweb.wordpress.com/2020/08/08/simulating-a-turing-machine-with-python-and-executing-programs/) machine and adapted for Baguette#, it served to implement String and Array manipulation instruction in B#.  
The present page is translated from the French [TIPE report](https://github.com/coco33920/rapport_tipe).

## Specification
An infinite RAM is not possible in real life, so here is the specification of the implemented machine
- The tape is of length 1000 initialized with *2* characters because as a binary machine 2 is not part of the alphabet (which is $\{0,1\}$)
- The input is placed at the index 500 and the head is placed at the first character of the input 
- Programs are a list of lines of form STATE-READ-TOWRITE-DIRECTION-NEWSTATE, e.g. if when we read a 1 in the 0 state we 
move right, and we transfer to machine state 1 we will write $0-1-2-r-1$
- The limit, for performance reason is 100 states, but this number is modifiable in the code (when matrices are created)
- The end state is $H$, a right translation of the head is $r$, a left translation is $l$ and a null-translation is $*$
  
## Initialization 
The code of the initialization is shown bellow  
![init](img/turing/init.png)      
In the first line we init the initial state of the machine to "0", we then ask the input tape to the user (the input of the program). The next line is not entirely shown, it initialize the tape as a 500 length "22..." string then the input then a 500 length "22..." string.  
The most important thing here is the *TARTEALARHUBARBE* instruction call, it constructs a matrix of size $n$ by $p$ (here 100 by 3) initialized with 0 everywhere. These three matrices will store the program. Two other variable $n$ and *i* are there to control the program loop, $n$ is the number of line of the program and $i$ is init at 0 (this will be the variable of looping)  

## Program reading
To read on the standard input, we must emulate a conditional loop, the Baguette# do not implement loops natively. We will use for that goal the two predefined variable $n$ and $i$, the instruction *ICECREAM \<string>* to construct **LABELS**, the *PAINVIENNOIS \<string>* instruction to **JUMP** to the designed *label*, and finally a conditional test, **SABLE \<condition> \<label>**  

Here is the algorithm of the program reading loop  
* Read STDIN
* Split the line at each `-` character 
* Fill the three defined matrices with corresponding part of the program (see [here](#initialization))
* Increment $i$
* Check if $i$ is superior or equal to $n$
* If $i\geq n$ then it quit the loop
* If $i<n$ it **JUMP** to itself

This algorithm implemented gives twenty-three lines of code available on [GitHub](https://github.com/coco33920/ocaml-baguettesharp-interpreter/blob/master/examples/turing.baguette#L3)  
Once this algorithm is completed we have read the whole program

## One Step
We then need to implement a *step* of the program. We will also use a **LABEL** to separate this from the main code and allow the future run-loop to work. The *labels* are not properly functions, the *scopes* of the whole program is shared regardless where we are, this allows us to approximately emulate how functions works with labels. The most used instruction will be *TARTEAUXFRAISES*, which is the access of the *n-th* element of an array.  

A step should do these steps
* Verify the current machine state is different from $H$. The following steps are in the case when this is $true$
* Read the tape where the reading head is and obtain the state of the tape noted $e$, the state of the machine is $s$
* Access what we should write in the first matrix at coordinates $(s,e)$
* Access the direction we should translate the head in with the second matrix at coordinates $(s,e)$
* Access the new state of the machine in the third matrix at coordinates $(s,e)$
* Modify the tape with what we should write
* Update the machine state with the new state
* Translates the head according to if we read $r$, $l$ or $*$
* Prints the tapes (without the 2s) and the state of the machine
  
The implementation in Baguette# of this code is available on [GitHub](https://github.com/coco33920/ocaml-baguettesharp-interpreter/blob/master/examples/turing.baguette#L26), until the 58th line. This piece of code is only performing *one* step. We now need to implement the loop.