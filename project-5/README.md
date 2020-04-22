# Project 5: Using Interrupts

## Videos
### Requirement 1
![](p5r1.gif)

### Requirement 2
![](p5r2.gif)

### Requirement 3
![](p5r3.gif)

### Requirement 4
![](p5r4.gif)

### Requirement 5
![](p5r5.gif)

## Notes
This project is an ARM Assembly implementation of using interrupts with RealDigital's Blackboard Rev D. The link detailing overall requirements and documentation is posted.

### Part 1
This part was mostly figuring out which bit fields to manipulate for corresponding GIC/interrupt configuration using UART1 (ID 82). I also referred to the ZYNQ manual to determine which sensitivity the UART interrupt configuration needed: high level, which meant no change from GPIO configuration. The handler, once the interrupt system had been configured, was relatively simple: if interrupt if ID 82 was detected, then get a UART char and send a UART char.

### Part 2
The GPIO module configuration was slightly less problematic because example code already configured interrupt 52, which is the GPIO interrupt ID. Beyond that, the rest of the requirement entailed hooking the RGB code into a GPIO handler.

### Part 3
Both configuring interrupt 27 in the GIC and configuring the GTC for the correct interrupt timing was most time consuming here. I originally started programming the TTC as a timebase because realizing the requirements required to use a GTC as a timebase. This actually made the process simpler, as less configuration was needed: only a little bit of math to determine the value the timer can count to in one second (spoiler: at 3ns per iteration, this is a pretty large number)!

### Part 4
This part was essentially moving the code from the previous 3 parts (which I had already been constructing in a switch in my handler: which made this very trivial) into main, and then modifying my handler to only pass flags back to main. Note that two additional flags were needed for button presses for part 2, as it was impossible to read their flag (and thus determine if they were pressed or not) after having cleared the flags inside of the interrupt handler.

### Part 5
Since some of the problem description was slightly vague, I took it upon myself to decide some of the paradigms of this LED blinking system. Mostly, the following is how I decided it should be structured:
* The number of cycles should be read in only once. This would allow UART interrupts to be disabled totally for the rest of the program lifecycle.
* The default state of the system is 'stopped'. That is, the user has to press btn4 (or 'start') for timer interrupts to be enabled.
* (Although this was mentioned in the problem description); the sequence can be stopped either by it completing the number of specified cycles or by the user pressing btn5 ('stop').
Also note that I changed the LED from all diodes on to only the blue diode, as staring at a bright white LED was hurting my eyes. All that changes to change the color is changing what value the `toggle_led()` function writes to the LED register.
