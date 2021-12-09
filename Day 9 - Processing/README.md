# [Day 9](https://adventofcode.com/2021/day/9) in [Processing](https://processing.org/)
## With visualization!

Solution is in folder named "sketch" due to the requirement of Processing platform.

### Additional input information that might be provided in the code
* Delay between frames (default: 250ms)
* Delay between last frame and first frame (animation loops) (default: 1500ms)
* Size of one rectangle (default: 9px)
* Size of the window (default is 900x900 for input 100x100 and rectangle size 9)
* Colours might be potentially changed by chenging fills in `setGroundFillByValue` and `setWaterFillByValue` depending on the number in input in given place

###### This is not the peak of visualizing and it could be done much more efficiently, but I tried to have separate logic for solving the problem (it happens in setup part) and drawing - thats why answers are in console and are presented before the first frame of the animation