#  Advent of Code 2021

## Uncompleted Puzzles

### Day 15 - Chiton
I know it's Dijkstra's algorithm. I know I could look it up, but I want to research and implement it myself.

### Day 19 - Beacon Scanner
This one I didn't really look at when it first came out so I haven't really tried it.

### Day 21 - Dirac Dice (Part 2)
Another where I didn't really try the second part at the time due to the obvious complexity of it. The working code for Part 1 doesn't really have any bearing on Part 2, it's too different.

### Day 22 - Reactor Reboot (Part 2)
The working code for Part 1 is pretty much brute force. Part 2 requires a more efficient solution.

You could have a `Cube` created with `ClosedRange<Int>` as the dimensions for each axis. The product of all the axis would give the volume.
You could subtract a cube from another by calculating the volume of the first, then the intersection with the second, then subtracting that intersecting volume from the original volume.
You could add 2 cubes together by calculating the volume of both, then the intersection with each other, then subtracting 1 intersection from the total volume to account for the intersecting volume only counting once.

When adding/subtracting a cube, you could split the remaining cube into 6. If some parts would have some 0 dimension, discard them entirely.

### Day 23 - Amphipod
It's pretty close to Towers of Hanoi, but more complex due to the extra rules and the valid positions where 'amphipods' can go in between their source and destination. 
With sufficient rules it might be easy enough to implement.

### Day 24 - Arithmetic Logic Unit
I have working brute force code, but it will take too long to calculate the number.
There's possibly a memory leak in the code, because the memory usage shouldn't be increasing. Maybe use instruments to try and track the memory usage and find out what's causing it to be so high.
Alternatively, it might be possible to work out the input number by reversing the instructions. 'mod' might require recursively checking multiple next steps, and I don't know if 'eql' would work without trying it.

### Day 25 - Sea Cucumber (Part 2)
Requires all other puzzles to be solved first. 

