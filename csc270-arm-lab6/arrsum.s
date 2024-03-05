@ arrsum.s 
@ Elementary program to add three numbers and store and print the sum.
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
        ldr r1, =endarr     @   endarr = endarr

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
@@	r1: parameter: points just after the array end
@@	r4: pointer to current value of the array
@@	r5: temporary copy of current array element
@@      r6: temporary copy of the sum before copying it into r0 at the end
arrsum: mov r4, r0          @ *p = arr
        mov r5, #0          @ sum = 0
loop:   cmp r4, r1          @ while(p != endarr){  
        beq arrsum_ret      @   
        ldr r6, [r4]        @   tmp = *p
        add r5, r5, r6      @   sum = sum + tmp
        add r4, r4, #4      @   p += 1
        b loop              @}
arrsum_ret:
        mov r0, r5          @ return sum; 
        mov pc, lr          @