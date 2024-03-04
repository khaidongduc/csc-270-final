This lab covers several exercises to help develop skill in using arrays and subroutines in ARM assembly language.

Setup
-
- Save the copy of the array-sum program `arrsum.s` that uses a subroutine. Run it to verify that it works (you can look in the "Data" tab in QTSpim to see the contents of the array), and then make the following changes in it:

- the `endarr` label, as discussed in lab, points to the end of the array in data memory. Modify the summing function in array-sum so that the second argument is the array length in words (the number of integers in it). Use that information, rather than the endarr address, to determine when to end the loop.

- Note Don't use a hard-coded "magic number" for the array size. Instead, in the main program you can calculate the array size after that declaration as: `(endarr - array)/4`. You should be able to accomplish this by loading the two address labels (`ldr`), performing `sub` on them, and then right shifting by two (to divide by four) using `lsr`. You can then pass that value to the subroutine (in an argument register). The advantage of this method over a hard-coded "magic number" is that your calculated ASIZE will automatically change when you change the number of elements in the array.