@@ Insertion sort using a subroutine.
@@ Khai Dong, March 04 2024


.equ SVC_Exit, 0x11         @ kill code
.equ SVC_PrInt, 0x6B        @ print int code
.equ SWI_PrStr, 0x69        @ Write a null-ending string 

.equ Stdout, 1              @ stdout code

                .data
array:          .word -96, 9, -72, 96, -24, 18, -71, -18, 83, -50, 9, 54, -23, -67, -2, 6, -32, -97, -46, 11
endarr:
spce:           .ascii " \0"
endline:        .ascii "\n\0"
before_msg:     .ascii "Array before sorting: \0"
after_msg:      .ascii "Array after sorting: \0"
        
.section .text
.global main

main:   mov r0, #Stdout       @ print start message
        ldr r1, =before_msg           
        svc SWI_PrStr         @ system call code for print_str

        ldr r0, =array        @ r0 points into array
        ldr r2, =endarr       @ r1 points to array end
        sub r1, r2, r0        @ calculate 4 * array length
        lsr r1, r1, #2         @ divide the previous result by 4, and set $s2 to that value
        
        push {lr}
        push {r0, r1}         @ store r0 and r1 in the stack, no s-registers
        bl print_arr
        
        pop {r0, r1}
        push {r0, r1}         @ store r0 and r1 in the stack, no s-registers
        bl isort

        mov r0, #Stdout       @ print end message
        ldr r1, =after_msg           
        svc SWI_PrStr         @ system call code for print_str 

        pop {r0, r1}
        bl print_arr

        pop {lr}
        mov pc, lr                  

@@ insertion sort subroutine
@@ parameters:
@@	r0: parameter: array addr; used as pointer to current element
@@	r1: parameter: the size of array

isort:  lsl r1, r1, #2
        add r1, r0, r1        @ now r1 is end of array 
        add r4, r0, #4        @ ++ p, start of loop
ploop:  cmp r4, r1
        beq endp              @ p is not end_ar
        mov r5, r4            @ q = p
        ldr r7, [r4]          @ tmp = *p
qloop:  cmp r5, r0
        ble endq              @ !(q > a) then end loop
        ldr r8, [r5, #-4]     @ *(q - 1)
        cmp r8, r7
        ble endq              @ !(*(q - 1) > tmp)
        str r8, [r5]          @ *q = *(q - 1), already loaded into r8
        add r5, r5, #-4       @ q --
        b qloop
endq:   str r7, [r5]          @ *q = tmp
        add r4, r4, #4        @ ++ p, end of loop
        b ploop
endp:   mov pc, lr


@@ printing array subroutine
@@ register use:
@@	r0: parameter: array addr; used as pointer to current element
@@	r1: parameter: the size of array
@@      r4: start address of array
@@      r5: end address of array
@@      $v0: for value storage and printing
@@ will clobber into r0 since print syscall require such behavior
print_arr: 
        mov r4, r0        @ r4 = r0
        lsl r5, r1, #2    @ r1 * 4
        add r5, r4, r5      @ find the end of array r4 + 4 * (r5) 
                          @ clobbering into r5 the address of the end of the array

        mov r0, #Stdout    @ Specify r0 to Stdout
iprint: cmp r4, r5
        bge done           @ while t0 < t1 do

        ldr r1, [r4]       @ get next array element into r1 for syscall
        svc SVC_PrInt             

        ldr r1, =spce
        svc SWI_PrStr      @ print space

        add r4, r4, #4    @ point to next word
        b iprint           @     and do it again

done:   ldr r1, =endline   @ string address to print
        svc SWI_PrStr      @ print the string
        
        mov pc, lr