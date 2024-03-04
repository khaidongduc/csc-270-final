This lab is an introduction to the ARMSim# simulator for the ARM processor. 
This webpage will be useful to get you started  https://webhome.cs.uvic.ca/~nigelh/ARMSim-V2.1/

1. Launch the ARMSim# application. 
    - Note the layout of the windows. The register values are along the left hand side, and the "base" assembly code is in the "CodeView" segment. 
    - Go into `Files -> Preferences -> Plugins` and enable `LegacySWIInstructions`.

2. Down load the file `sum.s`, saving it to you Lab 5 directory, and open it up with a text editor.
    - The first thing you will notice is the comments begin with the `@` sign. Everything on the right of these lines are ignored.
    - Next you will notice a `.data`section and a `.text` section. The `.data` section is how to specify data to load into data memory, and the `.text` section is the relevant assembly code.
    - You'll also notice these "tags" along the left hand side of the text. Tags are mnenomics, or short-hand, for data memory locations. When you're writing assembly code, you can specify an immediate value via a tag, instead of specifying the memory location directly (this makes sense, because you never actually know where data will wind up in memory until the code is assembled and linked -- a topic we'll get to later this week)
    - Some more detail on the code: the text segment starts at address 0x00001000. It knows to jump into `main` through the tag `.global main`. The program when `swi 0x11` or `swi SWI_Exit` is called, or if it is the end of file.
3. Load `sum.s` into ARMSim#.
4. Go to `View -> Memory`. Find the `.data` segment in the loaded code. On the tags, there are memory addresses to the location of `num1`, `num2`, and `num3`. Input these addresses into the `MemoryView` (top left corner) to see their placement in memory.
5. Run the program and record the value printed to the console.
6. Set break point at every `ldr` command and every add instruction, then run the code using the `Step Into` button on the left most of the toolbar. You will notice that the value of your registers updates each time you hit a breakpoint. <ins> Record the value of the registers at a couple of breakpoints by taking a screenshot </ins>.
    - Don't go crazy on screenshots. I just need to enough to know your register values are changing.
7. Edit a copy of `sum.s` (call it `sum2.s`), changing the three ingers being summed, and rerun the program. Add breakpoints, run the code again and record the value of the register <ins> before, during, after execution in order to demonstrate that it works</ins> (again don't go crazy with screenshots, just show me it works).
8. Write an ARM assembly-language program (`swap.s`) that will swap the contents of two elements of an array, given the arrat and the indices of the elements to be swapped. Run the program and print screen snapshots of the data window <ins> before and after </ins>. Mark the variable locations whose contents have been exchanged. Some notes:
    - To declare an array do something like the following
        -  ar: .word 1, 2, 3, 4 @ a 4-element array    
        - For the indices, use two more integer variables declared in the data section with .word
        - you will need to use the instruction `ldr` to load the address of a labeled variable into a register.  example: `ldr r0, =ar`

9. Hand In:    
    - your assembly files (`sum2.s` and `swap.s`) be sure your name is written on the top of each file! annotated screenshots of relevant portions above (enough to show me that registers change and your code is doing what you expect).

10. How I will test your code:
    - I will run `swap.s` on a variety of different array inputs, and confirm correct behavior.