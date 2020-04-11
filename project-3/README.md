# Project 3: Building a Stopwatch using ZYNQ TTC
## Notes
I did this project horrifically late (and I mean horrifically), which was mostly due to hitting a roadblock in terms of implementation (although I had the general pseudocode for the digit-increment system I ended up using about the week before spring break).

This project is an ARM Assembly implementation of creating a digital stopwatch using RealDigital's Blackboard Rev D. The link of requirements is posted, and below is a general discussion of each part of the project.

### Part 1
This part wasn't incredibly difficult for me once I had actually done some reading, especially since the majority of the hurdle was writing code to work around the 7 segment display's GPIO. I will say these functions are incredibly messy (and I have no doubt there are ways to complete the same tasks with less lines), they work incredibly reliably.

### Part 2
This was my first major roadblock that corresponds to most of the delay of this project. I kept hitting dissassembly errors and triggering interrupts to the point I got incredibly frustrated and had to step back from the project. Coming back to it, I worked out a revised system of my original increment pseudocode, which worked, except the increment had some timing errors.
I found out later this was due to my neglect to correctly poll for incrementing, which is unfortunately something I didn't realize until I completed the very last part(!). I then reworked my code again to hopefully poll correctly, and now the incrementation is truly every button press.
My actual increment code is essentially recursive: it works off of a counter, which determines which digit is currently being incremented, and the address offset that is calculated based on that counter (counter * -4). It then essentially recursively increments digits, carrying a 1 anytime a digit is 9 prior to increment to the next digit.

### Part 3
This is where things start getting a little messy (if it wasn't already), but still functional. Since it took me forever to figure out how polling loops actually worked (until I sort of gave up on this part and started work on part 4), my timing was horrifically off when I grabbed button values, and the toggle between 'start' and 'stop' loops wasn't exactly perfect. I essentially XORed a status bit (r0) with #1 every time an edge between two button reads was detected (the problem was that I did these sequentially, without waiting for a change in state on the second reading).
I eventually revised this so increment works on a true button press, but the way I arranged my start/stop toggle (especially when the counter is ticking-- we don't want to stop to poll for button press while the timer is running) still had some delay. But, I'm relatively happy with it, so that's the final version.

### Part 4
Other than the polling revelation that I had at this point that caused me to retroactively fix my code because I'm a perfectionist (though clearly not entirely), this part was pretty simple. I began working out the math for an accurate timebase, but sort of decided just to go with the 0.995ms (it's good enough for me).

### Challenge
I only really half-attempted the first challenge (on accident really) because I'd rather get going on the other projects. But, due to the way my increment function works due to part 2 (and my counter uses the same increment logic), you can technically control how fast the counter increments by the switches. While I know this is backwards (counter works faster the more switches are ticked), technically the switches impact the speed of execution.
That being said, it seems pretty trivial to me to alter the TTC timebase (just LSR the interval for 1ms, which is 1KHz (1000 times per second) by the current switch value).
