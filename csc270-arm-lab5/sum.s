@ sum.s 
@ Elementary program to add three numbers and store and print the sum.
@ Author: Khai Dong {dongk@union.edu} - March 03 2024
@ Register uses
@   r0: stored the loaded value
@   r1: store the sum accumulation

@ Local Constants
.equ SWI_Exit, 0x11         @ kill code
.equ SWI_PrInt, 0x6B        @ print int code
.equ Stdout, 1              @ stdout code

        .data               @ Start of data section
num1:   .word       17      @ 3 integers value
num2:   .word       -35
num3:   .word       276

.section .text
.global main

main:                       @ main(){
        ldr r0, =num1       @   tmp = &num1
        ldr r0, [r0]        @   tmp = *tmp
        add r1, r1, r0      @   acc = acc + tmp
        ldr r0, =num2       @   tmp = &num2
        ldr r0, [r0]        @   tmp = *tmp
        add r1, r1, r0      @   acc = acc + tmp
        ldr r0, =num3       @   tmp = &num3
        ldr r0, [r0]        @   tmp = *tmp
        add r1, r1, r0      @   acc = acc + tmp

        mov r0, #Stdout     @   destination, write to stdout
        mov r1, r1          @   value of r1
        svc 0x6B            @   print int

        svc 0x11            @   Exit}