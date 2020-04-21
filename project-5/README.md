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

## Notes
This project is an ARM Assembly implementation of using various UART functions with RealDigital's Blackboard Rev D. The link detailing overall requirements and documentation is posted.

### Part 1
This part was mostly figuring out which bit fields to manipulate for corresponding GIC/interrupt configuration using UART1 (ID 82). I also referred to the ZYNQ manual to determine which sensitivity the UART interrupt configuration needed: high level, which meant no change from GPIO configuration. The handler, once the interrupt system had been configured, was relatively simple: if interrupt if ID 82 was detected, then get a UART char and send a UART char.