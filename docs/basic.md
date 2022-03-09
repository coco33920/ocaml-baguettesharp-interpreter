# Basic Usage
## Links
[Next Page : Advanced Usage](advanced.md) 
[Previous Page](repl.md)
## Support
The language currently supports 
* Basic IO on standard IO
* Mathematic manipulations on float/integers
* Boolean Algebra
* Array manipulations
* String manipulations
* Variables

## IO
Three instruction are available to handle IO
* `CROISSANT` is the general `print` function it natively supports printing integers, boolean, floats and strings 
* `PAINAUCHOCOLAT` is the general `printf` function, the only placeholder is `%d` 
* `ECLAIR` is the read standard input function. If you use it without args like that:
```baguette
ECLAIR CHOUQUETTE CLAFOUTIS
```
it passes the input through the type inference algorithm, i.e
typing `1` in the standard input will gives you an integer of value `1` while if you use it with any argument like this
```baguette
ECLAIR CHOUQUETTE 0 CLAFOUTIS
```
it gives you a string of the input, without passing it through the type inference algorithm.

## Mathematics
The entire list of instructions available and supported by the language is available in the [wiki](https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki/Instructions#maths).

The majority of these instructions supports indifferently integers and floats (the two type are named `numbers`). However, the result will be displayed as a float if you supply at least one argument as a float, even if it could be an integer, as seen here

![float](img/float.png)

You should pass the answer through the floor function if you need an integer

![floor](img/floor.png)

## Boolean algebra
### Booleans 
* `CUPCAKE` is `true`
* `POPCAKE` is `false`
### Algebra
All operators are functions, the list of baguette translation is available on the [wiki](https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki/Instructions#boolean-algebra)

The language supports 
* `OR`
* `AND`
* `XOR`
* `NOT`
* `=`
* `>`
* `>=`
* `<`
* `<=`

## Array Manipulations
The language supports basic array manipulations, the whole list is once again available on this page of the [wiki](https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki/Array-and-String-Manipulation#Array)
* `[` is `BABAAURHUM`
* `]` is `CHARLOTTEAUXFRAISES`

The separator between arguments is either a blank 
if you're using the default lexer or a `comma` with the new lexer, the default lexer reads and ignore the `comma`.

You can 
* Create an array of size `n`
* Create a matrix of size `n` by `p`
* Access to the nth element of an array
* Change the nth element of an array
* Generate a string representation of an array

![display](img/display.png)

## String Manipulations
The language implements natively a string module implementing some useful functions, the translation is available on the string page of the [wiki](https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki/Array-and-String-Manipulation#string) 

* Create a string with `n` times the supplied string
* Concatenate two strings
* Accessing the `nth` character of a string
* Replace all occurrence of `s1` in `s2` by `s3`
* Split a string at each occurrence of a string
* Transforming a string into an array of chars
* Transforming an array of chars into a string

Example:
![d](img/string.png)

### Conversion from string
You can convert string to integers/floats/booleans, for example:
```baguette
CARROTCAKE CHOUQUETTE PARISBREST 12 PARISBREST CLAFOUTIS
```
converts a string to an integer
![ifs](img/ifs.png)

while 
```baguette
GALETTEDESROIS CHOUQUETTE PARISBREST 12.2 PARISBREST CLAFOUTIS 
```
converts a string to a floating point numbers
![dfs](img/dfs.png)

and 
```baguette
FRANGIPANE CHOUQUETTE PARISBREST true PARISBREST CLAFOUTIS
```
![bfs](img/bfs.png)

An `EXCEPTION` is raised if you supply a parameter which is not convertable.

![ifserror](img/ifserror.png)

### Conversion to string 
The conversion to string is the same instruction for every type, it is `FROSTING`
```baguette
FROSTING CHOUQUETTE 10000 CLAFOUTIS
```

![str](img/frosting.png)

## Variables 
Baguette# do not have a real system of scopes and variables, all registered pseudo-variable with the `QUATREQUART` instruction are readable with the `MADELEINE` instruction everywhere in the program.

It allows developing function-like labels which can uses and manipulates the pseudo-variables defined in the program, in the label.

To learn more about variable, labels and gotos usage see the [advanced usage](advanced.md) page !

