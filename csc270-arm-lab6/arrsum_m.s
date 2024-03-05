@ arrsum_m.s 
@ Elementary program to add three numbers and store and print the sum.
@ modify the subroutine to accept the start of the array and its length
@ modify the loop structure
@ Author: Khai Dong {dongk@union.edu} - March 03 2024

@ Local Constants
.equ SVC_Exit, 0x11         @ kill code
.equ SVC_PrInt, 0x6B        @ print int code
.equ Stdout, 1              @ stdout code

        .data               @ Start of data section
arr:    .word       1, 2, 3, 4, -2, -5      @ arrays of value
endarr: 
idx1:   .word       1       @ first index
idx2:   .word       3       @ second index

.section .text
.global main

main:                       @ main(){
        ldr r0, =arr        @   arr = arr 
        ldr r2, =endarr     @   endarr = endarr
        sub r1, r2, r0
        lsr r1, r1, #2

        push {lr}           @   store lr into the stack
        bl arrsum           @   arrsum(arr, endarr)
        pop {lr}            @   pop lr from the stack

        mov r1, r0          @   print out of the sum
        mov r0, #Stdout     @   destination, write to stdout
        svc SVC_PrInt       @   print int

        mov pc, lr          @   return 0}


@@ array-summation subroutine
@@ register use:
@@	r0: parameter: array addr; used as pointer to current element
@@	r1: parameter: the length of the array
@@	r4: pointer to current value of the array
@@	r5: temporary copy of current array element
@@      r6: temporary copy of the sum before copying it into r0 at the end
arrsum: lsl r1, r1, #2       @ byteoffset
        add r1, r0, r1       @ r1 = arr + arrsize
        mov r4, r0           @ *p = arr
        mov r5, #0           @ sum = 0
        
        b loop               @ jump into the loop
do:     ldr r6, [r4]         @ tmp = *p
        add r5, r5, r6       @ sum = sum + tmp
        add r4, r4, #4       @ ++ p
loop:   cmp r4,  r1          @ compare if at end of array
        bne do

        mov r0, r5           @ return sum
        mov pc, lr           @