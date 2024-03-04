@ sum.s 
@ Elementary program to add three numbers and store and print the sum.
@ Author: Khai Dong {dongk@union.edu} - March 03 2024
@ Register uses
@   r0: stored the loaded value
@   r1: store the sum accumulation

@ Local Constants
.equ SVC_Exit, 0x11         @ kill code
.equ SVC_PrInt, 0x6B        @ print int code
.equ Stdout, 1              @ stdout code

        .data               @ Start of data section
arr:    .word       1, 2, 3, 4, -2, -5      @ arrays of value
end_arr: 
idx1:   .word       1       @ first index
idx2:   .word       3       @ second index

.section .text
.global main

main:                       @ main(){
        ldr r0, =arr        @   *p = arr
        ldr r1, =idx1       @   i = &idx1        
        ldr r2, =idx2       @   j = &idx2

        ldr r1, [r1]        @   i = *i
        lsl r1, r1, #2      @   byteoffset
        add r1, r0, r1      @   i = arr + i

        ldr r2, [r2]        @   j = *j
        lsl r2, r2, #2      @   byteoffset
        add r2, r0, r2      @   j = arr + j

        ldr r3, [r1]        @   tmp1 = *i
        ldr r4, [r2]        @   tmp2 = *j
        str r3, [r2]        @   *i = tmp2
        str r4, [r1]        @   *j = tmp1
        
        svc SVC_Exit        @}