# Project 4: UARTs

## Videos
### Requirement 1
To be added.

### Requirement 2
To be added.

### Requirement 3
To be added.

### Requirement 4
To be added.

### Requirement 5
To be added.

### Requirement 6
To be added.

## Notes
This project is an ARM Assembly implementation of using various UART functions with RealDigital's Blackboard Rev D. The link detailing overall requirements and documentation is posted.

### Part 1
Relatively straightforward, especially with the tutorial posted as reference, along with the example code spread throughout the documentation. Essentially, we read if the FIFO status bit for transmitting is 0 (else keep polling), or essentially that the transmit FIFO isn't full. When it isn't, simply write a character to the FIFO.

### Part 2
This part was also straightforward-- essentially we're just polling a different status bit to see if the FIFO is empty. If the FIFO isn't empty, then we simply read the character in it. Toggling LEDs in the subroutine also was pretty straightforward-- just compare r0 (the parameter, or character) and XOR the corresponding LED bit if equal.
