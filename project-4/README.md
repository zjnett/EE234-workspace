# Project 4: UARTs

## Videos
### Requirement 1
![](p4r1.gif)

### Requirement 2
![](p4r2.gif)

### Requirement 3
![](p4r3.gif)

### Requirement 4
![](p4r4.gif)

### Requirement 5
![](p4r5.gif)

### Requirement 6
![](p4r6.gif)

## Notes
This project is an ARM Assembly implementation of using various UART functions with RealDigital's Blackboard Rev D. The link detailing overall requirements and documentation is posted.

### Part 1
Relatively straightforward, especially with the tutorial posted as reference, along with the example code spread throughout the documentation. Essentially, we read if the FIFO status bit for transmitting is 0 (else keep polling), or essentially that the transmit FIFO isn't full. When it isn't, simply write a character to the FIFO.

### Part 2
This part was also straightforward-- essentially we're just polling a different status bit to see if the FIFO is empty. If the FIFO isn't empty, then we simply read the character in it. Toggling LEDs in the subroutine also was pretty straightforward-- just compare r0 (the parameter, or character) and XOR the corresponding LED bit if equal.

### Part 3
This was maybe slightly different than the last two parts, but algorithmically pretty similar to processing a string in C. No real difficulties here, although I embellished a little bit and added a super long string (and a newline string) just because I could.

### Part 4
This part took me maybe slightly longer than the others just because of the logic around processing for a newline and checking to see if there was enough space left to store the string (since I misinterpreted the problem and started scanning for a null character. I then thought #10 was the value for newline, not #13, and then got my parameter registers a little mixed up-- other than that, this part wasn't too bad.

### Part 5
Man, I almost wish that there was something up front in this project that said: "Hey, use r0 and r1 for your parameters in your send and receive functions, because otherwise you'll look like an idiot when you call them in C."

Suffice it to say, I look like an idiot, passing garbage parameters all over the place when I call my assembly subroutines from C. (Maybe this is a sign that my assembly code isn't optimal... well, we all know that.) All that said, once I got the parameter order down, embedding a C main method was pretty easy. The documentation also didn't really specify that you need to make a main.c file and declare your assembly subroutines as global in your .S file, but I figured it out.

### Part 6
Remaking in them in C went much smoother than making them than in assembly the first time (maybe because I didn't need to do weird comparison loop structures, and could finally use the for/while/do-while constructs I'm familiar with). I chose not to rewrite the reset_uart function because it wasn't required and actually was provided in the documentation regardless, so I just called it as an external function like the previous requirement. Otherwise, the C functions are pretty standard string processing loops.
